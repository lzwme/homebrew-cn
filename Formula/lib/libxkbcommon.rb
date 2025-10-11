class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://ghfast.top/https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.12.0.tar.gz"
  sha256 "bf9d9e0283ef4211f1f3f228787d38ba095fe9f0e84c5f798b6a8661033a9b51"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "f5add030b9d940169bd3fa1a33dca13ccdf85f2d6bf16450305612bdd4e6e6d9"
    sha256 arm64_sequoia: "c633ef79b2894b188c946c418999f6c34a6364b1cb9ce3facbefabc3dffd3500"
    sha256 arm64_sonoma:  "cab44a53afb8b4b0c9b2dfbc1b7b981a37f78d967024f1f45717497a180881c2"
    sha256 sonoma:        "1b3878edabd5fbb4a0ecbed679ce80265443d175aa51c4bd5aab6adf92675f06"
    sha256 arm64_linux:   "8a9d8aa1c9ca9c0ec2371b8830c8defbf9db3f2742fa5a367c2efc7f0bd5ba85"
    sha256 x86_64_linux:  "f27756e45d8f825cb1bfae84f7527a8dea494c3e4251a0fa879d4ab075dfb62e"
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