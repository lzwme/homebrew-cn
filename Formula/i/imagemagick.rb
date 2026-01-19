class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org/index.php"
  url "https://imagemagick.org/archive/releases/ImageMagick-7.1.2-12.tar.xz"
  sha256 "e22c5dc6cd3f8e708a2809483fd10f8e37438ef7831ec8d3a07951ccd70eceba"
  license "ImageMagick"
  revision 2
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "aad5fc7749d91edf4f9f8340a9a89b042368dc353e7751ab3fa463e2c78ec336"
    sha256 arm64_sequoia: "cb1edb6b9073b44f9a9a9a96e88f2061be3332a8a933e329540764f8cc0f2983"
    sha256 arm64_sonoma:  "068e0c8ba5387c15421a00265147b04c3afdff8aa7c56cb1841c9a9c4467955a"
    sha256 sonoma:        "d5b690a4b989f732c022673dc1a76ee566a10d290c536435b7408f74ef96c1f5"
    sha256 arm64_linux:   "724870b999a939457eb40326bdc8e8231b9a71f94a8b6cf50c19199b4b583df2"
    sha256 x86_64_linux:  "f9f3f1107aa32df9e481fca5cf2ade56b6d22072283d83d9007d1234d724c78c"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "imath"
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