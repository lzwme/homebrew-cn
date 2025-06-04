class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/81/c5/2653756a2150b19061f62903cbf5b5df01aea068eaec1c8f6e64274f130e/Nuitka-2.7.6.tar.gz"
  sha256 "8ad661b57dec9753ca93c59232bf40bc3288d79da46492cc574cfca640d81d13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dbd52d63a20594e88f878186c6b0fda5605070ca387a7e9479193ae11a6fb1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a21ba69f4f8c5159bb166499b472da94a86862df2afb6c7427c30021d70c4d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53427d791f5885848ecf23246a728a50d827f16eafa551682977fb8e5846e5c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "76debc3a339410825cb2bf85e8d9ce265241fd2bd9a53aed2b4dcfb8e2108d54"
    sha256 cellar: :any_skip_relocation, ventura:       "b0ba0eeffd5d812fbfda74903aa05b7372f99b1ce532a3ecfa88f018d2b38353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c4ecf0bf69e51d97c98689effd0413aad77bc6a71a8e1ef54adae8a896a91ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9476ad3184c70720b98ad1d2460a57bdf9a150c955a476e7f8a0dc320dad2855"
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