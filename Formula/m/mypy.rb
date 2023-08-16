class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/a0/02/865c2fb735f08eb8068d54dc88d7544477f9ea792f6145eeedbe0e847df9/mypy-1.5.0.tar.gz"
  sha256 "f3460f34b3839b9bc84ee3ed65076eb827cd99ed13ed08d723f9083cada4a212"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "433dd571251b607dd8050b0737171bffc7bda11367eae6fd94c94f007d897492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d3d0abf0800f89b6fb82fe183938a1ad0bdffcedda6c986dc5588aef804906"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1262c631aef47d8e1679a65106ac8a436bc8acbc2bf6bbd367ec471ab8595e6c"
    sha256 cellar: :any_skip_relocation, ventura:        "50ac948b5397cef413dabd74259cf080a75454bf887831e5dc8d84d06c460052"
    sha256 cellar: :any_skip_relocation, monterey:       "c70ae6864487adc9f890a39739ae7334fedefe1e8fa1dc6be2f6b31b4822e994"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e6ad2f9f325e767b36916ed338a987e6041f36cbdc2d0a0dc1c5c1c29384e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4904592099bc3c4cbdfa9430d5a81ac3d6a51b4bf4155dd89dbef38b9e98cc60"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  # The `python-typing-extensions` formula depends on `mypy`, so we use a resource here instead
  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/3c/8b/0111dd7d6c1478bf83baa1cab85c686426c7a6274119aceb2bd9d35395ad/typing_extensions-4.7.1.tar.gz"
    sha256 "b75ddc264f0ba5615db7ba217daeb99701ad295353c45f9e95963337ceeeffb2"
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