class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https:github.comotfriedipe-tools"
  url "https:github.comotfriedipe-toolsarchiverefstagsv7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f3043c3011b380e19d6d01d4c449193f7118a7e8cc16e5b14227a34e5aaeaf7"
    sha256 cellar: :any,                 arm64_sonoma:  "3aa00c807061fb729f8e0b6d90b9dffb5fb5f0eb95e63c603c1f34ddff98e6ed"
    sha256 cellar: :any,                 arm64_ventura: "36a9b354f033ad51d80480d596975a547d5bceee238fe3b2e7ed7978034da10b"
    sha256 cellar: :any,                 sonoma:        "9ac50d26f20cfacc08043938e501a324e3399fd9d47063b3eb79cac0ee888fcf"
    sha256 cellar: :any,                 ventura:       "df7a4748c5635d324d9a09688d4196d70f11ed0cca4eb4d51d66e10d7fc2f45e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fcc354aae27b1915c90b6aa45641ea6b61d0d70aa99a4b91e19810e24eb89b2"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end