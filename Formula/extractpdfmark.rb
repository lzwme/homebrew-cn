class Extractpdfmark < Formula
  desc "Extract page mode and named destinations as PDFmark from PDF"
  homepage "https:github.comtrueroad"
  url "https:github.comtrueroadextractpdfmarkreleasesdownloadv1.1.1extractpdfmark-1.1.1.tar.gz"
  sha256 "c62f3774c5a97df0517042dd5bbc1c3cdb65687617d1f0a3e8a6910f3191a21b"

  livecheck do
    url :stable
  end

  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    mkdir "build" do
      system "..configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end
end