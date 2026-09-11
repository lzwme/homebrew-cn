class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/52/5c/ba82fdd0da13ade01453fc08277a70abc79128101319549f55f2e13f8f83/virtualenv-21.7.9.tar.gz"
  sha256 "a7e42d81d779dec8afd7dc4be71640fb959ea861bccfa5980cb4ad9f92e30675"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97a1cafc1e7949116134b8c827c8b7bdd123fe0a807d47c95e170fb71660e603"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/46/126b1831dca12060d4a8296bf9c4fe5c93c4f22197fa239cb0cc82042bba/filelock-3.32.6.tar.gz"
    sha256 "a3f55a18af3652a94d8f47d6055df434f254ca1d02ef2524850c6d249ca2512c"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/53/18/f3bb8ef0d3b930692343da8aa4d3cbcd6749477c053959395ac81965a6e9/platformdirs-4.11.8.tar.gz"
    sha256 "f23abafea7dd4276d1f29104b83598d7dcc567cafd07c9c951e66665645437fc"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/91/96/0f93e27c9f60a650838f2118159aa115fd5732c0716247917b7ba7ede665/python_discovery-1.6.0.tar.gz"
    sha256 "6393b4eae1be8b2182670635e7baff89ac21cb9f8e86fd1ff40c7b1144febb4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end