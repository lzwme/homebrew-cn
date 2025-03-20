class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.4/imlib2-1.12.4.tar.gz"
  sha256 "3dd6538dd012ef140e051b9579633a7c4b073e088326d65df4d3b2d6099193b9"
  license "Imlib2"

  bottle do
    sha256 arm64_sequoia: "f086c023ed90f2592ac79b70a5d70914e7eff88e5e9b4ff37efb7ca6a8db96d4"
    sha256 arm64_sonoma:  "b6a483da0b8b0eed134e03851d62639a7045637b98e7472150fb885040ea7640"
    sha256 arm64_ventura: "a27764e0648e9714278accaae283735b2bcd73d702a778bbf454dfcf0752ccf2"
    sha256 sonoma:        "b57d32769422da53b28b9db418f1e5c64336491f087da7bb3fd554c9a3be266a"
    sha256 ventura:       "9d01353598155cf25747e1aa49e132a4a8f6a26db4ac702a7d6de0d95fdced0a"
    sha256 x86_64_linux:  "fad41d330d00be8fd0f3f775670be7d4aa4c0e3042e619855396ab5a000c4430"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-amd64=no",
                          "--without-heif",
                          "--without-id3",
                          "--without-j2k",
                          "--without-jxl",
                          "--without-ps",
                          "--without-svg",
                          "--without-webp",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end