class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https:xkbcommon.org"
  url "https:github.comxkbcommonlibxkbcommonarchiverefstagsxkbcommon-1.8.0.tar.gz"
  sha256 "025c53032776ed850fbfb92683a703048cd70256df4ac1a1ec41ed3455d5d39c"
  license "MIT"
  head "https:github.comxkbcommonlibxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "e9cdd4c8e8b2d6e872a14558c4e07b9bdc40bf392082b52f7ded35a38bcd3d06"
    sha256 arm64_sonoma:  "978493b984e641146e8bcf175c84220ff0cb6ef5d2e33777ab8ac24f63257514"
    sha256 arm64_ventura: "676c10d4bfc42e72cec98676f6a3b853f22f1ef5ad14a32909507024b8e7f302"
    sha256 sonoma:        "009ffd4906bb6fa59055fbbc3f8d15dbaf1371a428f135ddbd952303bab3502a"
    sha256 ventura:       "8b77ba11046744f0a23906967db504a296377302d04e7e54c6b8c7c29c2adb82"
    sha256 x86_64_linux:  "f82a08d2649605f4b8793ebf680102b3905403755738fe890ffb9da53470ecee"
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