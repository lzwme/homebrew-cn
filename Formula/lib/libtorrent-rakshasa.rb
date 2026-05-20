class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.12.tar.gz"
  sha256 "1ecbb5d7802e18e807d3c2f58499e5c189ef81badb2c6c6ebb2399d49c08f5c1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "322dc369edcb2a7db8ee93829be2540da2ff2ed858f293f1086092246ed7c81b"
    sha256 cellar: :any,                 arm64_sequoia: "0184a929e5f33241ef8dd26ba9d74dc342ee34ee15e2c2dbda209e828aedb0b3"
    sha256 cellar: :any,                 arm64_sonoma:  "e35ee361808f450ffb7eb9ab01a45799fca167e0703284169e8ca7e97d002c89"
    sha256 cellar: :any,                 sonoma:        "2f3ad006fcd9e589a4ee80e5e360d4226b355b8c2814e0c3f2b1d1c44019dc70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175b8eee892ee20c3c3b26474f576431788bd92c70eefded5aa1fa537230f51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c4c9608644dc8d7de8b49930de7a0ad7d9054fc7ce43eb8d9d9e184de0f541"
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