class DiagnosesController < ApplicationController
  def new
    @diagnosis = Diagnosis.new
  end

  EXPECTED_QUESTION_COUNT = 5

  def create
    selected_answers = question_params

    if selected_answers.size < EXPECTED_QUESTION_COUNT || selected_answers.values.any?(&:blank?)
      flash.now[:alert] = "全ての設問に回答してください。"
      @diagnosis = Diagnosis.new
      @selected_answers = selected_answers
      render :new, status: :unprocessable_entity
      return
    end

    scores = calculate_scores(selected_answers)
    @diagnosis = Diagnosis.new(scores)

    if @diagnosis.save
      redirect_to diagnosis_path(@diagnosis.token)
    else
      render :new
    end
  end

  def calculate_scores(answer_params)
    result = {
    sharpness_score: 0,
    sleepiness_score: 0,
    nod_score: 0,
    stealth_score: 0,
    fade_score: 0
  }

    answer_params.each do |_, value|
      next if value.blank?  # 念のため
      value.split(",").each do |item|
        type, score = item.split(":")
        key = "#{type}_score".to_sym
        result[key] += score.to_i if result.key?(key)
      end
    end

    result
  end

  def result
    @diagnosis = Diagnosis.find_by(token: params[:token])
    redirect_to root_path, alert: "診断が見つかりませんでした。" unless @diagnosis
  end

  private
    def question_params
      params.require(:answers).permit(:question1, :question2, :question3, :question4, :question5).to_h
    end
end
