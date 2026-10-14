class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/58/e0/3e2a5f99e0559879cc02ca11d483ae9f48bd5d7d28a725560334f1b75452/tox-4.65.4.tar.gz"
  sha256 "e416fcfef86874001ba90787c282f4c6ecae6e2e167dbe65e7b8b53f9d43c931"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2ec170c654692c3d7d5390dca193c91fa01240b46ffdbcd6e8a65b38593e0d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2ec170c654692c3d7d5390dca193c91fa01240b46ffdbcd6e8a65b38593e0d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2ec170c654692c3d7d5390dca193c91fa01240b46ffdbcd6e8a65b38593e0d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a2757d83dfd21e0514f9206481d13f9627178e66bc2c23a8ed249c79d024e717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a2757d83dfd21e0514f9206481d13f9627178e66bc2c23a8ed249c79d024e717"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/31/44/71476a5812da1ddf2c9a3efd31ae76d01480a1cf03ed13ac28aa8f2402e4/cachetools-7.2.1.tar.gz"
    sha256 "b1a7537025c06abf96fcc1443e496af9a3fb95e774e70e1f0af226f73f7f2dcc"
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
    url "https://files.pythonhosted.org/packages/35/c8/1d457d9150ff948f2ce6ada7715e0eeebbe5d3b58a45271a1e222474bcd3/filelock-4.1.1.tar.gz"
    sha256 "7ba0927482c5a814b0a7f391d029ccdb8010f576f0a74c0dcde1811e8bc4c1b6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/3c/e1/148e4bbb469b26b6648dac4ee292aed80c1205c06ecd2e32987c7ed3e6f5/pyproject_api-1.11.5.tar.gz"
    sha256 "79294e79953a30fd3eac04bdf8b57241d33e2c8b7230b94c1b76e4d765fe09ad"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/b0/73/54993df8fc57e906dc9b7e01d1d9b0b2d3eb0ce3190639e33dccb12853f7/python_discovery-1.6.2.tar.gz"
    sha256 "cd1738ca1d37c86ef9d0b654dd46fcee1e41c97c6add12575e8501ced39afdb4"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/dc/3f/935cf1757643381fb7f7cc98197b4bc119223d9c2cf37dc3b03ad2a4455f/virtualenv-21.14.7.tar.gz"
    sha256 "5f427d56f39eb7e7447d641dd4b7ab1e9c92793f498f35f26da2e4972c5546ae"
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