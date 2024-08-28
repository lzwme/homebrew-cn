class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.45/GraphicsMagick-1.3.45.tar.xz"
  sha256 "dcea5167414f7c805557de2d7a47a9b3147bcbf617b91f5f0f4afe5e6543026b"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_sonoma:   "5b49a47176650baa6fe1f643865cc3ceeafad1d92958673f0f0bae392541149d"
    sha256 arm64_ventura:  "518d759a79475b2bec06f2b8395a39e4904a41ffc634b1cd40d28ff86f69b3ad"
    sha256 arm64_monterey: "f9eeb95dce4f039f74c295854a7f2641f9ce76f8632f3533151e58a6fb1febc1"
    sha256 sonoma:         "ce19d47f34de429083e1459bc7342ab8f21b86650357b07669cb8d76fd810253"
    sha256 ventura:        "ef58346c6097990d9b4c1a38766c8bbe3a867991ce2a586791b3d4feec1d0285"
    sha256 monterey:       "f78b6f0ea1f650451702d430805cd5737e454712d089af8b668a7ce3ec34cb75"
    sha256 x86_64_linux:   "0561ac8547215fedc9408cd0c6e6a9e3927302212219b5e89b3bab0c7ae685eb"
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