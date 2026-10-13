class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/fa/5f/ba7cb858da0c98c24f85c54454a5ea18f2b784f658a91531fa051b2f2ee9/nuitka-4.3.tar.gz"
  sha256 "8b102c6bf30d9504e82e69674d396972729092b25cefa680e8fd05678fdfa30b"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c92145173db4f50d13d3d2202745c6b63b9b2a273fa81fed28bd5ce1534c8d06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2e6a917d74e8a77bdc08e3773cbd9f94d5b1ba9d128309d141a375f3bb8a86d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8386a7d7dbe156c0cf2e6c82eba50ee2cf3f964122afb92c9454592f006aba2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "88d3343e17c5a08af6c3aa3c61f30054af8bbe5737de1c06ed799a60db33f35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8cf599ef317d6538561d73b0056f49d3b59764a5b8b4c669448cbb39289c857b"
  end

  depends_on "ccache"
  depends_on "python@3.15"

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