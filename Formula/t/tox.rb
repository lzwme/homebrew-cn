class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/e6/da/07e37dbbc2087ce6ef48a396b850f251ca6a8fa07143a72d84d77fe6b4ce/tox-4.38.0.tar.gz"
  sha256 "b053e32eabf09501b0b3903ac8ffe927ec5191304f3a56cff3adc1314c1bb2e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bdb175f8b9b4fb3d0e5d598e690f3d253e5abcb6d1a415585498ad895a3bd467"
  end

  depends_on "python@3.14"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/d4/07/56595285564e90777d758ebd383d6b0b971b87729bbe2184a849932a3736/cachetools-7.0.1.tar.gz"
    sha256 "e31e579d2c5b6e2944177a0397150d312888ddf4e16e12f1016068f0c03b8341"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/02/a8/dae62680be63cbb3ff87cfa2f51cf766269514ea5488479d42fec5aa6f3a/filelock-3.24.2.tar.gz"
    sha256 "c22803117490f156e59fafce621f0550a7a853e2bbf4f87f112b11d469b6c81b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/45/7b/c0e1333b61d41c69e59e5366e727b18c4992688caf0de1be10b3e5265f6b/pyproject_api-1.10.0.tar.gz"
    sha256 "40c6f2d82eebdc4afee61c773ed208c04c19db4c4a60d97f8d7be3ebc0bbb330"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/c1/ef/d9d4ce633df789bf3430bd81fb0d8b9d9465dfc1d1f0deb3fb62cd80f5c2/virtualenv-20.37.0.tar.gz"
    sha256 "6f7e2064ed470aa7418874e70b6369d53b66bcd9e9fd5389763e96b6c94ccb7c"
  end

  def install
    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(Formula["python@3.14"].opt_bin/"python3.14").to_s.delete(".")

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