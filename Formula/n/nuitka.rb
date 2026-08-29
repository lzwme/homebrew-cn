class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/14/f7/305d1eca71f554f52cac820b8d1765aeb5fb2b3732d7f49f5a32aa4d97d2/nuitka-4.2.tar.gz"
  sha256 "b6112c10a5d0431e2b4309780257a03049a42605290e83f771d57a067a387410"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4097c8fd6aabe3004dfd2b155057354a955dd7b57838669490b1d85cea590db8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "623119ea08f6eb949bd7c58e25c1504be61466d2a2f2b1d592760f0ed912a9b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7a58a859402ef37bdb81d4be56a8774c7b0233a992bf9fc35ebab9b08044ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7dea4fcd3f27e678a40f733bad814f5d640f43b5b29409da82f64d87f4f0d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8420156fb5c645ef43b35c2e6677199a132b5e253134f0311b2cab85da3cc4f4"
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