class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https:xkbcommon.org"
  url "https:github.comxkbcommonlibxkbcommonarchiverefstagsxkbcommon-1.9.2.tar.gz"
  sha256 "8d68a8b45796f34f7cace357b9f89b8c92b158557274fef5889b03648b55fe59"
  license "MIT"
  head "https:github.comxkbcommonlibxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "f49797532088a07fba256d03de9f7f1bb56bbc571c0c04777222608c80eaabd6"
    sha256 arm64_sonoma:  "e355311193b1a4c1ad4b3112a4131df9abac80ecf6b4474bacc3bc23afd99c25"
    sha256 arm64_ventura: "5b397f4df5f72c49b68fc5f2119d3d405f969ac02e00ad53466775c11a5e5d99"
    sha256 sonoma:        "63d1f21d7cb38cafc150e3b8fe2e9234d5697cf88d9b682372dc215f7ea39d0b"
    sha256 ventura:       "90b9243fa1274b316a47b19e8893708a677ed2759eb6f46bba3d9bfbbfc9a929"
    sha256 arm64_linux:   "c5c3d270eaccb9848a79b0b1f692008fa4eb51a4ac0510c6d7a636e42653db6a"
    sha256 x86_64_linux:  "83b375e99a63ac7a4dcb2bbc75edbba81ae1dade7aae0491d5bdcb639bbcbb11"
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
      -Dxkb-config-root=#{HOMEBREW_PREFIX}shareX11xkb
      -Dx-locale-root=#{HOMEBREW_PREFIX}shareX11locale
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdlib.h>
      #include <xkbcommonxkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system ".test"
  end
end