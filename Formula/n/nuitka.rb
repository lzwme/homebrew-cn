class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/75/27/9fef9381e967c333c808d8b087ca2cca713d608647a638d962f34ea22a45/nuitka-4.2.2.tar.gz"
  sha256 "29c1bfb6f53154e620b38cf6167cbb03f54043f6e08ef7d3f2d5080a95df7e0d"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d286d6213e9a314faf52685ae31c88f67df10d7bf69555aff07855be67d10d4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1cad436bb23a9bc59a438b3f03cc5fb113a5a76787e66541647aa42d24fb077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "026e04e15d5e1a84692ac3c8dc00268ce48333db2d3dcdacee8b270267ad71c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "daf2ed7d74cf838126cc3a25aff2f703caeca22f1d16fda47e472bcd34551e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ab7495222f242f5fe745f9e223f98df28e5feff2247f12fcad78a570f141538e"
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