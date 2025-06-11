class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/0a/3f/3294699ad8ebca820127b5606c77e52bb1bd5d7eea97e9dd5a6228884e80/Nuitka-2.7.7.tar.gz"
  sha256 "327e697e1a3eea2608ca7dce228c2d7686d65e38af9907c98646695ba5df9edf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ee03d2ad52268852519b0db98fd7fb4a27ce091645afb241ac8e791c50fd2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "181911612a715cb92bf9590c151bc467f6034f49096037791c5e0132b4e872ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "385e3c28fb79bded9404aa77a9dbb41550bfb8695f52e56f3f6813cd1a8fbeee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a63162f5cbaecb41cedfd355dccd1aba478045728a0461f7e9a50e577fa55e3"
    sha256 cellar: :any_skip_relocation, ventura:       "e5e4490558f126c0581eaa866b49736f036b79839200a94fcd94dba0045e7f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36060c2066851607209d0de4deb7670784841487c7eb392a8497263f74715c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0afe97528c10078aa3b1c2bb6fb6a11554e1e4d76a5c413c725c8de927415a0"
  end

  depends_on "ccache"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/ed/f6/2ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1/zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("python3 test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end