class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-90.tar.xz"
  sha256 "c66a7e23ffc40b3cec748f117f44a3c6cd82bb7b2085d8bd0d3f3cf965935da6"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d6a018752240d6e50e8cc82ab0b35a5391b234ce1ff26ce351aa7f0d8a9a92aa"
    sha256 arm64_monterey: "74ed9d9041417c563670db64237ebfb9d9c4b205b4aebc598c6827a1278764ca"
    sha256 arm64_big_sur:  "c2aad3e6f9d98e635e42fc74973ba5551335c95b36de26160a42f31ca49e11b7"
    sha256 ventura:        "176b873b8aa3062b0ed6fba7be50b1fcc645225f7bd56fd21a4d3b1e22874bb0"
    sha256 monterey:       "f031f51cd301368bc32859f5ac28ef05366db3fb9cd28705ad847c5e109225c0"
    sha256 big_sur:        "fa686f81dda734bcaaca6219bbfc23409bb88a8a45e54f6ac76ecfe75f187951"
    sha256 x86_64_linux:   "b87d38da8d4b0023d959a1dcc4c3557d307f3668d129b55b1466cc63e96c529e"
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