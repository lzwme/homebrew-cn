class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://ghfast.top/https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.12.2.tar.gz"
  sha256 "40a333433d850c308f6fe8b15b57c54c769aad655e9c6563cc288bc650111ecf"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "42e74feb3c586437b21966eba85fd015e93c7c5916df1416f6fc29ee8ce5f68b"
    sha256 arm64_sequoia: "1649b860aa8322799d7e56210602471cc7d4092a5b6c0b8c052cb7381f692d11"
    sha256 arm64_sonoma:  "cd1261fc3b6bfe09e285bb1ed1853c5fee9c7f4b886190f06339b39e5b8513b5"
    sha256 sonoma:        "d07296002e8d5c63f1e9a26add2f87fb348df9167433847862f7d3e69e365806"
    sha256 arm64_linux:   "a9c5932a99aa8179047d250b181bcd0362a8a969aeed916c8b9aebab3bbce03c"
    sha256 x86_64_linux:  "cf829e51cde5946825e326ff25d1bc7a62088226f092a64e3bafc1c1613026f7"
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