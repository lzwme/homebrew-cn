class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.44/GraphicsMagick-1.3.44.tar.xz"
  sha256 "6ac28470d2fbd3d5f60859dd43f3cee2585e955e32896f892b4dc61dda101ea0"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_sonoma:   "0db18d3ae35193225727676d138e5d852d28a026f92144bb536642650bc43040"
    sha256 arm64_ventura:  "a942f2c4c3e10168cc908f19d39b6b1b3be18fac7d5ee88c6438b9b89467df44"
    sha256 arm64_monterey: "4b13a24a1a3705684566b2d72c5c33a7fceca5ec7a8de9e917f0b0b404e7ddd5"
    sha256 sonoma:         "fc66e5be23539aaf9df067ccc20fb46059ad71f429305fbd0d70ce84fc4a2010"
    sha256 ventura:        "fc8afab6aa173309a3691e3e87e4e26a7ef354a6236e121580d68b89ea5189fa"
    sha256 monterey:       "1fa1afa1668533d75458fa12760103270781df4650c6efd64cb3d374960fcb73"
    sha256 x86_64_linux:   "2e95a143dd858c7e5059c243517384f76b856550998a55f35c4f7e5f0d09d1b0"
  end

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"
  depends_on "zstd"

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