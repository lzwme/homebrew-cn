class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-30.tar.xz"
  sha256 "cdaa1d22749e8140d866578bbae2e0b46fcbf6578dd3c73758cdffa7e32d55e6"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4b02ee922ed5488d59746221d1087e159337e9d78161ce4b21db714f253f77dd"
    sha256 arm64_sequoia: "ae8fe4c46524044dcad0331ea60272732710c8ee82eca0f90ed2e4291f9f9a3b"
    sha256 arm64_sonoma:  "cabd9da52d39caafa7525614ac2ee4b9c1b2439afd57303007ab723cade386ff"
    sha256 sonoma:        "dac23a04e97fb38b575522ebeb4580411f29086f217ffb8116c58c03b7e33b42"
    sha256 arm64_linux:   "4a29cc0b7f5d2efa8441fa7bfc114d877776722cab4ae74f35eb42fdfbe52f1a"
    sha256 x86_64_linux:  "40c3139220da1bf955e2b006f8a902a7cc3e0f0cd2868da6686897810a8d2b80"
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