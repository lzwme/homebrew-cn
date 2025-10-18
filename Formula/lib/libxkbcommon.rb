class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://ghfast.top/https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.12.1.tar.gz"
  sha256 "bb1543d956a5b962ee414174e9882c5d6fac3af9f95ebf48defb105151780ed1"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "333671e326f36362dbc6b0ca461b9594cd44f53591e8cc60c2ffa2d17444cd2f"
    sha256 arm64_sequoia: "5dc5e692f726fc2475254680d2e6dfd1211730292916fbc15f0ebb58db4216f7"
    sha256 arm64_sonoma:  "18fd5ae836bb88512db553d8af91d13da8e1874ca11a723759f38b03803388f3"
    sha256 sonoma:        "f19f4a7f65b43ad2b3e561593ccd7fdc7716069120619377bee536025c9235ee"
    sha256 arm64_linux:   "d5164403541dbf5475b3e15e10a7bfa6bd6feb0a3d3cec3e0e0dbf16a1c6533b"
    sha256 x86_64_linux:  "110aa7b28bb15a5f4379816fa064d7d07445cb41b8bac9a8751266f6f7380ea3"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libxcb"
  depends_on "xkeyboard-config"
  depends_on "xorg-server"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -Denable-wayland=false
      -Denable-x11=true
      -Denable-docs=false
      -Dxkb-config-root=#{HOMEBREW_PREFIX}/share/X11/xkb
      -Dx-locale-root=#{HOMEBREW_PREFIX}/share/X11/locale
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <xkbcommon/xkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end