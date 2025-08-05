class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://ghfast.top/https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 9

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed94bc27eb50abd1d26f87f1bc337a2b5e5a140fff2f70107b08f006e5ea2acf"
    sha256 cellar: :any,                 arm64_sonoma:  "18e195efc314c9dc1e7a9e1b475bfbb4bd361df174581d163804104d39be1462"
    sha256 cellar: :any,                 arm64_ventura: "49ff25edfb33a44913bb85e9f20e3bfc936be343d86cc12aee5df970840fd55d"
    sha256 cellar: :any,                 sonoma:        "f429467885c0a41c935825dfb0d07499b6e131afff692d084317e007f832019c"
    sha256 cellar: :any,                 ventura:       "5bf14a63b818d2ea655e377496219c76c452b13ccae397f876534cebf0289f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc0db1a2f7030543e3bfcdf7df0d35648e708292909de088710f60065359f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7452da1820d0fc3da9de95a86a115501c96b5b7bda339dcd8b04c3524c475d5d"
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
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end