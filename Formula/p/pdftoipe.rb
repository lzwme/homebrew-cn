class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://ghproxy.com/https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 15

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7967f09b3e92c4a9cec947e32b018fc56f0fbc18c8ea3480adb35e192fe156fb"
    sha256 cellar: :any,                 arm64_monterey: "c095e593c1437c137e289a044502e8d562fa54e63a06c685ad0b0f24111b6bd0"
    sha256 cellar: :any,                 arm64_big_sur:  "2c06d5a543e3dca5a74d6719ab14fb0ea9d7ecd8d2139fbe39450bd449f03261"
    sha256 cellar: :any,                 ventura:        "65efb36fd72e552d8e9ea73dad63de041fb36ab8cd534f9b86fd86f941e55cda"
    sha256 cellar: :any,                 monterey:       "9e9119411bf2bdc5eb6b6ef44f2d1e3005f95bca8493fb069dcc75780d2a36f2"
    sha256 cellar: :any,                 big_sur:        "86af4aedda6eb4eac2004e9aab456ac3ed5c5e005b589cbdcde7314a567fd89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c45b5b30f3f54c28c656c12e92d993c2bc9beb4e947d6bbb47ce68762a53584"
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