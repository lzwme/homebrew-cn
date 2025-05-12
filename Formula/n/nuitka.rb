class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/68/78/ccc32d807985cf9b8f8578f921ed087a7964280be0851142d31d5abfab1e/Nuitka-2.7.2.tar.gz"
  sha256 "4e8d315d6cd5370ef346f1243849681170f649bc9f6e4c10310f58b60861ef1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062f4630395724bb0be3c1799ed0c6e1f2887f7ef5b6c9919b58173583680dc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91fbdd7e80b8f51575f052129ccdf673b91c07fcfe3efbb518594c38ade7c0ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9420362d1409f4f17d5f954b8f4081d44eeafeadc94bc96ade49e63c95e664cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f2560ec5ea0546338d69824a80e2c5d5c1726ed4dabdc23ab0ce1c4b011e1c6"
    sha256 cellar: :any_skip_relocation, ventura:       "d92c27418d167b1488900a40e5c479c873f2b3f0b8f2d5adae76adff017c797d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79864604721914928128417672eecd050cf323b35c5138a55c2edbd3da99656d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e640923b82d797c84958752964a661bb34a019dfa851f293286aa06f324be20"
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