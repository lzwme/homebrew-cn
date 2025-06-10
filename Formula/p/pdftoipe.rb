class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https:github.comotfriedipe-tools"
  url "https:github.comotfriedipe-toolsarchiverefstagsv7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 7

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b53031b21a4c2a85bd24e6e76bf9fc9529958e593dbc57578bbda62a6eb75863"
    sha256 cellar: :any,                 arm64_sonoma:  "a3295144f553dfd41a1dc58a6b2aec4a778f7138ba60459b0af9d235a7221fd9"
    sha256 cellar: :any,                 arm64_ventura: "db41e30d1dff63006459645e14a06561ab3fc9493e824d1aaa023b8e1f652579"
    sha256 cellar: :any,                 sonoma:        "a1ac877d2ee711ad58ba675474e53298ac061cb9e275ab965b6918308da2056b"
    sha256 cellar: :any,                 ventura:       "6fcdf3f28ae5be12ad574882615d1df18a9cab1b39c90b09288a9dd020f33114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0770869a663d308800971e1cf925b6a978d2e7e4d02afb396c2dfb03b4563402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48aaaf36d80d986ca7bd6055e2e85c60a05727f97117fb50c830085bd60449d4"
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