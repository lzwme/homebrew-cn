class Fcft < Formula
  desc "Simple library for font loading and glyph rasterization"
  homepage "https://codeberg.org/dnkl/fcft"
  url "https://codeberg.org/dnkl/fcft/archive/3.1.8.tar.gz"
  sha256 "f48c793f354b8be95477e475dde7c98ac9d2628c52ecb42029dc6d20b52d787c"
  license "MIT"

  bottle do
    sha256 x86_64_linux: "b4baa19b9ec39432ee2885a1befe23eb981c8754a87af792aadef35184fca734"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <fcft/fcft.h>

      int main() {
        printf("%u", fcft_capabilities());
      }
    EOS

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