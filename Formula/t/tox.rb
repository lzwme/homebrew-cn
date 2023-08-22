class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/09/8e/33dc3c5078db5ee7f0c452f353f00f0b77801d0b2acaf8c461a7e26e0705/tox-4.10.0.tar.gz"
  sha256 "e041b2165375be690aca0ec4d96360c6906451380520e4665bf274f66112be35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27d308a8aa1855acc750a7a0f51ddbc667c621f9a807a4f9522a8a07b18e7bbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c129977ac825c4c09eac18aef0a84bdedc4b45c16be5dfed59e1c4ad022c8b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ab03eccf38e027b7e3b4196bef48112febdc11faa56ec9ee19aabbd371cd689"
    sha256 cellar: :any_skip_relocation, ventura:        "17911e571c245b618420378ce85ee7505d0dc6cf5ffafdbfc97cf985ae48181c"
    sha256 cellar: :any_skip_relocation, monterey:       "f80c0d7a21bc03ec36958337ba5aeb116e3bb356d6e3deb13973979a702fdb13"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0a842d1c75d7fe9b65bb1e5db1a10145871662cacad65033d3e6bd1d3135926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d279ec93886332d19e636c927646d4b9dafd39ca084fbad13b6d886eeac984fc"
  end

  depends_on "python@3.11"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
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
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/b2/59/62fa314725be62fa37abea2f211e313eae61930e27e9704df8e9a4760ca4/pyproject_api-1.5.4.tar.gz"
    sha256 "8d41f3f0c04f0f6a830c27b1c425fa66699715ae06d8a054a1c5eeaaf8bfb145"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/77/f9/f6319b17869e66571966060051894d7a6dc77feceb25a9ebb6daee7eed5a/virtualenv-20.24.3.tar.gz"
    sha256 "e5c3b4ce817b0b328af041506a2a299418c98747c4b1e68cb7527e74ced23efc"
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
    pyver = Language::Python.major_minor_version(Formula["python@3.11"].opt_bin/"python3.11").to_s.delete(".")

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