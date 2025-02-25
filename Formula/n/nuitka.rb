class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https:nuitka.net"
  url "https:github.comNuitkaNuitkaarchiverefstags2.6.7.tar.gz"
  sha256 "ad8b0cf431650210efa2dc4dcd146d2c76d4a6a9b39edcc213a08ca312d1a8fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b900c0b8c540ee1238ec36eb8b964b8bd359e546f6dfa4aaf10ce3c19517196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7145e3a37c507241e1e88d421ef18a5dadc71e8651be47fdb80857d9980c47f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1549951388ab0eebf581ae3cf0357bf6d0018e03b466588087df0fb880130ff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1abd763a58c9cdd85ad327c9682a660ba79c4f3fd6774a3540ce4192136a7e07"
    sha256 cellar: :any_skip_relocation, ventura:       "9b7d8c97c3ad7a3bf08c96804d7f64cb1713efc98d29728ef8797f3c1448c104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fd22504ead4ad3b2e1f3806e1077ef29b0e946e83262515b9f54626382065fa"
  end

  depends_on "ccache"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https:files.pythonhosted.orgpackages4ccabfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2feordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc*.1"]
  end

  test do
    (testpath"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("python3 test.py")
    system bin"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output(".test")
  end
end