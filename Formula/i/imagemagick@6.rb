class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-13.tar.xz"
  sha256 "b0efca4aa2d77d93c5165529879901a5e58ff84e04ceeb6c9c9fd23d181492aa"
  license "ImageMagick"
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "4fe1cb0a3216df1252cb4845a039cb453851dc01a9ab81004046dfac44a4c6aa"
    sha256 arm64_ventura:  "71f4348a5bd5faa5c7ad93588db10341721cb5fdef860b3e48940df4b2c50314"
    sha256 arm64_monterey: "75be8702cb0412185bbc01ac460cc51548a28147d238f244d1707f21c8e02ddf"
    sha256 sonoma:         "5a9f72f6180ec2e0cbb293505d3bc59b1cbe35e5a33e00902c79eddebf563692"
    sha256 ventura:        "1c5c05bb5b71483fc00dc8ebf89f9783f7bce2a199fc83a14b8818b490150c8c"
    sha256 monterey:       "7cc5210255456ac5e808254f1a300923da27e3d11cd8dbfaafb0dd7ed3e73083"
    sha256 x86_64_linux:   "893a16411cec7cce331bd1925d1adf0bccdd69742f9e734a646fa7d9acd230d4"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "fontconfig"
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

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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