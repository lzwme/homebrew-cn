class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-22.tar.xz"
  sha256 "feab663be1e328d81a9ee7916177d92f79c220f0c390094ea68134f24d11acdb"
  license "ImageMagick"
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "812b908738bcb71d7e1e3de3a61cd1205e58693a6282f392896dfec8dc8f8969"
    sha256 arm64_sonoma:  "07525d3ee7ff076d64207e4fafabf9dd1aca598bbd06eb1b45a4ee7c7c122281"
    sha256 arm64_ventura: "1cf247e97a968ee425a83d08fc229b1ab3871d6e1795f399ce1cfaa59c9aea3f"
    sha256 sonoma:        "8beef23c4b49530ab9cea5d57eb768ca11226b45c0248ec5dffb19b30b31f6df"
    sha256 ventura:       "bab3c47f7dee131ed97362519cc3c6d6c8393896b76a13b2b19fb37b44407c0f"
    sha256 x86_64_linux:  "ac77d302bc9b52534835038d1dedb788684e44d9def218b6487ae2c5c812cb42"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build

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

    system ".configure", *args, *std_configure_args
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