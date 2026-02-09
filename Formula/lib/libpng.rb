class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "https://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.54/libpng-1.6.54.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.54/libpng-1.6.54.tar.xz"
  sha256 "01c9d8a303c941ec2c511c14312a3b1d36cedb41e2f5168ccdaa85d53b887805"
  license "libpng-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a23f0376db294bbb09ee8e23055df533985eeb1621ffff4d5921f67ee97cdc4"
    sha256 cellar: :any,                 arm64_sequoia: "f56418c7875657e8c021016714cb7b39a772e01abb694d062575761e8bfacf5b"
    sha256 cellar: :any,                 arm64_sonoma:  "236778ecc6aac0dd9123d824d7a31365584526f5399bfa80851e7226b8a53703"
    sha256 cellar: :any,                 sonoma:        "7e1572adedc0b34891928e4307866bfbde23329b6e5a538328e8504c48e85005"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e711ff10ab9ad9b3d306eaf2ec8334959042186a7bea73a866f143478724dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb2049e956d8e5e3695b9345c1080c68041996422bc379d2f5a45a3da97cf3f6"
  end

  head do
    url "https://github.com/glennrp/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"

    # Use Fedora's regenerated test PNG for zlib-ng-compat compression
    resource "pngtest.png" do
      url "https://src.fedoraproject.org/rpms/libpng/raw/49e9a06ca115aaa911dd3419ee79c1870d1428fb/f/pngtest.png"
      sha256 "f925a657a5343cfb724414c01e87afd4d60b1f82a46edc0e11f016a126f84064"
    end
  end

  def install
    resource("pngtest.png").stage(buildpath) if OS.linux?

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <png.h>

      int main(void)
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end