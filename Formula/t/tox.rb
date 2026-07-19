class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/e9/27/21c5edac636f3897c8aef1d000f77dded5c5f55302025419dbb5500e3a35/tox-4.57.0.tar.gz"
  sha256 "b2f758011dfbad7be4b4cc39d2cae21deeb3c3c186e6d7a92d7630eade4218cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b00792f7dd493dc4a4b18e70bbca9f6f7ec1129c9a4ea28598d2e3b81dfecba"
  end

  depends_on "python@3.14"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/f4/8b/0d3945a13955303b81272f759a0331e54c5c793da455e6f5706b89d2639c/cachetools-7.1.4.tar.gz"
    sha256 "437f55a4e0c1b01a4f3077cc470e6991d47430970e36fbcb77e2be0df4fc1cd6"
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
    url "https://files.pythonhosted.org/packages/d6/01/9256cbe36eb2a84501920adad7d0e86738ab0ad60e64f4f5c38d7dd94dc1/filelock-3.30.3.tar.gz"
    sha256 "6575420cd497ed15fc43a7ac46c48f6b6371c733fc40cf5a4e216871397bc1e2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/62/62/0fe346fe380b1aafaf819c8cb195d3241bb4f355f908e6339814131a830b/pyproject_api-1.10.1.tar.gz"
    sha256 "c2b2726bd7aa9217b6c50b621fef5b2ae5def4d55b779c9e0694c15e0a8517ba"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/4c/81/58c70036dffeccb7fe7d79d6260c69f7a28272bbd3909c29a01ea9422744/python_discovery-1.4.4.tar.gz"
    sha256 "5cad33982d412c1f3ffb8f9ca4ea292c9680bca3942451d30b69c37fce53a4a3"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/34/d9/b477fddb68840b570af8b22afe9b035cbc277b5fb7b33dea390617a8b10f/virtualenv-21.6.1.tar.gz"
    sha256 "15f978b7cd329f24855ff4a0c4b4899cc7678589f49adbdcbbb4d3232e641128"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(formula_opt_bin("python@3.14")/"python3.14").to_s.delete(".")

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