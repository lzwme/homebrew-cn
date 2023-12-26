class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-2.tar.xz"
  sha256 "8180a4a9f368ebfbd5e2d921e0888b1a3116caed7893e73dc97f2d4d3b591e0c"
  license "ImageMagick"
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "8d264b718d9d2190ff96cfde814695c80a5ee04772f9dcef339da6d2f79da66a"
    sha256 arm64_ventura:  "c98203d94e0402aace34a41186c3ffb26b535cdd0d51bacc4d7044a29efcae3a"
    sha256 arm64_monterey: "e54af5b331a9ff7ecab76570a2409c2f3d9771b1f6752c0058e1950e531e8ff4"
    sha256 sonoma:         "da9ecca4ba56fbb611af39fcd3cbceb6f5f4b7b7ddee19a9fe980766ba5cf3d0"
    sha256 ventura:        "1520f55d21659c8c9cdd97ca5f56dcc3abedb147780ddba095702fd197c5cfff"
    sha256 monterey:       "a02b70202a8470e26e58317fa8ce886c52e6e2f875e40b710428b56dd6475fe9"
    sha256 x86_64_linux:   "a22be8f004e01830a73d546e57b0b7cff1cac07e30b2808b821187bce1a162f8"
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