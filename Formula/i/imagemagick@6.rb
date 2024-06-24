class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-12.tar.xz"
  sha256 "cc6189a5999c00f2fb8a0cdd2cddd8207c64bac5146639b8106e56e277c763bf"
  license "ImageMagick"
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "f76756292de52e317a58b4440500e43cf8449ce2a1cb150bef9b7b30c951ab5a"
    sha256 arm64_ventura:  "838ef20ea7c633260526ef435480716750c0ca6d5408df9d0de18b99de5ca797"
    sha256 arm64_monterey: "afd4afffb4db78fa09ec69d6c0cc49a76ec757c4b08645c2ec3b661768664edf"
    sha256 sonoma:         "31ea028d7fbf01fe129eaec4c93490b1329f295345144751bb65b4d54626af7e"
    sha256 ventura:        "e06276c1ac9fe19819090f6d450fbc4a442eb1c6b23b43ab44bf2a7087b35847"
    sha256 monterey:       "947f68f69faadf79d2ab061487afa3a72fd8a9caaf0d1622c213ccdbdb1e7d7a"
    sha256 x86_64_linux:   "49644afbc7bc6df0d0a4ea3942ba3f7b2c652dbf249bd52d2422818cfa401e74"
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