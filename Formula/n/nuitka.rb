class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/bf/5a/19e8bd1c30a83189808cc68883480406b9cd9e8ea99654c313c81d71bec1/Nuitka-2.7.11.tar.gz"
  sha256 "8009d7acb7d0467c96ecd02e4105fc488e0c12e5296cb49b0a9197de883c8123"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12c3238113ba820c1749728e9e641f7d397a8e77941b4ddd1b53bad3f15948ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4e97caf18a3a48dd90b134d9f887c034decd846597e7ab9d93a0e63d5f6024a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fc3503918b1fafea2e1f9e312092079afa36d0278dc25159471b5bf6e974c92"
    sha256 cellar: :any_skip_relocation, sonoma:        "95280d7c0410ca7a7f287d3199de0a2bf53d9e64ac360f12180e4befdc373623"
    sha256 cellar: :any_skip_relocation, ventura:       "a667cc8c05e1e29898bfdceb389a9c2c5ef5dc653e43432e23a6cb953b50435e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b589a8c91b50ab2d27111a5b142b85d797a4bcdf044c7fd5b1b749016e7cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c023c945517db6076c6f42e1885f73296b7178d8e4333005e5b94797643d2b7a"
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