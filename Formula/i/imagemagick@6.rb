class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-5.tar.xz"
  sha256 "485dcf2d070dc94699de771cbd27db8e7b8c84d6bced04ca194cee31f8842cc8"
  license "ImageMagick"
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "c718e46f1aa17504facbf70ac03a996e0210297ce814f57029038a9e8cd452ba"
    sha256 arm64_ventura:  "0b2183e03635b236fe1a2e5604c0ed054ebdee0642b9d6d2e638be8ae5ebcfba"
    sha256 arm64_monterey: "9fcd8ca24a61ade6d5e6b1b4d96898b328ac76528d5b5e10364c516ef2495f8d"
    sha256 sonoma:         "05fc02788b5d8a540741fd6af4577d63623ac1b9d7d4d20a9bc1c0405ebb2425"
    sha256 ventura:        "99fdc0ff3c1c5179133f78c03f4857a25d778099c821ceef6131451708a60af8"
    sha256 monterey:       "96dca403ab59fd5e342da10c6996955a2e83ac22b9bbb5b811d60223387e8398"
    sha256 x86_64_linux:   "4e405a2caecd7bf77fc885ea746dabdf16cc6a3539e1491e461d817a9f390421"
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
    inreplace Dir["***-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin"pkg-config"
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
      --with-gs-font-dir=#{HOMEBREW_PREFIX}shareghostscriptfonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system ".configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end