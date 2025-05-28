class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/87/b7/35162fa500946635152ace1edd8af1125875d152c5a7a16e42a6c5d062ff/Nuitka-2.7.4.tar.gz"
  sha256 "2886cc97797354db86ce1edba0a301f858527835567b91d620e9df4213e4c1e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5e82f96093418394111c5ecd6caba9c8864058902ae7ba01518fff6e11272cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee00f3712a5e304b69d10f9df91d9d5b9909d43c4023e742d99cae8bafabb5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48b282e0440a122f79ed3cf004e340a0db7af41d1129c0ec1ce8e0343895bceb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a197f661c1043680dfae11213d5af28764b124dfe6baaacc1034778bc72180ac"
    sha256 cellar: :any_skip_relocation, ventura:       "0d94c14d7ea224f744625776c3546b75c93fd58d2e8c9f33f54228af87b26781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c32d29e905f6e5d65ac02a67e538b3c230ab017eb16330eda79e74e1ea9ec3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85ceb0d0e1acf644b021fb00f0c699918c782d7f25222d6939bb06d21a2480f7"
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