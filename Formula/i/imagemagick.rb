class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org/index.php"
  url "https://imagemagick.org/archive/releases/ImageMagick-7.1.2-15.tar.xz"
  sha256 "ccb9913bba578daa582b73b2a97e55db49765d926cbb8ebf54e4e79b458e6679"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3f8a65ffca7d6c8c229be73441105060a5d2bbb8b7e6b66cb1c141949fa6f53c"
    sha256 arm64_sequoia: "d660afd66d51bd27373da99d769e2c60021360cbce2a696040c8527cf14222c5"
    sha256 arm64_sonoma:  "926ff70af93c557b2deb96294e1d5496b178dab8dc730864910abddd16174ce1"
    sha256 sonoma:        "280a35fe63318e4fcbf4cf6cdefc4d9ddad2dfe14944ffd7319375ea73f4a8e4"
    sha256 arm64_linux:   "1b2a3c907b1ee82c4d9ab5c408cf1c578b9a054f649f2b3c9ca9b7cc36096b8d"
    sha256 x86_64_linux:  "da60f81da0dfde56720f93e9ecf175a59b9487c63d7d243aeeb5a354f08efc80"
  end

  depends_on "pkgconf" => :build

  # Only add dependencies required for dependents in homebrew-core,
  # recursive dependencies or INCREDIBLY widely used and light formats in the
  # current year (2026).
  # Add other dependencies to imagemagick-full formula or consider making
  # formulae dependent on imagemagick-full.
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
    depends_on "imath"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"

    args = [
      "--enable-osx-universal-binary=no",
      "--disable-silent-rules",
      "--disable-opencl",
      "--enable-shared",
      "--enable-static",
      "--with-gvc=no",
      "--with-modules",
      "--with-webp=yes",
      "--with-heic=yes",
      "--with-raw=no",
      "--without-gslib",
      "--with-lqr",
      "--without-djvu",
      "--without-fftw",
      "--without-pango",
      "--without-wmf",
      "--without-jxl",
      "--without-openexr",
    ]
    if OS.mac?
      args += [
        "--without-x",
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
    %w[Modules heic jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end