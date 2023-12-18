class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https:www.mypy-lang.org"
  url "https:files.pythonhosted.orgpackagesae3005a7c016431b3fdbaf0bcf663aee7c5e4b3d2293cd4e0568140cecae4967mypy-1.7.1.tar.gz"
  sha256 "fcb6d9afb1b6208b4c712af0dafdc650f518836065df0d4fb1d800f5d6773db2"
  license "MIT"
  head "https:github.compythonmypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "133de6c80c128265de7aa97735fa92e8ce0a8fb7111ce2fdc2c619731219c650"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cbc820d6f8945fa464b6aa45a88eb4dea798f47babd8cca6b260025f2cdab83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c120260cd4f626ee6ad7d1f349f02c1f740da4ef316a307a9f086643c2f439"
    sha256 cellar: :any_skip_relocation, sonoma:         "d15053786877a21d842f3b002042f939fa1b48b192b6fec96dac425a61b78d63"
    sha256 cellar: :any_skip_relocation, ventura:        "ab7a3718247842bbb6a0024cba0424181ddf3423ddee43d0039cdf2c2321722a"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c6fd4adc06c028b2d2ec43f6df45ff3897de9cb8d0998a8cb577638e1242a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d34ba98f52c9a2e53bef6b7eebced46873c2901c0ed8bc15cb2475b46af014"
  end

  depends_on "python@3.12"

  resource "mypy-extensions" do
    url "https:files.pythonhosted.orgpackages98a41ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3fmypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  # The `python-typing-extensions` formula depends on `mypy`, so we use a resource here instead
  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages1f7a8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543etyping_extensions-4.8.0.tar.gz"
    sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end