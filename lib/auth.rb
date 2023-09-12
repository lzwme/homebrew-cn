# frozen_string_literal: true

require "cli/parser"
require "readline"
require "io/console"

# Ensures that a specified environment variable is set. If it is not set the
# user is prompted to enter a value for the variable.
# Params:
# +name+:: The name of the variable to ensure.
# +message+:: The message prompting the user to enver a value for the variable.
# +secret+:: If `true` the user input will be hidden (use for secret values).
# +stdin+:: Whether to read the value from sdtin if it is missing.
def ensure_env(name, message: "", secret: false, stdin: false)
  ENV[name] = get_env(message, secret, stdin) if ENV[name].blank?
end

# Fetches a value for the `ensure_env` method.
# Params:
# +message+:: A prompt that may be displayed to the user.
# +secret+:: A boolean value indicating whether the value is a secret.
# +stdin+:: A boolean value indicating whether the value may be read from stdin.
def get_env(message, secret, stdin)
  return $stdin.read if stdin && !$stdin.tty?

  return IO.console.getpass(message) if secret

  print message
  IO.console.gets.chomp
end