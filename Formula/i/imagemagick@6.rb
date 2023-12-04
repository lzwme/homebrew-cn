class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-0.tar.xz"
  sha256 "2075d939569e1705ecd3d46777195d1b7c1ea0946dc62191e405b9ea0cb366e4"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "420f154a2c2924cfd5c35f6558e62164924d67a7967b38a92e6fa545c7ef3cf2"
    sha256 arm64_ventura:  "04e883c91015aa6f5925b280a3a808c63b705a8d7fb145368821a11e4be766dd"
    sha256 arm64_monterey: "28f7e7e39358039308b68a8dbf433ae24b4d448eb3db3bf59d2fda4868a97acf"
    sha256 sonoma:         "e350129b2e0d715057006b6ba579699657bb59e9439383e9de9d9fc9606d777a"
    sha256 ventura:        "e4d1dd5024142c66a3818eea1b8bad20f5755f028ec71e473e247814b3f0d217"
    sha256 monterey:       "b6456616c286a2dd4d93e137ede4416c51ba12d70ce97a965571dd75c1843f7c"
    sha256 x86_64_linux:   "e817599b2862972ef3a7cb60b5adbccfc778f4db8b4ee35e4d7b652e7a9e9e48"
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