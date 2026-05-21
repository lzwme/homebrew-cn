class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/d2/a6/8cf2a663402c057005f0328bdc691a653fa14848248358ef051f86a21880/nuitka-4.1.1.tar.gz"
  sha256 "777e2c84d6b168f9bf78c3242b3779958865ae5815d26c76170eb830995368cc"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c1b33d891854c51f35182f699d1a2ca8053e324d381e40a2f4ef5928f8df920"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c32c948da12796d54d532018069d6655ad793b12dbb71b85441e103496546292"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e65aaf80b26c8cec072b93e73fb2c1e79ae0810030edfdfc5295a33871a627d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77a9cc53755ad162cd45830078786f1e398ccdec7499a2f5c123b6c1893543d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd52686107afb49e73f98c8cdefe333aa5709c02e22ca5025e7267f2cd9f6e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a72c115c4c5555582f3ed82df7645efbe7e1a8d055a23fe076af80f24fa8f857"
  end

  depends_on "ccache"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf"
  end

  def install
    virtualenv_install_with_resources
    man1.install buildpath.glob("doc/*.1")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    PYTHON
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end