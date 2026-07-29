class ImagemagickFull < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://imagemagick.org"
  url "https://ghfast.top/https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-29/ImageMagick-7.1.2-29.7z"
  sha256 "943c3f9d9b9e5a1d4b9f29b9e60b01b0eb2376fb1da004c34a33594310a87fa6"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "4a8c4306945db620b337006cac06be468802dcf8883854bb35f2274131f7b9b8"
    sha256 arm64_sequoia: "2de080d1a1137291d9cd02df2659ecda7eb9073d695f819c83cc40acddd4cc0a"
    sha256 arm64_sonoma:  "818d671d2b360a0f9c1185cf5ce87e6e01e97e64a1639a1858a107a676af7f6d"
    sha256 sonoma:        "63e87dc2a69d26adf06b94a6a606c4c6ef4417420e7704e16769a1b4a03a6ab2"
    sha256 arm64_linux:   "8d5677c7315108d417ef1f8f4021ef056f47e61bd5fe38b42b810ce5ec74603e"
    sha256 x86_64_linux:  "17e3b23da8fab805ebe46423f9105054fb647cc3f51eb4ad7255a8990c521fe4"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libheif"
  depends_on "liblqr"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "libultrahdr"
  depends_on "libzip"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "imath"
    depends_on "libomp"
  end

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", formula_opt_bin("pkg-config")/"pkg-config"
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"

    args = [
      "--enable-osx-universal-binary=no",
      "--disable-silent-rules",
      "--disable-opencl",
      "--enable-shared",
      "--enable-static",
      "--with-freetype=yes",
      "--with-rsvg=yes",
      "--with-gvc=no",
      "--with-modules",
      "--with-openjp2",
      "--with-openexr",
      "--with-webp=yes",
      "--with-heic=yes",
      "--with-raw=yes",
      "--with-uhdr=yes",
      "--with-zip=yes",
      "--with-gslib",
      "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts",
      "--with-lqr",
      "--without-djvu",
      "--without-fftw",
      "--without-pango",
      "--without-wmf",
      "--enable-openmp",
    ]
    if OS.mac?
      args += [
        "--without-x",
        # Work around "checking for clang option to support OpenMP... unsupported"
        "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
        "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
        "LDFLAGS=-lomp -lz",
      ]
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      imagemagick-full includes additional tools and libraries that are not included in the regular imagemagick formula.
    EOS
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")

    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/magick -version")
    %w[Modules freetype heic jpeg png raw rsvg tiff].each do |feature|
      assert_match feature, features
    end

    # Check support for a few specific image formats, mostly to ensure LibRaw linked correctly.
    formats = shell_output("#{bin}/magick -list format")
    ["AVIF  HEIC      rw+", "ARW  DNG       r--", "DNG  DNG       r--"].each do |format|
      assert_match format, formats
    end
  end
end