class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.16.tar.gz"
  sha256 "7aeaf23b32be6f209228f7e277c4195237ff2264a3779fd8d42f7e3035d30d7a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4b6b0eb6421461eb51b9862ecf0fdfaad5a4e289792baec3c96fe0de7ae76bc3"
    sha256 cellar: :any, arm64_sequoia: "04e644773aa41c4f6af914821042905a01a59b4e19baa05a8bfd1f79cd43f860"
    sha256 cellar: :any, arm64_sonoma:  "39e6fc9abdb0928cdad8ecd4bd7c147b9e836919b61a00c0d973fa4399428808"
    sha256 cellar: :any, sonoma:        "7e62936ceb586e14612f85b88b5e422832d6a619f1f72ce99fcfdab49163c714"
    sha256 cellar: :any, arm64_linux:   "7901e37bb2ba2e4cf47a35f8899ef62d765fe21976cb5d60774363a5fd36b51e"
    sha256 cellar: :any, x86_64_linux:  "6c5fe605569a38819ec9d6c4f7e950778c2c5e87c20a77a25fa38e33a8a30972"
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