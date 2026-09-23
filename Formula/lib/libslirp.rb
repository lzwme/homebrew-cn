class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.9.5/libslirp-v4.9.5.tar.gz"
  sha256 "f43e68b60b580647574ec4a0e2b6c600a56281e6c39f79426510832dc810f483"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9c0233380116a46e7d292a7f0b1b3084214f399ae839806bcff0018f581da405"
    sha256 cellar: :any, arm64_tahoe:       "c6dccd35007a151895b8be9583f6c0c7d0a1fbd3801ba53e53911b7382033ce7"
    sha256 cellar: :any, arm64_sequoia:     "af14169e3c82f790b4b3982e638d6e9fb261887ff5f315d640f812604012a7b3"
    sha256 cellar: :any, arm64_linux:       "36c0ffd37761f75f6380c0f792fc392c37c5202118cbada783debf052ab05a75"
    sha256 cellar: :any, x86_64_linux:      "d811f6df841573ec7057cedea35cfb5876f4e298fc4a85f97f79751601e522b0"
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