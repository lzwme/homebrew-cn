class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://ghproxy.com/https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2471b4e55316d5bb16f837504bd3d889a8e3f8e4e91345c212eae26c76e369a9"
    sha256 cellar: :any,                 arm64_monterey: "69a9d5a667ad556629ff3aaac17ee07f595e258d404647e513bd2e17711b5740"
    sha256 cellar: :any,                 arm64_big_sur:  "9e6aa56f8548a8327ded3033cad1beed47936a1ded75aa8aeadb346dc5230a0a"
    sha256 cellar: :any,                 ventura:        "d093aff36bbde817e23a69f7a3bcf9b5cf970baeaad7bc212c942160599a01c1"
    sha256 cellar: :any,                 monterey:       "233f4e217e98efe6ffb9621333e6bc6b66f8f106f2e3b785b5b5dd776c0cdf29"
    sha256 cellar: :any,                 big_sur:        "8d8af6acbb00ba7a49e106675ec49240081998a263fe0cd93ac67345898d59e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e905ecd0facb4015eff6c21bc383bf52254cce7e2ba87a572f1db1cc19b4ce88"
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