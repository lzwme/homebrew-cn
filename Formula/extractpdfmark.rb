class Extractpdfmark < Formula
  desc "Extract page mode and named destinations as PDFmark from PDF"
  homepage "https://github.com/trueroad/"
  url "https://ghproxy.com/https://github.com/trueroad/extractpdfmark/releases/download/v1.1.0/extractpdfmark-1.1.0.tar.gz"
  sha256 "0935045084211fcf68a9faaba2b65c037d0adfd7fa27224d2b6c7ae0fd7964cb"

  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    mkdir "build" do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end
end