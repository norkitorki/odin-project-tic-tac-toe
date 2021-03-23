module GameBoardTemplateValidator
  def files_defined?(object)
    object.respond_to?(:files)
  end

  def to_s_defined?(object)
    object.respond_to?(:to_s)
  end

  def field_defined?(object)
    object.respond_to?(:field)
  end

  def fields_defined?(object)
    object.respond_to?(:fields)
  end

  def columns_defined?(object)
    object.respond_to?(:columns)
  end

  def rows_defined?(object)
    object.respond_to?(:rows)
  end

  def empty_fields_defined?(object)
    object.respond_to?(:empty_fields)
  end

  def full_defined?(object)
    object.respond_to?(:full?)
  end

  def clear_defined?(object)
    object.respond_to?(:clear)
  end
end
