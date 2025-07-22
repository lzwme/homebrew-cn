class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.46.4.tar.gz"
  sha256 "d09c44ebc3bd5bee7021c79f922fe8fb2fb57f7320f55e97ff9914d2346a591c"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47c77f5ccc98501480075a102c991846fe45743d10aa6ae9618b0e1c0c774021"
    sha256 cellar: :any,                 arm64_sonoma:  "fa7aeb6e76dbbd4637d4ec8c60d2ffc13c5273baaa68c2206a9b28fbdcccd373"
    sha256 cellar: :any,                 arm64_ventura: "10aba865fc912dcbe715ab8226f72039248941ef3c657adc8d8e8ee40235d179"
    sha256 cellar: :any,                 sonoma:        "7c440ebc406d87a27205a1c0133cd5d49c34fe5c081ea266ccefa96b31cb458b"
    sha256 cellar: :any,                 ventura:       "9d70f9dbda733a7e7beab0b0a9f84a477837384deb36fb1677798e0233537eda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24768eb21da5705ad9322d402b68542bde481eae64b930207df73a20804e176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1ccfbaf5b251f8d2f07d69dcc5338ed40d241e8f194eb4a00da26d836c5f33"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs pixman-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"
  end
end