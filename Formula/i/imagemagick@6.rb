class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://ghfast.top/https://github.com/ImageMagick/ImageMagick6/releases/download/6.9.13-53/ImageMagick-6.9.13-53.7z"
  sha256 "e5f2634ca4c82ff07875212eded7a20a608464ec257a405e73768ed795fbebf6"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "060c3416af3c308719fbfbb25fcf7a29a6d779c0fcbde5bedb419b009c874021"
    sha256 arm64_sequoia: "1aefec1e0d5f14e77b73fbe3d4ba8d19f25bd65490ce1ee5eb4bb1e20cb71859"
    sha256 arm64_sonoma:  "c19708cf8dd115d10dad29a805040b63d47482d0bf08e9c659e096c0cdc6ef23"
    sha256 sonoma:        "27b8acbf7cf2584649045e5bf80ae06e5640861d7342b3bf03e1548d8478ae95"
    sha256 arm64_linux:   "bd6af90168bc1aeb3fe7e04305f537032124776ec0a98ff6d066a802eebb4394"
    sha256 x86_64_linux:  "e4eb862305c3a8c6f412f6c3691d3b0d094bcbaca7fee9ef401918f67f500b54"
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