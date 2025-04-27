class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https:xkbcommon.org"
  url "https:github.comxkbcommonlibxkbcommonarchiverefstagsxkbcommon-1.9.0.tar.gz"
  sha256 "c8c4ccf203ff73b647ea70b67afa2fd749cd428cd027fc2e5ca3b9954f1d77a8"
  license "MIT"
  head "https:github.comxkbcommonlibxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "58d8d48578a320dcca4436845ea0db080b21185a4764938249d48568dfbe0e33"
    sha256 arm64_sonoma:  "7a67fad96dc7b9e18db49caae77ed79c1d6b99e69ebf2d1a5e3b19f629879ed1"
    sha256 arm64_ventura: "0f6b001f66a56a4d1c7149448a8d86e0846c55aa76a31358abdb71bde91eb66f"
    sha256 sonoma:        "9af5e61343cbf196f67d074f7d2a179b097251c894f29606390dd5187c8d15e0"
    sha256 ventura:       "e6a1b9b5e9957d9202638dc1d9146a5cefae1e28bcd7adcf352d84ae53dd0925"
    sha256 arm64_linux:   "a49af69398084aa5772141460b728da3d174fa193280d19eb48189a9af29e260"
    sha256 x86_64_linux:  "b03180dae431f9c24ad9d8288a0c1f7f14bddb8acba6e6240012e7dd4e99fd7f"
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