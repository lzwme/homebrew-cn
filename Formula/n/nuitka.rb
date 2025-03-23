class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/37/45/1422f08b013f040806f0f1e10c4d4ba82d5aaaa7aa17ae6745e7fa8a624c/Nuitka-2.6.8.tar.gz"
  sha256 "da1197842258fa266d8188d2962913351539d8d2067cfd6d78dee2762808d516"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8be3c1282263241d5677ab40491d55c67657726031072f7581c7175a052623b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ffa16c87a1f0684c7248bd3a4d1d116db0d7aeb7abf58d16abbbfe3d8a17a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f4189b7dc7bf64150cfeeede16272412ad197d4ad8690b81d2254609607475f"
    sha256 cellar: :any_skip_relocation, sonoma:        "918010f5e04e295cfbeb7c9a020bea832a883996d841e77af439f35ee1488508"
    sha256 cellar: :any_skip_relocation, ventura:       "b82268482c0cce7b07ba5942b0c469d802a26cddb9f91ad2caf4e34dfccb309a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6505207697ee114bb97ebb59843b004e9c4fab75fff222fd6a4b4be6f01cd1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd23a4f4dde84767f031fb10c5805a192596274988a6694ecdd90d97be5df10d"
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