class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/71/c8/dd3bee454333df813c97938a64c516e838ca5bc17ef35a74ceeb0f31869d/mypy-1.7.0.tar.gz"
  sha256 "1e280b5697202efa698372d2f39e9a6713a0395a756b1c6bd48995f8d72690dc"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "662111a70a26ad7515549642c4e0270446397a899029d6a1c2aae15320366b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "850faceff4e850b3f08e8082ab2ca40df3a024ac1ab69e01630d6cf3869fa2c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd3994a8a56ace633989500196041fe4d4e336dcb3e80a1a71940158685e6c2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f31ef6cb9363c76bbccd5ac854f09598ece7f3c1c6a10c8d77897fa41f01bb1"
    sha256 cellar: :any_skip_relocation, ventura:        "bd08466999bd80282b5ed2e98c71e4e7552e9cb1431403d4d29bba84324a3104"
    sha256 cellar: :any_skip_relocation, monterey:       "5bddd94eec4b9c700b518264717d3fa0e45e85336c81d81371ab45c162f385cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c99b862af522146e2e921124333e01bc7c59e62ad9dda55cd18157b2667830a6"
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