module Minitest::Assertions
  def assert_validates_presence_of(model, attribute)
    assert_invalid_with :blank, _subject(model), attribute, nil
  end

  def assert_valid_with(error_key, subject, attribute, value)
    assert_errors :wont_include, error_key, subject, attribute, value
  end

  def assert_invalid_with(error_key, subject, attribute, value)
    assert_errors :must_include, error_key, subject, attribute, value
  end

  def valid_assigns(name)
    assigned = assigns name
    assigned.errors.messages.must_be_empty
    assigned
  end

  private
  def _subject(model)
    return model      if model.respond_to? :valid?
    return model.new  if model.respond_to? :validators
    # model is the spec block itself
    model.class.name.constantize.new
  end

  def assert_errors(assertion, error_key, subject, attribute, value)
    subject.send "#{attribute}=", value
    subject.valid?
    errors = subject.errors.messages[attribute] || []

    # errors.[must|wont]_include error_message, assertion_message
    errors.send assertion, error_message(error_key), message {
      value = :nil    if value.nil?
      value = :blank  if value.blank?
      "validating #{subject.class.name} with :#{attribute} set to #{value}"
    }
  end

  def error_message(error_key)
    I18n.t "errors.messages.#{error_key}"
  end
end
