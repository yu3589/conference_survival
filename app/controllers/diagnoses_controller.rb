class DiagnosesController < ApplicationController
  def new
    @diagnosis = Diagnosis.new
  end

   def question_params
      params.require(:answers).permit(:question1, :question2, :question3, :question4, :question5).to_h
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
      redirect_to diagnosis_path(@diagnosis.result_type, @diagnosis.token)
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

    unless @diagnosis
      redirect_to root_path, alert: "診断が見つかりませんでした。" and return
    end

    if @diagnosis.result_type != params[:result_type]
      redirect_to diagnosis_path(@diagnosis.result_type, @diagnosis.token) and return
    end

    @result_type = @diagnosis.result_type
    @token = @diagnosis.token

    @url = case @diagnosis.result_type.to_sym
    when :stealth
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751791882/stealth_tbokdp.png"
    when :fade
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751791873/fade_mgulgm.png"
    when :nod
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751791865/nod_hfyldx.png"
    when :sharpness
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751791858/sharpness_je2fss.png"
    when :sleepiness
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751791844/sleepiness_ilyyjj.png"
    else
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751793839/balance_nhz1t4.png"
    end
  end
end
