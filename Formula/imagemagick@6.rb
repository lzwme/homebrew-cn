class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-92.tar.xz"
  sha256 "3b177e9976f1051a5cf94859916cda375038e35721ef66a61d39cf1c2b595b80"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "abdeaa4b884cd0a352ab1a1d060ca3b2010634a68980921e245a7096a83c8fb3"
    sha256 arm64_monterey: "06fe94f3e671fe90f5f713492f1f130912c2f72808a20af54d3e0f3694b6d8e6"
    sha256 arm64_big_sur:  "0d0447caf0749aeaf4528af28eb92958e6a3bbfdd43e06b3fb267a193fbf6cb0"
    sha256 ventura:        "90c5163f553f72b3a628581b299226575014183ebc46257b27a90d90fa3642d6"
    sha256 monterey:       "983eaad57ce914da420434612f5d860a959a7a4a7344fa2246db86947f6c5e87"
    sha256 big_sur:        "55c2ee01f98970804e98ca17c85f39e5d55c29ce03fdbc2560353322eae8c50c"
    sha256 x86_64_linux:   "714000ec5710947be7620fdecb8ba9225fe598d79908558c8fc48d30e455990e"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

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

  uses_from_macos "libxml2"

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
      --with-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system "./configure", *std_configure_args, *args
    system "make", "install"
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