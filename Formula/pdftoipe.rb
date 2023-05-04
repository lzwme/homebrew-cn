class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://ghproxy.com/https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "066d23b4bba59e7809bf24083fe45b31dd15eb89201d1f9442771d933e6be540"
    sha256 cellar: :any,                 arm64_monterey: "69b311b0ac0c7c855a3e3c5d2e78b0b3b537fb8f67454e605f651b6889e3a31f"
    sha256 cellar: :any,                 arm64_big_sur:  "62ce40a07d69d4b282776e2c930cba1654e44e4006fb64b20696a2eadf8193a5"
    sha256 cellar: :any,                 ventura:        "06157e20f20b9c2dbf07bc5572ed019fbdc890617827fcb00d5303abd00e2774"
    sha256 cellar: :any,                 monterey:       "e2e6959f5afa2e50562e8134d99315eb5e842fdcb97033ab4a204c42e847b375"
    sha256 cellar: :any,                 big_sur:        "f6c4f1b6f3ffecf60329384a26787c47328e8b1f9632e2cd2e3e6de807152546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819e6bf48e81a339378f93624294be9d5abe29b718f85d324371dd0d2ff0ece6"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  fails_with gcc: "5"

  # https://github.com/otfried/ipe-tools/pull/48
  patch do
    url "https://github.com/otfried/ipe-tools/commit/14335180432152ad094300d0afd00d8e390469b2.patch?full_index=1"
    sha256 "544d891bfab2c297f659895761cb296d6ed2b4aa76a888e9ca2c215d497a48e5"
  end

  # https://github.com/otfried/ipe-tools/pull/55
  patch do
    url "https://github.com/otfried/ipe-tools/commit/65586fcd9cc39e482ae5a9abdb6f4932d9bb88c4.patch?full_index=1"
    sha256 "61f507fcaa843c00e5aa06bc1c8ab1cbc2798214c5f794d2c9bd376f78b49a11"
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