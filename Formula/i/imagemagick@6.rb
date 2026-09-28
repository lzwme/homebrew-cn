class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://ghfast.top/https://github.com/ImageMagick/ImageMagick6/releases/download/6.9.13-57/ImageMagick-6.9.13-57.7z"
  sha256 "c630a776be1956b8941e27d2f536957158c98845a10b5e7f60ed434844764a55"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_golden_gate: "d2b262d17eecdb9ca2da22f03ca5ff31a8ddde31392471924aefe473ecc0b259"
    sha256 arm64_tahoe:       "19c017dbeb4d389b074223b932272a7b1346253c316a66693966042ba9b7c5ce"
    sha256 arm64_sequoia:     "6fee5bb7463dad196182e4ce2c3f49fa5b0a49ab870a62b0e348a3c93ac939a8"
    sha256 arm64_linux:       "d5c336a59ff2be832e0ad0f16ecc6797bf8475f212706e04ea6cc289fbc6bda7"
    sha256 x86_64_linux:      "f5cfe978bbfcec811621a2b9c90c40d137ca23d73f8eb1b63d063990e2155e51"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-05-01", because: "is end of life and only receives security updates"
  disable! date: "2029-04-01", because: :repo_archived, replacement_formula: "imagemagick"

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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", formula_opt_bin("pkg-config")/"pkg-config"
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