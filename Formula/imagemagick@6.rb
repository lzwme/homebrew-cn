class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-88.tar.xz"
  sha256 "619e42ae6a3c23b72c4ee166fc37973a1634c7d831106162780d5df968b5ce2b"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b97dc015369b02895e68b3b72432b69475bd659b27845674517fdd0f4461a9de"
    sha256 arm64_monterey: "b15f6b245a5b24eef307e649d700909e2ce6dbf4bfe16b8ec676d408d3f50f63"
    sha256 arm64_big_sur:  "d03f1909a9492a460396d58e56baad0b8810e9724af696aa17a4a8b5cd771ee0"
    sha256 ventura:        "66db8d824d41e2351569523a3fd5a09f6f318b24fa0dcb1bddb45822bbd078f7"
    sha256 monterey:       "af128ed695f2397ab7b86a9944225bba7282167f07075e909f662c94e282aeb2"
    sha256 big_sur:        "d2d29112bd1c198c53ab06ef08ce37b36cc5d3ea39653de53cc1b27b6a0fa38f"
    sha256 x86_64_linux:   "19cffc1e7ab426df6e1f042b854b9cf79181395a3dc85c8c2ecdcf4b61b5704b"
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