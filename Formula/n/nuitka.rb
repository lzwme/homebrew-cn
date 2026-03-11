class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/c5/76/fbc2c17511505d7ad09dbe14b32f31b1702669dc31647c5c314067e7e53a/nuitka-4.0.4.tar.gz"
  sha256 "7f36a4bef1caddc1bc80d83ab1d9e65927bbc8a773642a29a3e06659f9dc5cc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49eecb4feb9d8eecc0c8abda1ed37def5e252b08aec9c9be3d1373a182536741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b282839b4025bc9ee2775eea9c18e0f2e77a310e6f0bb2c15e79a9a96b23f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6ab3dbec299028d779408406432ba529af38101c7c7fad38615dfb611bac340"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ef7b83d79b07c5445656be8b46d1a3e407b706c7d3d22f6d3a6f6b447796a77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e6bf0a9bdb946201d41c161ed582de2aca48cc35526493b62780164eb812576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b273819a7a79816c5dd2a81c415b55a5f7a5dc07f15f66d25914ea31ac0eb97"
  end

  depends_on "ccache"
  depends_on "python@3.13" # planning to support Python 3.14, https://github.com/Nuitka/Nuitka/issues/3630

  on_linux do
    depends_on "patchelf"
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
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end