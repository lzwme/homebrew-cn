class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https:xkbcommon.org"
  url "https:github.comxkbcommonlibxkbcommonarchiverefstagsxkbcommon-1.8.1.tar.gz"
  sha256 "c65c668810db305c4454ba26a10b6d84a96b5469719fe3c729e1c6542b8d0d87"
  license "MIT"
  head "https:github.comxkbcommonlibxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "e0bd4e7de132b9dc9fe4d051e3b5e4ac1e46faa09383f98cf706f3b0f4fccbd7"
    sha256 arm64_sonoma:  "6c4e05bd7349ed1549012fceed6970fc16cb2d850fcc0918d2fc0c3807fc8d9d"
    sha256 arm64_ventura: "87add7188454d224c1eb5c7212ed1d99bfa4c27f892227a8dfab391395b39736"
    sha256 sonoma:        "13ab9316b224c237e2b430b7bed5ca098d80f3b003364e8c3a15395ba6034b85"
    sha256 ventura:       "caab4aa6d03006afd61175a910f4e16c101aab8ef021c906125cd47ab2cd7801"
    sha256 x86_64_linux:  "de292897967057f3dc9d2f5fc087ddb83e71a407a7498bb37485ed52b042c664"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libxcb"
  depends_on "xkeyboardconfig"
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