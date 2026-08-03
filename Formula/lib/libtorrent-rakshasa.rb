class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.19.tar.gz"
  sha256 "dfab08fa7e5ec2865b36c5868c6136ffe125c868d2763d7097bb85b20652e345"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "582d34b1613fc2ce7eff13229175d6abf963edbbe61c43e963ddbc90dafa3b5c"
    sha256 cellar: :any, arm64_sequoia: "0eebf38026e13123060a931dfa218ca68e52e9db9c0ed884003acb67755d4268"
    sha256 cellar: :any, arm64_sonoma:  "d7d0fc68de4133414e1cf5091a0e25aa3bffa7f666125684e1da15ad0474b03b"
    sha256 cellar: :any, sonoma:        "ba4ec9b4f41d4cc8d2cfd1c50045a73e9bb10260764fc4ceb7f942f5524c6f82"
    sha256 cellar: :any, arm64_linux:   "22557502a74dc74b0f9c81fab6e9451f7a20ba72750c17ecc737ad71480a3a99"
    sha256 cellar: :any, x86_64_linux:  "60eff16891bfb93ee1246e157cfb4b3e8dbfd3464a3703a6c6e522c0f0b64ab0"
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