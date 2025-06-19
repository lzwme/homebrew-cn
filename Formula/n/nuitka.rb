class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/13/a8/31b9b1ee9fa7d62c736f6c5d5aac1bcc908dbb5e7f2ea05a04c3c3fb917e/Nuitka-2.7.9.tar.gz"
  sha256 "26feb16dc860fe913430bcd349815bac8df432a44f6b215bdd3dd775bd887762"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af81ef3930480fe5f961ec0125c6e7f4ffb584e434e2d08d921d467cdae594c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e0c0635514da25a078cd19bf2f8e981cb01432ecdc932330d8e2dd741063cd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a13c9a87587d07a9794bc9b6bcdfa58f50abbb34504af7e247a3791c104e3cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4602d06cdf48160dd1472c1c2cba0b995a5035d4a3e1dd50019f0ab19e2f22e9"
    sha256 cellar: :any_skip_relocation, ventura:       "0eca856368c67a5d57c27c48634f628d0b6fa1f58815cea5745f25eba0d34e14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12e607950cf7375e8f61c1e9b99ba164c98afe025f86fb4078b11275e4d28112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73c0f7638c8afca74bce8ce8c307c3b0e37c8bca71797b6a4685ed8533c8c6c"
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