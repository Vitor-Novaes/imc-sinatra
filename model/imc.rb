class IMC
  attr_reader :height, :weight, :level_result, :classification, :obesity_level, :errors

  def initialize(params)
    @height = params[:height]
    @weight = params[:weight]
    @obesity_level = '-'
    validation

    @level_result = calculate_imc
    classification_results
  end

  private

  def classification_results
    case @level_result
    when 0..18.5
      @classification = 'Underweight situation'
    when 18.6..24.9
      @classification = 'Optimal Weight situation'
    when 25..29.9
      @classification = 'Overweight situation'
    when 30..34.9
      @classification = 'Obesity situation'
      @obesity_level = 'I'
    when 35..39.9
      @classification = 'Obesity situation'
      @obesity_level = 'II'
    else
      @classification = 'Severe Obesity situation'
      @obesity_level = 'III'
    end
  end

  def validation
    if !@height.instance_of?(Float) || @height.negative? || @height.zero?
      raise TypeError, 'Height must be float number in meters'
    elsif !@weight.instance_of?(Integer) || @weight.negative? || @weight.zero?
      raise TypeError, 'Weight must be integer number in KG'
    end
  end

  def calculate_imc
    (@weight / @height**2).round(1)
  end
end
