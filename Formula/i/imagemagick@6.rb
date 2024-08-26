class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:legacy.imagemagick.org"
  url "https:imagemagick.orgarchivereleasesImageMagick-6.9.13-15.tar.xz"
  sha256 "b1030fa56cb98ea30c2b978ec0d00a753e85edbb80fe4f5890e15efd34614c55"
  license "ImageMagick"
  head "https:github.comimagemagickimagemagick6.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "2e7f4bc919583aa075ac58e9dc660a309a2336c9858664d02db21da2ba6e04e7"
    sha256 arm64_ventura:  "3a967e8594016f5cad699b9ca846e0afd8c095029a646ee1ae99ab72a184f780"
    sha256 arm64_monterey: "baca4ed7ac3971b64d84bc0af0fb340499233d2d312e0fddd3e1de48d12bf7d8"
    sha256 sonoma:         "1b2d8995cb7538109793903f8bd51729ba1d1f49b95511486f36648da01d1cbe"
    sha256 ventura:        "876bed9f042d3d12910af60ee50b867d96ae686cc7561753228b608f2f58dadf"
    sha256 monterey:       "49fe1dc593b7168ddecdf0237a3f66bd84b7e23f691fc2aad803d9657859701f"
    sha256 x86_64_linux:   "cc1d52234040ff3f21a8c11d6a4b652400d40aaafb61285a96b37a02bab8e6ef"
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