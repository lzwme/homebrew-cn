class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/2f/c9/18d4b36606d6091844daa3bd93cf7dc78e6f5da21d9f21d06c221104b684/virtualenv-21.1.0.tar.gz"
  sha256 "1990a0188c8f16b6b9cf65c9183049007375b26aad415514d377ccacf1e4fb44"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1de7783b55866f9c57ff164856028674d352fef41184940a21997f3572b3fed5"
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
    url "https://files.pythonhosted.org/packages/82/bb/93a3e83bdf9322c7e21cafd092e56a4a17c4d8ef4277b6eb01af1a540a6f/python_discovery-1.1.0.tar.gz"
    sha256 "447941ba1aed8cc2ab7ee3cb91be5fc137c5bdbb05b7e6ea62fbdcb66e50b268"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end