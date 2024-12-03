class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https:github.comotfriedipe-tools"
  url "https:github.comotfriedipe-toolsarchiverefstagsv7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "676487a4936713e7959e84fc88044043702b83264a252b993e81a9dd86d6d319"
    sha256 cellar: :any,                 arm64_sonoma:  "360ff0144680ed13f66f522aaf25ad20a614e94100646f613ac85cc7be579a1e"
    sha256 cellar: :any,                 arm64_ventura: "c95975c6051e420465edb2678ac971ae8d6f4a14d3c7e8dd99de384149ca5da2"
    sha256 cellar: :any,                 sonoma:        "c1d0b1dd05122e9d7efffa64af044688da047af048200a52f5ef4c7c3e3e0835"
    sha256 cellar: :any,                 ventura:       "c1807495f1e45996dc8296fe8d4783f7b0f5642cba6ff7317d9f7a4fd43be564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c63824a5a34755e35f7355010e82ddc080e1e42e8c8f869e1582821d0c041d"
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