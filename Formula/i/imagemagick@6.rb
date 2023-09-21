class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-95.tar.xz"
  sha256 "14c22a96248eda34a3ef67376ab765ea10fd133d8bd33ec5c59b237f5bf5ae5b"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "859344befe582a947089598baedeecdd0f01cd8da71dd7f9e590e29d666c3d8d"
    sha256 arm64_ventura:  "b55cc010132d648d70d36bcee27a02afb065585f5c2356843146d165b53b9b7b"
    sha256 arm64_monterey: "2d2c61acfc1143430237819e07d3459cc954c7132de02c9d9598be23c1f0dc30"
    sha256 arm64_big_sur:  "611d0784a76d8d6565e55bf43d1ba99106a6b20ba34af51be76704aa16c95b1b"
    sha256 sonoma:         "fc36c8f25511108ecb6ef1b7b8e9e487afaa5217c27b6e88df82df4431ef1c2f"
    sha256 ventura:        "82b57cc16f7ab9eec5a75eb8fcb5d4c007559f29e62132a2141d1b0abc15393e"
    sha256 monterey:       "3c42a608451143ba05447c81dc807b0ca7951ee8b50005f3564766e951d91cfc"
    sha256 big_sur:        "3d41f4561467c7272447b38ead8cc25dac20551d0cd2a54f3c9b3c7c977664c3"
    sha256 x86_64_linux:   "0094439f40a233692f3e49bc699276f6e9405a7dda3609cdfb8643d6ca8a46fd"
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