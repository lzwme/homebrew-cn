class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-16.tar.xz"
  sha256 "a2ca04c37ef56e669f442954d878bab7d096fadabdc75f6027f755bfdbf89a98"
  license "ImageMagick"
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia:  "b6eb6d29037266688445cdc3caff1eb9424fea85ddbbf3dc9e420bde629b57c3"
    sha256 arm64_sonoma:   "22e2b322e90a67f5bfd202ca5563b7e0092f9e4a588d2622a3814454cbda6a63"
    sha256 arm64_ventura:  "d523dba9fd8fbf18a727487fa97bd7b6cd5b90e20280389c2f8d28ba4797c601"
    sha256 arm64_monterey: "9457587c607afb849627928ba7989ca37937a48d4dd651594a512fa83d9a997a"
    sha256 sonoma:         "162c3cbb102b96ba4273b53998f2fc792e8f5f83cce4d945889652c306b02386"
    sha256 ventura:        "7d2099b5f94988b0eedb847622ae2d1aa42135e52c49c77ce94c81ad52a6553f"
    sha256 monterey:       "f8e7f4a45b7cc228414ab1d97a90cd08a189a5d2deb9c838fe88de3ab1c920f5"
    sha256 x86_64_linux:   "03540960f619e976bcfa5976b9ead240da6e12d0f6341a97fbc7612fa1d171e9"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "fontconfig"
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

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["***-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin"pkg-config"
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
      --with-gs-font-dir=#{HOMEBREW_PREFIX}shareghostscriptfonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system ".configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end