class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-28.tar.xz"
  sha256 "2fa42c194975775fe56939b201aee5a1a7e139c3618a880abc7e5613f15ecaa3"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "72a87ebc849b0f8b96264223f90fa441cf4d9a67980dc24b8fec3be5a86a47bf"
    sha256 arm64_sonoma:  "a9a14500e46fb5fc1a747a728e000f9931cbcf01d37072ab66e13ec2c9d905f6"
    sha256 arm64_ventura: "58f2fe5163373421dc82b1c79dfae2593fb2622b0f84991e07edc5df59ff9906"
    sha256 sonoma:        "bd7b3026f415f6cc3234a22548430751d5ec9fad2865f33aa0f219cd2e3824e7"
    sha256 ventura:       "a10ca0d71ac7f9a09ecc57983e46cf88a11ea40a5f3a1903c10ec86e029ee81d"
    sha256 arm64_linux:   "21a3995bab9d924df002a171389f2076105378879e7047fb2f5014bf94c162d1"
    sha256 x86_64_linux:  "ddae8ad0fbb33b92e4f437ca8f810d7626c2b21d946ce477bb7b891edceb270f"
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