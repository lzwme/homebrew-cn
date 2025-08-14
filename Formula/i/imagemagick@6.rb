class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-27.tar.xz"
  sha256 "68997ff20ba40868ac03cd8da75a0bc96a8f4b73e99bf15f3293c1259f2ea2c5"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "10e86ddd3acecd221afda243456c18641927dabf79669f8a977e4a9dfaa4cd7a"
    sha256 arm64_sonoma:  "0dcbf0925e48828be52fc431aedc5b8102b1581b782244bf725cf6285ce26818"
    sha256 arm64_ventura: "02ad6c49eef16d19e79d503751e379c405cc9b9d03f1f59fb7db731a9a8aa26e"
    sha256 sonoma:        "82a0e1a462a9d55e1125b39ea5ca05e8d829f5c69cde69815d0b056e674104db"
    sha256 ventura:       "3932278cd474f2c3fc1fd4cc8640267142735300fb2b6b91f2d95cfbd012a449"
    sha256 arm64_linux:   "6b5fdefc6e49103d5f07c7a7bf87e980379369950220e7e2b847d7ec5d290235"
    sha256 x86_64_linux:  "7dbd73f6a92b177645779c726f67ca37f2b258363ad2794d08e67f36aca9618c"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"

    args = %W[
      --enable-osx-universal-binary=no
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Ghostscript is not installed by default as a dependency.
      If you need PS or PDF support, ImageMagick will still use the ghostscript formula if installed directly.
    EOS
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end