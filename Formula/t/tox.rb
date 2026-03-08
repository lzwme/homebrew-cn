class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/c5/5a/56146cae67d337426a98cf95f1a9f3ae8b557879df9a03332ef7d6654496/tox-4.49.0.tar.gz"
  sha256 "2e01f09ae1226749466cbcd8c514fe988ffc8c76b5d523c7f9b745d1711a6e71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6bd5e41038a5958f659f3717c9e01cc8a7fc9fab544b748dd1c2005221b7e40"
  end

  depends_on "python@3.14"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/48/5c/3b882b82e9af737906539a2eafb62f96a229f1fa80255bede0c7b554cbc4/cachetools-7.0.3.tar.gz"
    sha256 "8c246313b95849964e54a909c03b327a87ab0428b068fac10da7b105ca275ef6"
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
    url "https://files.pythonhosted.org/packages/77/18/a1fd2231c679dcb9726204645721b12498aeac28e1ad0601038f94b42556/filelock-3.25.0.tar.gz"
    sha256 "8f00faf3abf9dc730a1ffe9c354ae5c04e079ab7d3a683b7c32da5dd05f26af3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/45/7b/c0e1333b61d41c69e59e5366e727b18c4992688caf0de1be10b3e5265f6b/pyproject_api-1.10.0.tar.gz"
    sha256 "40c6f2d82eebdc4afee61c773ed208c04c19db4c4a60d97f8d7be3ebc0bbb330"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/82/bb/93a3e83bdf9322c7e21cafd092e56a4a17c4d8ef4277b6eb01af1a540a6f/python_discovery-1.1.0.tar.gz"
    sha256 "447941ba1aed8cc2ab7ee3cb91be5fc137c5bdbb05b7e6ea62fbdcb66e50b268"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/2f/c9/18d4b36606d6091844daa3bd93cf7dc78e6f5da21d9f21d06c221104b684/virtualenv-21.1.0.tar.gz"
    sha256 "1990a0188c8f16b6b9cf65c9183049007375b26aad415514d377ccacf1e4fb44"
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