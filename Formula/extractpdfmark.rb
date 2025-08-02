class Extractpdfmark < Formula
  desc "Extract page mode and named destinations as PDFmark from PDF"
  homepage "https://github.com/trueroad/"
  url "https://ghfast.top/https://github.com/trueroad/extractpdfmark/releases/download/v1.1.1/extractpdfmark-1.1.1.tar.gz"
  sha256 "c62f3774c5a97df0517042dd5bbc1c3cdb65687617d1f0a3e8a6910f3191a21b"

  livecheck do
    url :stable
  end

  depends_on "make" => :build
  depends_on "pkgconf" => :build
  depends_on "poppler"

  def install
    mkdir "build" do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end
end