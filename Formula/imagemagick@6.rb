class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-86.tar.xz"
  sha256 "5f3b9ef1bad7999d9aa6008f27f4190e6bed0c4f7f86c200b0a2bd8082aa724f"
  license "ImageMagick"
  revision 1
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "07c0ee0ce3152ab80f4c701dc8dc2a748d781fdd13670ad2e0ec365d844a632b"
    sha256 arm64_monterey: "5fe7f22ca76da9c888dced3830b4b008b49909793814adf0eb932a4e29cc07d3"
    sha256 arm64_big_sur:  "fb9058b68f51693a34841d666cc4adce3e94059bf17c75949a919aecc3c04b81"
    sha256 ventura:        "cf9331d61c09d6998263301455173e51baff9a566dc961d357328dfca42d755d"
    sha256 monterey:       "4e30732cad767a1f7bae23190579af7b85cf74df046c603d02822f9705422190"
    sha256 big_sur:        "58b13e4aeddf347030e3fb1423f5aa3f9dfa113c7d475816d482502a0e93ea69"
    sha256 x86_64_linux:   "83e4dc395ff1f8be86d5b4f7516b0843a737e5b8a2fd59b3ef7dbf6c681855a0"
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