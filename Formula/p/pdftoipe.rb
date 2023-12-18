class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https:github.comotfriedipe-tools"
  url "https:github.comotfriedipe-toolsarchiverefstagsv7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 17

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "35954871b12da2d4ae306c6242b5f76b0b9d92184c116047ec35ea4ef3468ea7"
    sha256 cellar: :any,                 arm64_ventura:  "00472ccf40fd114b37970e86342511cf064e49ecafa868503f0e15cc23808fb4"
    sha256 cellar: :any,                 arm64_monterey: "7a2b32a5f63792685af61ba8fcb57d0d3e23812a6bf1e7e42e3cda44b507a4c3"
    sha256 cellar: :any,                 sonoma:         "6469f8d2014033fb1b8c10a21689d042ea107b712a81c75f41cbfc6b5228d054"
    sha256 cellar: :any,                 ventura:        "3cd4f332625762310793d80a9c78c4f53657f5a31a067330b7f860d73f4b08da"
    sha256 cellar: :any,                 monterey:       "5107fc9b59224aa182933038873ccd1c6173cf17583a3a0e8e6eedca505fd0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acf90d0f6afd20e689a21868b4bf1e4ed9956328dc89f004820daa94f36c8b64"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  fails_with gcc: "5"

  # https:github.comotfriedipe-toolspull48
  patch do
    url "https:github.comotfriedipe-toolscommit14335180432152ad094300d0afd00d8e390469b2.patch?full_index=1"
    sha256 "544d891bfab2c297f659895761cb296d6ed2b4aa76a888e9ca2c215d497a48e5"
  end

  # https:github.comotfriedipe-toolspull55
  patch do
    url "https:github.comotfriedipe-toolscommit65586fcd9cc39e482ae5a9abdb6f4932d9bb88c4.patch?full_index=1"
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
    system bin"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end