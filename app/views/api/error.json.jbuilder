formatted_errors = {}
@errors.each { |k, v| formatted_errors[k] = v.join(", ") }

json.errors formatted_errors
