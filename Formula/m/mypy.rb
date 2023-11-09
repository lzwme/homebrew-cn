class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/50/f8/0a8d4d8781b41b445534bc4f9210b7793bf0ab52aacfd06ebd2699663e2c/mypy-1.6.1.tar.gz"
  sha256 "4d01c00d09a0be62a4ca3f933e315455bde83f37f892ba4b08ce92f3cf44bcc1"
  license "MIT"
  revision 1
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "717191f666788135666d990d45101dad87f6fa54d04b106e2b115287801c76b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c06e024130019d23c9759f4cc24e0d27ed156e6c9bdc37bb5494fb177e0e25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7b6abfc292ccb20f42cfa1c88a749821e764cb182297dacc63569b0570aac67"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e6077ed35e3839664c69e75fc88a74c86b40a41eb9970e3db314ae12cad54e6"
    sha256 cellar: :any_skip_relocation, ventura:        "3d3dc16ec31998c94a0484aba880b32acd43cc53579bc25772f6478ce652506e"
    sha256 cellar: :any_skip_relocation, monterey:       "6f45b8f4077e2ade136a78d11dd42c5a8b3b9111fa20a512b6c6b8ecafa73b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4feea627ba7e1b03f3207ad046dae6abcb5c8696d5a3c209fa4f95d5727abeb8"
  end

  depends_on "python@3.12"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  # The `python-typing-extensions` formula depends on `mypy`, so we use a resource here instead
  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/1f/7a/8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543e/typing_extensions-4.8.0.tar.gz"
    sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
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