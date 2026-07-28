class ImagemagickFull < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://imagemagick.org"
  url "https://ghfast.top/https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-28/ImageMagick-7.1.2-28.7z"
  sha256 "97bc448de722b09d1b22d8c7799b3cb61f37edfd7112752269e47a110af087e1"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "ac41f071aac3b752bf95504e0f042e061c90d7c79597c068f7df78a0e45674bd"
    sha256 arm64_sequoia: "d242639820733ec29f37bc52aa99d559305c2c90dfdb5a7f92439fd3427f87cf"
    sha256 arm64_sonoma:  "2d1a1e7595a4997aa534909ad9d8de74fbb21bf221789a492a0eb39bab33851c"
    sha256 sonoma:        "bc10e93236f80b6ae0a8f2844d51f3dfe578d2f54a71f9a98d45ebe86bdaa686"
    sha256 arm64_linux:   "7194e8f48356e839aac3f509d3e55636fa5b469ed051b07f821a2ce0c59e8dbd"
    sha256 x86_64_linux:  "8d0e1d8d4b7d78ff40e9204e662ef63cf59dec5cf84f2fbe780ca3af55d1dff1"
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