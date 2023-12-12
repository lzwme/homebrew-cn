class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-1.tar.xz"
  sha256 "dea17ba878b1e70b8c5d670a980706c82d7592028018eaff2a826df5ad022167"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "59bedcbd37067326215f032cd895b910d7282080b5c5e68dd9dbf1d88a3f8eb3"
    sha256 arm64_ventura:  "7c5a12368a0cfd39103eb4dedecfc4403e97b463fc3df1dd33e799ef929acfa4"
    sha256 arm64_monterey: "bba488c8948fc96f6eba6b23be2e1733ede21859267974537533082c2003f9a4"
    sha256 sonoma:         "6a4b035e1ed932e0ba314fa6bfda63e949d4e71a2da61d69d7be7b49861165ff"
    sha256 ventura:        "bf91db1282ac56189697e981d9305504b34e0ae4443ee75fe99c4dbad4e58920"
    sha256 monterey:       "d2605b361995f6129f5c26e989f1bd3024676cb5bd7aa8ac04f17b1a60a682d4"
    sha256 x86_64_linux:   "51d4c7d364e4268f0eb3782a6f78c733ce44bee41715ccc2077db31dcb4ce493"
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