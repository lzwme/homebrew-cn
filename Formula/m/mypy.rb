class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https:www.mypy-lang.org"
  url "https:files.pythonhosted.orgpackagesb195a6dbb4fef19402c488b001ff4bd9f1a770e44049ce049b904dcffc65356cmypy-1.11.0.tar.gz"
  sha256 "93743608c7348772fdc717af4aeee1997293a1ad04bc0ea6efa15bf65385c538"
  license "MIT"
  head "https:github.compythonmypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efb16e48fc22edcc5215261f644e535a252ad507e3010c55c7cb46ad4bddefdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5be6949ebfe9d5552ac97817234bb07b7d88229038a99a2f818e2dafb341d4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3f4c857bf87c6f99ccc152b0d0d46cae9d0afcaf2df4f4dec2323f0527d027f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9721b1d50af299d828e39e1a6b91e2d707790087b73da612ab5a791caf01ee9a"
    sha256 cellar: :any_skip_relocation, ventura:        "21fd47ba157e886d8167bde0a5c86a138294b0887005a7a926759294453671b2"
    sha256 cellar: :any_skip_relocation, monterey:       "9f67356cae54a4003168cb41e6a2e89f63dbabcd015235a5dd668133b47f8dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a331e0cfe6b7058b54e8af7d23a898757605ba5e63fe916076bbc9ef9fa3349"
  end

  depends_on "python@3.12"

  resource "mypy-extensions" do
    url "https:files.pythonhosted.orgpackages98a41ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3fmypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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