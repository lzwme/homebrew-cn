class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https:imagemagick.orgindex.php"
  url "https:imagemagick.orgarchivereleasesImageMagick-7.1.1-28.tar.xz"
  sha256 "ee4b6cdaaf2fa6020b6a3c6e055d993e970361a2fadf2bf2f984308b35c61915"
  license "ImageMagick"
  head "https:github.comImageMagickImageMagick.git", branch: "main"

  livecheck do
    url "https:imagemagick.orgarchive"
    regex(href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "9487c6b07cd4032fc30962585d509b2688521a2d04810f6e3cb6b9d4a3d34065"
    sha256 arm64_ventura:  "1b78d8f307df9f94d8572dbd9b656dd7fe5111909ffb0a7ea4c655e1a66144cd"
    sha256 arm64_monterey: "84d8ba2acf779adc56fda0d5a8f2be0bcd24d61a88a2162f9c2229becbde4d98"
    sha256 sonoma:         "d2a64c11743156ee1c41d4fa3cc9c53eededb020533e121768307c338b9ff070"
    sha256 ventura:        "cf22aea782b9d627450b8deefe7aed195ed3b9e2ae910ac1baae8a7e26b1a187"
    sha256 monterey:       "5390caa815b6b0bdb2268803990fe07b744e1962e0551e73f15b221dcf5c921f"
    sha256 x86_64_linux:   "415e72b636e45fe94b9f07a1edf210b33bf9618aacb06c9eeb30bf0c84d4684e"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "liblqr"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "libx11"
  end

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["***-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin"pkg-config"
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"

    args = [
      "--enable-osx-universal-binary=no",
      "--disable-silent-rules",
      "--disable-opencl",
      "--enable-shared",
      "--enable-static",
      "--with-freetype=yes",
      "--with-gvc=no",
      "--with-modules",
      "--with-openjp2",
      "--with-openexr",
      "--with-webp=yes",
      "--with-heic=yes",
      "--with-raw=yes",
      "--with-gslib",
      "--with-gs-font-dir=#{HOMEBREW_PREFIX}shareghostscriptfonts",
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

    system ".configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}identify #{test_fixtures("test.png")}")

    # Check support for recommended features and delegates.
    features = shell_output("#{bin}magick -version")
    %w[Modules freetype heic jpeg png raw tiff].each do |feature|
      assert_match feature, features
    end

    # Check support for a few specific image formats, mostly to ensure LibRaw linked correctly.
    formats = shell_output("#{bin}magick -list format")
    ["AVIF  HEIC      rw+", "ARW  DNG       r--", "DNG  DNG       r--"].each do |format|
      assert_match format, formats
    end
    assert_match "Helvetica", shell_output("#{bin}magick -list font")
  end
end