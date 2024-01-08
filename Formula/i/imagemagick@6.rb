class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-4.tar.xz"
  sha256 "a64ee089b06f7d76f09ddbeeff73fe32593ac0ff548a85fee0d28cb76ea58a6c"
  license "ImageMagick"
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "6a329c6a355a5c714a9d7312516441c36f39fbf275a57251d00c967e223d4309"
    sha256 arm64_ventura:  "60c579c3904790942d84b9c5f79e17c2eca636706a5910e1627755e5b501cf6d"
    sha256 arm64_monterey: "0656df2caef7b0739672199634eace2091aac836bb72b7783c17c79751167c5b"
    sha256 sonoma:         "64cbed3f6e3102c9a01aef4bceee17da8ddc218d044e7648a8bbee36351cdf1e"
    sha256 ventura:        "9e61b59a42cc4c792adac3701abc7dda21e7d52d9d3eb11ac1ba94c80bc12d58"
    sha256 monterey:       "1700dd208f291f3f88cdb712fca3836d8f08d5dede167a68bf9cd78008f2adbb"
    sha256 x86_64_linux:   "f837b66ef4a65c2f4802a00542a00e36e1527f1cb757d079b357e3800240ec86"
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