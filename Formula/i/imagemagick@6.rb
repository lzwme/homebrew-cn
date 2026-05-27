class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://ghfast.top/https://github.com/ImageMagick/ImageMagick6/releases/download/6.9.13-49/ImageMagick-6.9.13-49.7z"
  sha256 "c33f2e0e9ae278f25dc1f47c9b5ce42f53172ecddf81253f01e5bcc97a0083c9"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "1c312176f220d5369a331ffbcaa23ebb199d5548b2c11819a65277fb43942a7a"
    sha256 arm64_sequoia: "635a85a2c2789f1260b7f25397ea4f0b3ca294780a91c67f463f5c4ca1b6f2f4"
    sha256 arm64_sonoma:  "de1ed0f4f49fe4195b2b4f586e022f87dc63002ec176149ae0f6a5ae81c64d03"
    sha256 sonoma:        "1ce4c2384aa50125b07377dae9cc17e3f1a78aa1f8abc747193f20f27ebd25aa"
    sha256 arm64_linux:   "228e1ed33660cf4009f5a5fe8cf7f4a3ffc7b6228453a17b53adfaeb40498fa6"
    sha256 x86_64_linux:  "66b90a9382ac926a42b1648d526464d6497ebaef7f54883c33fbd857bdd2979e"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-05-01", because: "is end of life and only receives security updates"
  disable! date: "2029-04-01", because: :repo_archived, replacement_formula: "imagemagick"

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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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