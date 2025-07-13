class DiagnosesController < ApplicationController
  require "yaml"
  before_action :set_diagnosis_status
  before_action :set_status, only: [ :new ]

  def new
    @diagnosis = Diagnosis.new
  end

   def question_params
      params.require(:answers).permit(:question1, :question2, :question3, :question4, :question5, :question6, :question7, :question8).to_h
   end

  EXPECTED_QUESTION_COUNT = 8

  def create
    selected_answers = question_params

    if selected_answers.size < EXPECTED_QUESTION_COUNT || selected_answers.values.any?(&:blank?)
      flash.now[:alert] = "全ての設問に回答してください。"
      @diagnosis = Diagnosis.new
      @selected_answers = selected_answers

      @status_1 = session[:status_1]
      @status_2 = session[:status_2]
      @status_3 = session[:status_3]
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
      next if value.blank?
      value.split(",").each do |item|
        type, score = item.split(":")
        key = "#{type}_score".to_sym
        result[key] += score.to_i if result.key?(key)
      end
    end

    max_score = result.values.max.to_f
    min_score = 5

    if max_score > 0
      result.each do |k, v|
        normalized = (v / max_score * 100).round(1)
        result[k] = normalized > 0 ? normalized : min_score
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
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751857394/stealth_oh6x3o.png"
    when :fade
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1752378744/fade_xmnjvq.png"
    when :nod
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751857387/nod_v7bt3k.png"
    when :sharpness
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751857380/sharpness_cnjcem.png"
    when :sleepiness
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751857378/sleepiness_fxirif.png"
    else
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751857399/balance_s5ksih.png"
    end
    set_meta_tags(default_meta_tags(url: @url))
  end

  private

  def set_diagnosis_status
    @status = YAML.load_file(Rails.root.join("config", "status.yml"))
  end

  def set_status
    session[:status_1] = @status["status_1"]&.sample
    session[:status_2] = @status["status_2"]&.sample
    session[:status_3] = @status["status_3"]&.sample

    @status_1 = session[:status_1]
    @status_2 = session[:status_2]
    @status_3 = session[:status_3]
  end
end
