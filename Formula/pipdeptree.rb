class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/1e/8b/18487b209ded619f30dad87b1206c231ae6d6a6e70b6c654fc1cf782447c/pipdeptree-2.11.0.tar.gz"
  sha256 "7d728dae42e13e02e7d45f13e3e1aa7cb3db30ed2d57a49861ff41056d93a3c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "272dea16a10d3ff121e3e037f755554b6383da3be499f087de4d40c508f57434"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36a1a4a0a164b5b7cbb3d9dfd3654311448682af3d9349d4227b0bbd3c61c76e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bb86880181e04e96cc22b9bdfd79f2d945a1f04a75c42484f6364da2e96ed9e"
    sha256 cellar: :any_skip_relocation, ventura:        "cefca19630bd4f47b1b80b7a76320b0f8725a37a0cb6774cc4f292d99b1e8ca2"
    sha256 cellar: :any_skip_relocation, monterey:       "a3745ab9f8cce87312069ceb9cdd3a3cf7ae2c0b98ba0da735ae0dbd2a924e1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "53121bda16b421264bac8d7d2b39c058a4632e1843d1e8864b4dd90204f93c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d49d59ca1f9f7b55fa0b0e410ccbcac058f37be8f010a4d9772ccc56134812c"
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