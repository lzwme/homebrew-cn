class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https:www.mypy-lang.org"
  url "https:files.pythonhosted.orgpackages8c7b08046ef9330735f536a09a2e31b00f42bccdb2795dcd979636ba43bb2d63mypy-1.14.0.tar.gz"
  sha256 "822dbd184d4a9804df5a7d5335a68cf7662930e70b8c1bc976645d1509f9a9d6"
  license "MIT"
  head "https:github.compythonmypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32728b5de464fc05b5d66a04dd08c84a64ead56d3c95efa987c3e71626799c08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f001a15e5dff8fe4bbb49bf2399951fed3509c3ef9b9bb47013a6c0d0c07a4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "add0109386a82a6664cb65f4c444517a86e4326f942f74e03762c491192fa4bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f599b607eecfebdfdfe682846563c86f11c34e21940c3af684c2325dd81381c"
    sha256 cellar: :any_skip_relocation, ventura:       "32a2ee34ae0ec0485fe7039daeb9c57f9946f348f780b5e9e402b4a0fb696596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45990f497183a3d6790973092c5b899707f961789b8a08680e1faa4dc67cb4ac"
  end

  depends_on "python@3.13"

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
    (testpath"broken.py").write <<~PYTHON
      def p() -> None:
        print('hello')
      a = p()
    PYTHON
    output = pipe_output("#{bin}mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end