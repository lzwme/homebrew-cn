class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/59/bf/0e4dbd42724cbae25959f0e34c95d0c730df03ab03f54d52accd9abfc614/tox-4.32.0.tar.gz"
  sha256 "1ad476b5f4d3679455b89a992849ffc3367560bbc7e9495ee8a3963542e7c8ff"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0073521f3d546e6be6c6889c419ecf28578a4ce2c181f6ca3d5a111f6b70cf52"
  end

  depends_on "python@3.14"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/bc/1d/ede8680603f6016887c062a2cf4fc8fdba905866a3ab8831aa8aa651320c/cachetools-6.2.4.tar.gz"
    sha256 "82c5c05585e70b6ba2d3ae09ea60b79548872185d2f24ae1f2709d37299fd607"
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
    url "https://files.pythonhosted.org/packages/a7/23/ce7a1126827cedeb958fc043d61745754464eb56c5937c35bbf2b8e26f34/filelock-3.20.1.tar.gz"
    sha256 "b8360948b351b80f420878d8516519a2204b07aefcdcfd24912a5d33127f188c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
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
    url "https://files.pythonhosted.org/packages/20/28/e6f1a6f655d620846bd9df527390ecc26b3805a0c5989048c210e22c5ca9/virtualenv-20.35.4.tar.gz"
    sha256 "643d3914d73d3eeb0c552cbb12d7e82adf0e504dbf86a3182f8771a153a1971c"
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