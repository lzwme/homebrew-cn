class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-35.tar.xz"
  sha256 "74371faeb647d2f402f0140618e9d832b6a2132e91c7fafdc4e9c69f7978debf"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d42532f606e251bfcfb374bd16a9e926acab2ee86631e33a84690db2a05b97f4"
    sha256 arm64_sequoia: "f432458251414d8fa6643eb58e6769b9a39e1f4bc274b664edf47dbdcedf0cb3"
    sha256 arm64_sonoma:  "8ed49f5d24ea6a9deed69b00195c321901e880828cbbb9c8172aeddc9ff797b7"
    sha256 sonoma:        "05c521a38ba174deb515aa109d25b9e75d6db466fd70fd82c07579412582654c"
    sha256 arm64_linux:   "742c74cf13cf1ba35453387fbe3972447f305b1757fe7532397004da409b6bb9"
    sha256 x86_64_linux:  "2affe62d57b7e4dc8dc11e5809ac2f4a23595dd3b48c474ffe8732f10899be29"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
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
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Ghostscript is not installed by default as a dependency.
      If you need PS or PDF support, ImageMagick will still use the ghostscript formula if installed directly.
    EOS
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