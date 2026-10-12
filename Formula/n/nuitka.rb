class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/fa/5f/ba7cb858da0c98c24f85c54454a5ea18f2b784f658a91531fa051b2f2ee9/nuitka-4.3.tar.gz"
  sha256 "8b102c6bf30d9504e82e69674d396972729092b25cefa680e8fd05678fdfa30b"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6cde5728b0d148ec3d3f31b9d968820af3ebc8831d55b11352bf098c4a26c6e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3bea860eec56c1c8cb5543064d04f9008a9854c69945d9aa2c457e4e27ab329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62786db218092ca5c02a4ed7135c8e8c63f695bc95d924ad9bbf273ea3d24a12"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e2ff10e1b8cb95547c38d972d1595da5568a11adba73dd852a9ef5bc99c3e760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7b00046cdf474c6fb6f616dd8363953e2dba3b4209727aa42b3b060c617b5288"
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