class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  stable do
    url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-83.tar.xz"
    sha256 "73c8764a550f40b23615a749ef20438eb78a426128766bf3f63a705fdac142ed"

    # Fix an undeclared `jps_image` variable.
    # Remove with `stable` block on next release.
    patch do
      url "https://github.com/ImageMagick/ImageMagick6/commit/65692230ba98b5735b911565682010afc67c769f.patch?full_index=1"
      sha256 "e4d8bb4b34b3604e6a95df4833c301ace9fb4c14797f366e950e3aa04aeeb0d5"
    end
  end

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "04be093764fd8090e25d02d95efcc47468e1fd890153956941b616d3062e6b35"
    sha256 arm64_monterey: "a9d28b19c12e7493ced9c4eb8eaa4b37ee2575fdbb2f32948cf0d69c39d043f7"
    sha256 arm64_big_sur:  "93bb606fe140768f0978e3753ed3d54c439a2cb5b6b1729a83f781bc7e56db12"
    sha256 ventura:        "0edbc9c1b3a39e5cd69802316db427a525c54f3407f1fb98f27fe081638b70db"
    sha256 monterey:       "2e8f4af82d89b4cd38f7c75a1bdc28e7ecd1c9257e94ee7fe1958a87287d8d84"
    sha256 big_sur:        "da27e1125156ec0da0065a8b5a3f1d7c3008154a46c1399710a6ca52155cec0d"
    sha256 x86_64_linux:   "d2e0bb90f135286149bc007fbacc36d7a5342c7993ed822385e2e2377963a378"
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