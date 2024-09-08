class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/e1/cc/272e73f90be0f6df89efaf82e5d804b90b4e39ceb0ef1621486bb0e921e8/tox-4.18.1.tar.gz"
  sha256 "3c0c96bc3a568a5c7e66387a4cfcf8c875b52e09f4d47c9f7a277ec82f1a0b11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8d6c4ec8cb2165376ea596e02d4ae4e3015974af1c4ae6d151525fe8305db4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8d6c4ec8cb2165376ea596e02d4ae4e3015974af1c4ae6d151525fe8305db4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d6c4ec8cb2165376ea596e02d4ae4e3015974af1c4ae6d151525fe8305db4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b013af760757bb5b3c500310d0646dbb316cb7c684bc5e927e12595a25951b5d"
    sha256 cellar: :any_skip_relocation, ventura:        "b013af760757bb5b3c500310d0646dbb316cb7c684bc5e927e12595a25951b5d"
    sha256 cellar: :any_skip_relocation, monterey:       "b013af760757bb5b3c500310d0646dbb316cb7c684bc5e927e12595a25951b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44a141cceccf1484d50e9b57ea746b9d6bdac035eedea3027a3c18f3c73937e"
  end

  depends_on "python@3.12"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
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
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/76/3981447fd369539aba35797db99a8e2ff7ed01d9aa63e9344a31658b8d81/filelock-3.16.0.tar.gz"
    sha256 "81de9eb8453c769b63369f87f11131a7ab04e367f8d97ad39dc230daa07e3bec"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/b1/0d84052c168ca3a712ca01be2b8f55af8a3d5b644e02276e02c3a0ac2b90/platformdirs-4.3.1.tar.gz"
    sha256 "63b79589009fa8159973601dd4563143396b35c5f93a58b36f9049ff046949b1"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/41/43/5581b42a96c5ee7bf2b22d3b08b34c8a54dfe6591d8b9a4314c890bd4a0d/pyproject_api-1.7.1.tar.gz"
    sha256 "7ebc6cd10710f89f4cf2a2731710a98abce37ebff19427116ff2174c9236a827"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/84/8a/134f65c3d6066153b84fc176c58877acd8165ed0b79a149ff50502597284/virtualenv-20.26.4.tar.gz"
    sha256 "c17f4e0f3e6036e9f26700446f85c76ab11df65ff6d8a9cbfad9f71aabfcf23c"
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
    pyver = Language::Python.major_minor_version(Formula["python@3.12"].opt_bin/"python3.12").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_predicate testpath/"src/.tox/py#{pyver}", :exist?
  end
end