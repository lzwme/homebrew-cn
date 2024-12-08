class PythonArgcomplete < Formula
  include Language::Python::Virtualenv

  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/7f/03/581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0/argcomplete-3.5.2.tar.gz"
  sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8b7829e5fd8c999a660b00883d9d3248b2d47dee4d61331dbfee5d4bf3aac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8b7829e5fd8c999a660b00883d9d3248b2d47dee4d61331dbfee5d4bf3aac7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e8b7829e5fd8c999a660b00883d9d3248b2d47dee4d61331dbfee5d4bf3aac7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b6289240b4147763f00414c6a4b0409b9a12ac227d788260edee2a57ec782a"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b6289240b4147763f00414c6a4b0409b9a12ac227d788260edee2a57ec782a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e350488c4428b1c70162e67c9060b24e2c0ff5217b228322e248ab90cb9e6fe"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end