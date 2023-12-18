class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https:xkbcommon.org"
  url "https:xkbcommon.orgdownloadlibxkbcommon-1.5.0.tar.xz"
  sha256 "560f11c4bbbca10f495f3ef7d3a6aa4ca62b4f8fb0b52e7d459d18a26e46e017"
  license "MIT"
  head "https:github.comxkbcommonlibxkbcommon.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?libxkbcommon[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "0240d70dc4af95827e15bf465f872fa3aac154dead173d14fd2cf5a3baeddf0d"
    sha256 arm64_ventura:  "8c6dc851dd48dd2df4a196a3dbc202451413ba45f5da1fa0e05bf5268e345209"
    sha256 arm64_monterey: "ae52bafef77ecad4edaaf4759fb8218af53468e9dc83ee65b43757d6aca14cef"
    sha256 arm64_big_sur:  "c1f908bc8515a3d84766bba989987ab29137e9d4b1d8d5854d6838dc9d41ec23"
    sha256 sonoma:         "fc7be887a5db40ed7c928b4b8e117dc619ee690f4d061e81193d201491fbc27f"
    sha256 ventura:        "043e964946f9f65d27e06628c9a7c61358211b98873c17930eaa36fb92e0fa70"
    sha256 monterey:       "2751b4fb16b67d57e71f8ec4b966306be8a856a3f786466057cb37cfdf03804c"
    sha256 big_sur:        "98e602696ef7cf0b7c42615f8424341ced5d265478a1c3ee7dbda237e83dcb1c"
    sha256 x86_64_linux:   "d7acfa362e20a3bc5123b5b8631c92ef84b84663d5fdf8f2edd04d330f5f384e"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "xkeyboardconfig"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -Denable-wayland=false
      -Denable-docs=false
      -Dxkb-config-root=#{HOMEBREW_PREFIX}shareX11xkb
      -Dx-locale-root=#{HOMEBREW_PREFIX}shareX11locale
    ]
    system "meson", *std_meson_args, "build", *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdlib.h>
      #include <xkbcommonxkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system ".test"
  end
end