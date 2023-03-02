class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/e2/e8/f3dc919f9fd0a00e387abcf419324f2561969189367b65a849b37e185049/pipdeptree-2.5.0.tar.gz"
  sha256 "ef17672a0ec47ae97ae9d50f98eabe209609ffd08e8b4abdc2e8e20bf499b151"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5790efb6f4eb59970469db6c57ca824504f2c4f052b31e6b954e62bdc0f28a8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd129030fffb3d50c1024da64001ea9aadcff36534faee2d5ea69e9e991faa3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aeb95e0263ba3497ebabd8aeac1009b98c465e2942baa49ebc92096fc7628af"
    sha256 cellar: :any_skip_relocation, ventura:        "51ac5c87e6e6944f1c9986991b4830b8027d68f6969730fba18e32014b8f374c"
    sha256 cellar: :any_skip_relocation, monterey:       "714084f441aed9d5c3e06d79afa8d77d08cf6a12c4dcb2459029374a471e0014"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf311d930b97f8c128be4754f6a6381605935cecfb566de05e56911b3815d217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e2f28e717303485ebf8cb54b8c332419635ccd980ddeddbe59298e859679e3a"
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