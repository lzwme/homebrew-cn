class Tinyframe < Formula
  desc "Minimalistic library for reading and writing the Frame Streams protocol"
  homepage "https://codeberg.org/DNS-OARC/tinyframe"
  url "https://www.dns-oarc.net/files/tinyframe/tinyframe-0.1.1.tar.gz"
  sha256 "f3e3aeb9d19360252eff7832978fc0beac5d7a8f99e04677d3cba145861cff0a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b2b73c5796c1e74935e6e4f19f6ece4d79ee1bd8e72e71af38c4aec8dc78a066"
    sha256 cellar: :any, arm64_tahoe:       "16a2a5ee6cef2927fb12e98d50ebc86a50376af2c9791136d6689e458b60c84b"
    sha256 cellar: :any, arm64_sequoia:     "606f46ff08f594d86c4d92ce289510666bb6bb9f6123b1b7fec0a27c7c2ea57d"
    sha256 cellar: :any, arm64_linux:       "aefd1c4cd7d0f71798afbd146503fb24c50be53c89d595ab648a04cbee75a371"
    sha256 cellar: :any, x86_64_linux:      "26a39db1c068f4c417189f1af1b5e8e8a866e00d901bf2f9f32098a31655325b"
  end

  depends_on "pkgconf" => :test

  patch do
    on_macos do
      url "https://codeberg.org/smillernl/tinyframe/commit/c425d6c35edd05e3313baa5e5c87ef3b6e787118.patch"
      sha256 "8db7615be41f35cd9232d2039454c56118d2f904cd1eef5443a8a3b21a8a4926"
    end
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tinyframe/version.h>
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("Version %s", TINYFRAME_VERSION_STRING);
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs libtinyframe").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_match version.to_s, shell_output("./test")
  end
end