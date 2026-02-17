class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/c1/ef/d9d4ce633df789bf3430bd81fb0d8b9d9465dfc1d1f0deb3fb62cd80f5c2/virtualenv-20.37.0.tar.gz"
  sha256 "6f7e2064ed470aa7418874e70b6369d53b66bcd9e9fd5389763e96b6c94ccb7c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f5e31e4cb60880176fcabf04907780de6347ec19dd385b1965d3503100dcbc5"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/02/a8/dae62680be63cbb3ff87cfa2f51cf766269514ea5488479d42fec5aa6f3a/filelock-3.24.2.tar.gz"
    sha256 "c22803117490f156e59fafce621f0550a7a853e2bbf4f87f112b11d469b6c81b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end