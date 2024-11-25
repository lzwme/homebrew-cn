class Fcft < Formula
  desc "Simple library for font loading and glyph rasterization"
  homepage "https://codeberg.org/dnkl/fcft"
  url "https://codeberg.org/dnkl/fcft/archive/3.1.9.tar.gz"
  sha256 "4b7e3b2ab7e14f532d8a9cb0f2d3b0cdf9d2919b95e6ab8030f7ac87d059c2b6"
  license "MIT"

  bottle do
    sha256 x86_64_linux: "962ff7e1761e82e6b50e7790011c405ebedfa25688ecc5ad373f902b506d14b5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on "tllist" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on :linux
  depends_on "pixman"
  depends_on "utf8proc"

  def install
    system "meson", "setup", "build", "-Ddocs=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install "example"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <fcft/fcft.h>

      int main() {
        printf("%u", fcft_capabilities());
      }
    C

    pixman = Formula["pixman"]
    utf8proc = Formula["utf8proc"]

    flags = %W[
      -I#{include}
      -I#{pixman.include}/pixman-1
      -I#{utf8proc.include}
      -L#{lib}
      -L#{pixman.lib}
      -L#{utf8proc.lib}
      -lfcft
      -lpixman-1
      -lutf8proc
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    assert_equal "7", shell_output("./test")
  end
end