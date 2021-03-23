module PlayerTemplateValidator
  def name_defined?(object)
    object.respond_to?(:name)
  end

  def piece_defined?(object)
    object.respond_to?(:piece)
  end
end
