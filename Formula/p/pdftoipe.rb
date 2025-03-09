class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https:github.comotfriedipe-tools"
  url "https:github.comotfriedipe-toolsarchiverefstagsv7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68a3e91f7323cd0867aaf426d6c126373fadbd2b91264d394202a60f641190d9"
    sha256 cellar: :any,                 arm64_sonoma:  "60d519d3316da28051f0f947d05770c9460e38fdfa2351d6ec3e639b431c729c"
    sha256 cellar: :any,                 arm64_ventura: "884e36588f2a7bc9f7b1f6dc49d3ca4a2d83d65df9bb94d1fcb2fec9765e3004"
    sha256 cellar: :any,                 sonoma:        "38f9e64aff95f7c133f0033ba0fcd6714dca1c2fc010fd6ab50e9e2b36fcbc99"
    sha256 cellar: :any,                 ventura:       "6db18a68f9615bbba75a867be63b15329acc8b2b4ded0fde9568ce923f470c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f620738b3bcf41d3c8963752d354fc1ac77b9ea20ff20ecda7dfd32aa91736d"
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