class Xbitmaps < Formula
  desc "Bitmap images used by multiple X11 applications"
  homepage "https://xcb.freedesktop.org"
  url "https://xorg.freedesktop.org/archive/individual/data/xbitmaps-1.1.3.tar.xz"
  sha256 "ad6cad54887832a17d86c2ccfc5e52a1dfab090f8307b152c78b0e1529cd0f7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9af9c5dc615a960c3db2d58d06aad4176426991d1bbeb62895386002b1c285dd"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <X11/bitmaps/gray>
      #include <stdio.h>
      int main() {
        printf("gray_width = %d\n", gray_width);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "gray_width = 2", shell_output("./test").strip
  end
end