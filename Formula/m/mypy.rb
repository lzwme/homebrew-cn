class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https:www.mypy-lang.org"
  url "https:files.pythonhosted.orgpackagesc7b981e4c6dbb1ec1e72503de3ff2c5fe4b7f224e04613b670f8b9004cd8a4ddmypy-1.10.1.tar.gz"
  sha256 "1f8f492d7db9e3593ef42d4f115f04e556130f2819ad33ab84551403e97dd4c0"
  license "MIT"
  head "https:github.compythonmypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0f4fbab5b00bebc297cbd4e4cd6f764f8bf8fbfe09577a8ad8d62565eefefc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74b172c09ac4abe50ec4ffd4eba77c61aeeb58a14e0b15683e20b952815d743d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52359cd21126db8273040f5916eafad1ff24f7d7195c353c9e3404e445bcc2b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c884cf4fd08ae19fd4565725e768a549aaec8d82b9faa80e7d11a32ef1f98aca"
    sha256 cellar: :any_skip_relocation, ventura:        "5ab99eb98cc91ed298ef7d32f6c3c4b45e66ff81c0747794cade0c378294fe83"
    sha256 cellar: :any_skip_relocation, monterey:       "d25ecf29814475a41050c9c5472c56dabebda9a878439ae6564c74ba448cc916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e01e45e5e238348cc0939c381415c85dbf5e6ce6b18ffdf4216262a1fe090ac"
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