class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https:github.comotfriedipe-tools"
  url "https:github.comotfriedipe-toolsarchiverefstagsv7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20219ab43fa27bfafe7b30f47a7c44e32dcecaa3639798403033427908b11524"
    sha256 cellar: :any,                 arm64_sonoma:  "dfb9c281b4b1d9b7d4a9df7a200ab4cba50eb2b84a80632afc0212a9591d7697"
    sha256 cellar: :any,                 arm64_ventura: "4277529b99f2969c78ee666f1fbf3b4095053785861da575368fd103a4728e31"
    sha256 cellar: :any,                 sonoma:        "bec196c925358df14d3103edfd87fae4c6e19fad663a190d58215d41c3020d0a"
    sha256 cellar: :any,                 ventura:       "d4825d3d64df10ce5a9c910bbfb0e8fbe8afaef2bda3f8f39230cabff2be7905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b5da5a066b5d6993bd559d9a0a61d36f8b65f89a7292f89316792222b86970"
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