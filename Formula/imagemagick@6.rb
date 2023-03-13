class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-81.tar.xz"
  sha256 "b7bd3d557d19fe04cc68d15c6d34c3150d9dd7eb762fc4997ac00b4aad690732"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "22670bc7f2b7bb32f21029ca6b6b2ba0dd93ecb1a09d61ad2598d1705ccabd15"
    sha256 arm64_monterey: "3b3da6fc2d8079113909abaf20522a95b2ff46c9a86cde8161db55cdba2bd53e"
    sha256 arm64_big_sur:  "1185fa6f8e301b1d61911f02b6500e530b258749ae18263201e35609d5acb12a"
    sha256 ventura:        "b8be4de5e0232ddfa25b5c2ce57761093c7c783c0bca114758f59b8e0fc84f0f"
    sha256 monterey:       "e9bd775722ad600460348a5bdd0972ec778896d746efffe08eed2926dfebea91"
    sha256 big_sur:        "838f91b02e72d1a108c1f5fe4c275b0c77080c44af04695cca244c93725c3ecc"
    sha256 x86_64_linux:   "fb30e40051a6d5ced25f9c1a2430e622a0be02dd12cdbae6fb6b883e7e8a2530"
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