class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.9.2/libslirp-v4.9.2.tar.gz"
  sha256 "fb3c0d3db56174016c96803882378e262e5b59a7bd38feb107d915a79aad5288"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d0171cb94a4bb6fa8917fa34f7c422c895114e8a84385893d24df840741340aa"
    sha256 cellar: :any, arm64_sequoia: "6da1738bf1605f2d953dfb4f28d7803823b0c07564de8fa2614409dfb6b35def"
    sha256 cellar: :any, arm64_sonoma:  "aa31df598208831518baaa9661c95355e05eb9e24e3231c256746553cafa9b4b"
    sha256 cellar: :any, sonoma:        "7dc437eda2a79857783e6e16645b62cdec194aeb87986b9566a550a68ca3e464"
    sha256               arm64_linux:   "2135d9b0354100ce5145f64699fc1a1d4f18fd3f40940ad3c5140fa46743c7af"
    sha256               x86_64_linux:  "132fe1faad6351ee23dbdc2a2041c729599ab222854fed3c698587aef2cfcba9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  def install
    system "meson", "setup", "build", "-Ddefault_library=both", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <stddef.h>
      #include <slirp/libslirp.h>
      int main() {
        SlirpConfig cfg;
        memset(&cfg, 0, sizeof(cfg));
        cfg.version = 1;
        cfg.in_enabled = true;
        cfg.vhostname = "testServer";
        Slirp* ctx = slirp_new(&cfg, NULL, NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lslirp", "-o", "test"
    system "./test"
  end
end