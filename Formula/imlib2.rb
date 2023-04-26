class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.11.0/imlib2-1.11.0.tar.gz"
  sha256 "94b74f7c28d5d05ac936d479f944a71222311b8ced8d012fd57010830faade31"
  license "Imlib2"
  revision 1

  bottle do
    sha256 arm64_ventura:  "7368221c2756a5057a611d07fcd8996d59c8225756b89cdf737cf802242507a2"
    sha256 arm64_monterey: "73ddb7a53d3f9faacdccee72a07d648a54ab5fe739e612c7bc2b269f7b48c1c1"
    sha256 arm64_big_sur:  "95f3387eb4d98ac1f8429656cfee0dd8bc3e5791932ff64e7b4056936c4ef8b1"
    sha256 ventura:        "50d982e12cf537e4ec18494b5affe7487e388fe45339c6f2fd75e56d0ddd2526"
    sha256 monterey:       "d5fca21b69decd032676d75901e636b5fd39eaf1bb6ac06bfd0fa7081a4ff7c3"
    sha256 big_sur:        "68907de16fc958bfb25140d25e50db38bbefdfe8ac8ff2e9addb767bd458c7e3"
    sha256 x86_64_linux:   "0324c27e31e303fc6bd4ecf6fc0513b001dc5b37db0df88ec0186f41c6bb2d25"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-amd64=no",
                          "--without-heif",
                          "--without-id3",
                          "--without-j2k",
                          "--without-jxl",
                          "--without-ps",
                          "--without-svg",
                          "--without-webp"
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end