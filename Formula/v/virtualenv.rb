class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/ce/4f/d6a5ff3b020c801c808b14e2d2330cdc8ebefe1cdfbc457ecc368e971fec/virtualenv-21.0.0.tar.gz"
  sha256 "e8efe4271b4a5efe7a4dce9d60a05fd11859406c0d6aa8464f4cf451bc132889"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ddd253e7022af349f26a1b1630bf14750a372eb514d1aa98935805b03ab477dc"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/73/92/a8e2479937ff39185d20dd6a851c1a63e55849e447a55e798cc2e1f49c65/filelock-3.24.3.tar.gz"
    sha256 "011a5644dc937c22699943ebbfc46e969cdde3e171470a6e40b9533e5a72affa"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/c9/6e/7edab62f9e4bb1d2b81c28fcd67281f38ea4beac4890931501922c83edb9/python_discovery-1.0.0.tar.gz"
    sha256 "8bc352d504f66fd82f93e73f1cbfbf3f3f06d559aafd14c24a7f1f38906ad3e8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end