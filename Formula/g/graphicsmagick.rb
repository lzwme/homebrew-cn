class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.41/GraphicsMagick-1.3.41.tar.xz"
  sha256 "b741b11ba86162db4d4ec1b354989a773f73c40722d1148239f6c69c9f04a6aa"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_ventura:  "f7b8c2e7c65a55ec5f69cc621dc750559afe6615db3c01ac09be2266d2d6161a"
    sha256 arm64_monterey: "f9cf922a20de55d46901e9e767d28eb269ae81fbe9544ecc709c8fd87a6b93b2"
    sha256 arm64_big_sur:  "c3bf730c6046e819611af275786b4c370ebcc1bca520368beffb9e5e67d71b93"
    sha256 ventura:        "b3bcdb9316527c4309fecca441dfcf14597de283c28beb104193f1b1d1508779"
    sha256 monterey:       "b99bfc76808e6119c8706c09630567159ea7b63e115ce4009e57e395efb61ade"
    sha256 big_sur:        "6fd70f7706737eea23e1ec3ad6c3efb487343e1eaaea0daa4de433d56b795218"
    sha256 x86_64_linux:   "b8420ca7668403e46320f96a19d3be2a01604dfec5d53ae94dcef133f09321ac"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  skip_clean :la

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-openmp
      --disable-static
      --enable-shared
      --with-modules
      --with-quantum-depth=16
      --without-lzma
      --without-x
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-wmf
      --with-jxl
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "PNG 8x8+0+0", shell_output("#{bin}/gm identify #{fixture}")
  end
end