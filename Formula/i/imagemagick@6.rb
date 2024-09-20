class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-16.tar.xz"
  sha256 "a2ca04c37ef56e669f442954d878bab7d096fadabdc75f6027f755bfdbf89a98"
  license "ImageMagick"
  revision 1
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "8f604cd071b004863d5ef5e43f488474315cd34da56cce1a0f67384c406bf71f"
    sha256 arm64_sonoma:  "f79536fdaeee84255d18817097032c94ffc05a272f3332c798cc437d021cddd3"
    sha256 arm64_ventura: "b876b1cabe6de56ce80e000b38f2d6dcf4be0904a2d728edf0f6815940302003"
    sha256 sonoma:        "031f301aef21795fb538aa752cead963376521ffe5615dfc1e0333d59bca2c45"
    sha256 ventura:       "42b248e9c26b0127826d710a7f2a83e1fd8cf99cc4483fdb7ea7d2404200a8e9"
    sha256 x86_64_linux:  "8d72f3dca188b36694698f65f8f1586baea75309f7d82944202743d9d362f912"
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