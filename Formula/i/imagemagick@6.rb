class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-97.tar.xz"
  sha256 "82d006fabfb9848705de12ec43808250f242bf5e767a44663a6d5c4138119ffa"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cb0f264dae319c93230406415aa7c5a8e4dd5bcf995c6c7a921cee48b99c82a6"
    sha256 arm64_ventura:  "e5c5210f70ede165ba37d07eef1baabf86bb84ab1b008ca240e0fcf99e23f57f"
    sha256 arm64_monterey: "3fa0c782c40e973b30f81e0568ace371abef0ecc05fb95787269779c08a80ace"
    sha256 sonoma:         "a07de1b0846d2738ea8cceee89dee68632709ba0f7504302c96d804484d16218"
    sha256 ventura:        "e2e079bcc96dc91f2501ba60a3b67cd1ce286874b0b6d43234e8bbd461bc2445"
    sha256 monterey:       "0710b94958f51c38e0371044549e480ee781f36cd48abda6748d9654c8aaecc9"
    sha256 x86_64_linux:   "f234a0238a201716206b6efa0f1c1831c36c6868afda7cb40e47214df023a105"
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