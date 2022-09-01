class IMCSerializer
  def initialize(imc)
    @imc = imc
  end

  def as_json
    {
      imc: @imc.level_result,
      classification: @imc.classification,
      obesity: @imc.obesity_level
    }.to_json
  end
end
