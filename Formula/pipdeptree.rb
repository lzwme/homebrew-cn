class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/85/68/96968fa426c146e7a3bde19b06110e324ed0f5ed3892e63ae356084ebbbd/pipdeptree-2.5.2.tar.gz"
  sha256 "787c994f7d2cff9c3d55750590fd212dabc8ff87e4690624eabb449a49dfd41d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36eaed77aaa23ac260cafda8330ca5d0118901577bc9a963a1ea80468445d454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a26e2aceaabbe42a51f74e2adf3e87028b7e962ec8841569861556ba39681b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c59ae9abaa738c61559e53ae4874c8b0589725aa4502b6fa7bc9c5be5b5b6764"
    sha256 cellar: :any_skip_relocation, ventura:        "09d2f05e2624ab12560d0a5aa95db65d8881782039107c940b5fdc921f8da572"
    sha256 cellar: :any_skip_relocation, monterey:       "8d98e51329c570d7cf7086ab98764423841cdd7adf07f8a4f528183462e83b48"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0e447f6d804aa79a03e882427a2207fce5dd48b2f29cfdb8b98e026664da8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c3fce85d11fad45bea5d8273296b75302172d7b16376287f118dfb3c985981"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end