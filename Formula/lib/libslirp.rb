class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.9.6/libslirp-v4.9.6.tar.gz"
  sha256 "5bb4d30fd74042c23b4a0475f44d974a8e41dfdcf005476f03754bebc756b760"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5d5aabafb634462c74182021e310213fc3e7ae40b287f2eb0d4667111d73cb38"
    sha256 cellar: :any, arm64_tahoe:       "fb032abd6812b5607ceea8dd676cfb07562370b8a5561e0d157fa950f25fd59c"
    sha256 cellar: :any, arm64_sequoia:     "1568e321fd2f24157b558a91cc7691a1e8f6f8042a4bf4ba199d7aafecef5341"
    sha256 cellar: :any, arm64_linux:       "5bb3af0d883eed2fac21d6e626c67eefda2521fbad4a46f1be1fee1134254d31"
    sha256 cellar: :any, x86_64_linux:      "9ab723e55252141f1d2d3b366f9e64a07648162c6d9bb9253faa05348d706b7d"
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