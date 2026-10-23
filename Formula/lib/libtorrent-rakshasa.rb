class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.26.tar.gz"
  sha256 "f3674a26c8398c38583f62e235a69056cf4142745af11cf9f7c2a6006c23a30a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5b412de8a85e68468de8dd53e3d1fe89f8dc612f2a5232aafc6c309672a3c26d"
    sha256 cellar: :any, arm64_tahoe:       "1d8353265ace602432e8896483cb6210122be1e7049c6a437c4753c9c98e0719"
    sha256 cellar: :any, arm64_sequoia:     "3ad2ae5ef00ee9929a28bf9292d3b1ca3b12d1649fa9a2ec55bcc05b9b17d4f0"
    sha256 cellar: :any, arm64_linux:       "57cd5f4e846e299547eb38b742fe139f95fbdcaff0879e968f40e2c85f5f53a8"
    sha256 cellar: :any, x86_64_linux:      "6df10d9720b0da94cf52a39f168ca149c759264d49cd778542dac1267d1bb47b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

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
      #include <torrent/runtime/runtime.h>
      int main(void)
      {
        std::cout << torrent::runtime::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end