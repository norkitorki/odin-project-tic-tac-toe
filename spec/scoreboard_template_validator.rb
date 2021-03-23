module ScoreboardTemplateValidator
  def to_s_defined?(object)
    object.respond_to?(:to_s)
  end

  def update_score_defined?(object)
    object.respond_to?(:update_score)
  end
end
