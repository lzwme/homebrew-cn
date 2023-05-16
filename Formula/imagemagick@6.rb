class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-87.tar.xz"
  sha256 "27e33cfcb1d80298623e5558d0c54bd689fb5b89fecfc812dd985ef10064db43"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d31669b0a5c5a3a294d6e0d0a775095b22794ff168bc8b608849843e373feac8"
    sha256 arm64_monterey: "c8b06a6949ef39e402dbd321aad18c3bf2b0a21cb99f72df1a82159c85541660"
    sha256 arm64_big_sur:  "cd897953ad42baebcfc6bdc83d78f1c5e41ae910067bb789ad4825d0be0f1a58"
    sha256 ventura:        "6674d543c2b4d02f1c0435eb3448365d245f2e091a838d5269fca6339c11f746"
    sha256 monterey:       "f36c8d72900c65299810ca0666c4b8d6c67c1bdc662429ac0b4084389f19e6fc"
    sha256 big_sur:        "d920f3cf887013f0704302fe71d55880f475538f424553d77ecb405f69a4b47b"
    sha256 x86_64_linux:   "c32750a980094c56e8177878c17db689c4acf0bceebebc16b30fc1720a903764"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "libxml2"

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
      --with-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system "./configure", *std_configure_args, *args
    system "make", "install"
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