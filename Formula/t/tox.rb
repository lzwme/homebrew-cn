class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/33/57/5a24f6f81ee81a25d34773045db61ddef3a76ed43e6fbd0fca2657678ad6/tox-4.61.4.tar.gz"
  sha256 "d3fa82dc2fe847fe45b576ed0614e850a674aadec3a664f409e2bf295c473e20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8566522822ad65910b6838931d7196874e8a8601895d6c7dafe86272b8dfcf23"
  end

  depends_on "python@3.14"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4b/39/9a4689914dd907915cee74733b95888fc1d8a21aad47a24a0a2deec73ac4/cachetools-7.1.8.tar.gz"
    sha256 "1221d547a0b24b7f26fa891d40d488b5258beab9aebd8ed68c729be3af849c43"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/46/126b1831dca12060d4a8296bf9c4fe5c93c4f22197fa239cb0cc82042bba/filelock-3.32.6.tar.gz"
    sha256 "a3f55a18af3652a94d8f47d6055df434f254ca1d02ef2524850c6d249ca2512c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/53/18/f3bb8ef0d3b930692343da8aa4d3cbcd6749477c053959395ac81965a6e9/platformdirs-4.11.8.tar.gz"
    sha256 "f23abafea7dd4276d1f29104b83598d7dcc567cafd07c9c951e66665645437fc"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/ab/bd/2f985c12bf33fdd8637e3a8f9418d6806f177601dee7c4924d0b2bb28650/pyproject_api-1.11.0.tar.gz"
    sha256 "b8807d85a293e6c9f133e6575946fed45f1d42b22d58c780b33aa2421a799549"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/91/96/0f93e27c9f60a650838f2118159aa115fd5732c0716247917b7ba7ede665/python_discovery-1.6.0.tar.gz"
    sha256 "6393b4eae1be8b2182670635e7baff89ac21cb9f8e86fd1ff40c7b1144febb4c"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/52/5c/ba82fdd0da13ade01453fc08277a70abc79128101319549f55f2e13f8f83/virtualenv-21.7.9.tar.gz"
    sha256 "a7e42d81d779dec8afd7dc4be71640fb959ea861bccfa5980cb4ad9f92e30675"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_path_exists testpath/"src/.tox/py#{pyver}"
  end
end