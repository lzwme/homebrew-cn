class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "11cd86305fb6de4b14da928c36aa93a67f6360b3bb61224d6ab7cd67aaa7148b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6623f58af047f1e04e7c29180bfc8ae5781a2f2e0c9df534d02381d7d79d87ba"
    sha256 cellar: :any,                 arm64_sequoia: "19532c1afa59f2370777241b8e9b315985d5bc48128924cafd361faa20b78c3c"
    sha256 cellar: :any,                 arm64_sonoma:  "1484851815baa218565061e8c73eeea335b8b2cbe3b83e92766463ac427a2b13"
    sha256 cellar: :any,                 sonoma:        "6bb193347b30778d9eb4d5a41f16dfdfdbc546e4d8313bbe8733960e80073e84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b31f25996e3ed02957c8172d1f53bd03c20c6cf3e47c547c474256fb0904d62b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4542ef23c4e4f0339630f67699b64a1738842f9b795af5f9d2e4f8e46c89e3e6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>#{"  "}
      #include <torrent/torrent.h>
      int main(void)
      {
        std::cout << torrent::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end