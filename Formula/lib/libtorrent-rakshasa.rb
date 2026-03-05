class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.7.tar.gz"
  sha256 "621bdf0036d4ad9a2beaf30c0ae0fdb0b3b44e5240e5c99ee4cfb93c8b18b906"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "389d700ee0cbd9994b41794a63f8895cffd3c68889a1589d8914e620b56db526"
    sha256 cellar: :any,                 arm64_sequoia: "78a0f68edb57cfe5109bc72e653082222892292a517734defd6ba4197fe14aee"
    sha256 cellar: :any,                 arm64_sonoma:  "2878490a0456f461def92f6aad0176edad8d99ac4b325dd8171d200feaca5a87"
    sha256 cellar: :any,                 sonoma:        "e69ddf97106d81f85926aa3ce2c570d8d27b149baec0ff29a54b7b580f92f14c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f68dbe1d18c450f714b6cfa27b2afb7ada922c0a7a8ea495b804799ba4b8e423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9b33ac40ba506dfc3e1a3d9dae667fc9a74e8718a4388f4c6e47528bf07942"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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