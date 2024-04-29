class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https:github.comtox-devpipdeptree"
  url "https:files.pythonhosted.orgpackages9ddbb72e65032bbf4b5b2e4c2efae7fd7fae5eeb879b582c1d34a7efe05401c5pipdeptree-2.19.0.tar.gz"
  sha256 "2051bc730fa878846ff3184c1b6b83d348f606cd1a92b9afca9709334d3d0c03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bf017a776c0da73724bf334e9de2d659fece2d2b56eb0ee11525a79f2de1a90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bf017a776c0da73724bf334e9de2d659fece2d2b56eb0ee11525a79f2de1a90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf017a776c0da73724bf334e9de2d659fece2d2b56eb0ee11525a79f2de1a90"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a44c6eee4b4843abcfa572249eb84fa547e22acb01a4860fa12a24f572398cf"
    sha256 cellar: :any_skip_relocation, ventura:        "9a44c6eee4b4843abcfa572249eb84fa547e22acb01a4860fa12a24f572398cf"
    sha256 cellar: :any_skip_relocation, monterey:       "9a44c6eee4b4843abcfa572249eb84fa547e22acb01a4860fa12a24f572398cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e4b759972510779a69f7581bc254072de32ef7cc6f4553592d9ee1c12bd40a0"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}pipdeptree --all")

    assert_empty shell_output("#{bin}pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}pipdeptree --version").strip
  end
end