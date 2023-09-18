class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-94.tar.xz"
  sha256 "43ba0a0e63a854b4e15cad584af70b3f76c43bcda894e9165ddb963f35372af7"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f39ba5f5ceb3b386838350ae58dfe0b6c6a0a78d649f264aeca244770649b505"
    sha256 arm64_monterey: "ba73a76662bb0ec2bdbf33aca5c16bafb4f4c51718e1d38546a3bf997aaf752b"
    sha256 arm64_big_sur:  "8ff197025401a557e6addd9688647cfb9f4dc13c3464fb6dbf2d50a9a76e957b"
    sha256 ventura:        "b5e2fa3f1eec2818411c5c3a62f4bf5c592ba4faeaad39c7162092cf11c73840"
    sha256 monterey:       "47ab446f153af784ed4668d52c9bd6daddf7d8191b1c44a87558df2c804e6fae"
    sha256 big_sur:        "549249fad2183bb94dcd5767136e8592f05e028c85e8d0e50a9b740d8ef5acb2"
    sha256 x86_64_linux:   "a67e1dbb1df507085b197fcfd084fb785957013b132c56e1840b32f93cdfa92f"
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