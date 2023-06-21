class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/1b/49/c5c7b9445ee563e09e71382e7fb147480fb85fa2356846488114f61549f8/mypy-1.4.0.tar.gz"
  sha256 "de1e7e68148a213036276d1f5303b3836ad9a774188961eb2684eddff593b042"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e830f19b4b37db6de8875dcabd9b2698fdd5b36682418f2eda9f246d2a4148ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f34f8a6119c89cd4edfd15138d25f3b701be7ab64a5c3cb9edd6670236e2552"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec01281f09fc4cfadc87998de42636545e2d173692e3518a662f16e94bba61b7"
    sha256 cellar: :any_skip_relocation, ventura:        "a629d5fb86e4612ab8d52c705bdf0f1b52e5fd995faa2eb24be8880be781ba5c"
    sha256 cellar: :any_skip_relocation, monterey:       "6f8b05ca2d33227a6a11505dd2a9d484d319f225cbe04961690e7ff76f86b9d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a8e6d419ce017a847c90d86426984147e1f48d76be2a996f77086a4fa01522b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ac8c6ecaea9091e88e439a45c05b83ae5a9ed481975630b113632ed315331e"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  # The `python-typing-extensions` formula depends on `mypy`, so we use a resource here instead
  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/42/56/cfaa7a5281734dadc842f3a22e50447c675a1c5a5b9f6ad8a07b467bffe7/typing_extensions-4.6.3.tar.gz"
    sha256 "d91d5919357fe7f681a9f2b5b4cb2a5f1ef0a1e9f59c4d8ff0d3491e05c0ffd5"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end