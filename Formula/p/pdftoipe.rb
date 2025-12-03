class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://ghfast.top/https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 12

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3d4d692c2253565531d6d3528369cbab28c9194ef9fbbc238be5002fa48a27c"
    sha256 cellar: :any,                 arm64_sequoia: "c73bb159f9affa4880783e91c9401855224fccb2ed117183c443402df7e5871a"
    sha256 cellar: :any,                 arm64_sonoma:  "f6d9745bbcc1b6998d72df33104ae054e297c101803550e426c1525e882d6b7d"
    sha256 cellar: :any,                 sonoma:        "69746169dc58843b334d93ddbb9a3bef9a2eaad73cec4b28a4e7970fe9fe33a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981277405c2540515901c3a6c9613649b0b742cfe3711a05e17454e9cedd8dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05fb13c54ad24bbd54f5edb777b932fd061fdb9e1c4488023f412d787cb44258"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  # Backport fix for `poppler` 25+ compatibility
  # PR ref: https://github.com/otfried/ipe-tools/pull/72
  patch do
    url "https://github.com/otfried/ipe-tools/commit/0da954e50fbdedf43796291853890fe36248bc16.patch?full_index=1"
    sha256 "65f7010897fa4dd94cfa933d986cae6978ddd4e33e2aa1479ec7c11786e100c3"
  end

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