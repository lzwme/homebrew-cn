class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://ghfast.top/https://github.com/otfried/ipe-tools/archive/refs/tags/v7.3.1.1.tar.gz"
  sha256 "93bf863b757d7b7e29096b99cfb46fae8d354476b3c8ccb855e314ef792ba081"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4f6e9ba96322a350067c072d9ae5363303eebad345cb6d07e87df44c722a94bc"
    sha256 cellar: :any, arm64_tahoe:       "d8b6832219a141c994cb44204d7a6d96940e083c36f91b8083eaeaf0c4cea3a7"
    sha256 cellar: :any, arm64_sequoia:     "4e01c0c4770f7618f8d232989045635b0158a55a5fe6efd876da6a370c080610"
    sha256 cellar: :any, arm64_linux:       "f00e60561c20da1ff50e84a55e90972f88a5b7d3db1bb7f4b9f3d7a6e3399d57"
    sha256 cellar: :any, x86_64_linux:      "ce49485bf140ac3c0a8b6ea7345b4b20b15b3434a4f912320ddd0d55451c572e"
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