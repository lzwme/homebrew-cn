class RubyCompletion < Formula
  desc "Bash completion for Ruby"
  homepage "https:github.commernencompletion-ruby"
  url "https:github.commernencompletion-rubyarchiverefstagsv1.0.0.tar.gz"
  sha256 "ee8b84d7ac7444a7388e58a406af56dc0b690a57faa7bcfa4c10671deb788991"
  license "MIT"
  version_scheme 1
  head "https:github.commernencompletion-ruby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ddef10f9066b45d6d50d2795bfc16b7fbc528145db20e6a7c7714e2a26e3ac83"
  end

  def install
    bash_completion.install "completion-ruby" => "ruby"
  end

  test do
    assert_match "-F __ruby",
      shell_output("bash -c 'source #{bash_completion}ruby && complete -p ruby'")
  end
end