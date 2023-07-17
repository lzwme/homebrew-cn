class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-91.tar.xz"
  sha256 "f9ecb6bbb19344f3fbde839eac645a7d4777642848dd985f23eba708825e2d36"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "952c55b63071f9e27323e0d2f809d7cdeb65207bd5a0a1aa3c612311103a70f2"
    sha256 arm64_monterey: "9caaed548f0a29abf76ffcfc4c4b5fc84504915cc4a7ce3a8cc6d12d899d9a90"
    sha256 arm64_big_sur:  "64f23503da2ec0b2744b658ddde82a20a0b158fd98e2e16f2f29707f9d24be9c"
    sha256 ventura:        "d6ba9e5349720226fb00decea73fbef8b62c02ec85c65991ae2ea284ac7fb26b"
    sha256 monterey:       "4ba9e5db6f13d0bbc9e2c70ec8f85f3b0ed9833da6d443958eb045cc56a791f7"
    sha256 big_sur:        "05985da840f4cd3f1d4e3b60342557e5e018ff6ddf476f56055f3c3b3b633e32"
    sha256 x86_64_linux:   "22fe6630f6c04035d1bd65d37133de88ed251c492636a8e402b7df1af45dea76"
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