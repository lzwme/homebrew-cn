class Liblxi < Formula
  desc "Simple C API for communicating with LXI compatible instruments"
  homepage "https://github.com/lxi-tools/liblxi"
  license "BSD-3-Clause"
  head "https://github.com/lxi-tools/liblxi.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/lxi-tools/liblxi/archive/refs/tags/v1.18.tar.gz"
    sha256 "ebeb8cb51f1024e198b3672aadaba113849d20b26199ae6e4ee679e555e9f274"
    depends_on :linux
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "997b6e87729a9b05f5cbefce050d43f223e881f07ac7ff395e316bd32014f36b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libpthread-stubs"
    depends_on "libtirpc"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lxi.h>
      #include <stdio.h>

      int main() {
        return lxi_init();
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-llxi",
                   "-L#{Formula["libtirpc"].opt_lib}", "-ltirpc",
                   "-o", "test"
    system "./test"
  end
end