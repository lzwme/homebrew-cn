class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.24.tar.gz"
  sha256 "626cb6e7272296e7f52fd2310744e080104cf00fe4562a1c253fe327dcfc401c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "22cb4b07823487722de273fd247871137b87da806a09ccd95056a62fe54267d3"
    sha256 cellar: :any, arm64_tahoe:       "d916d55d11f19a6aa276f4c38d3fef15fb1c640d4064c70b1a5c07fbeb246495"
    sha256 cellar: :any, arm64_sequoia:     "d66debaa4c1ae9575f59a33a6a23a5ea918098b9bb696db243c020664e73e772"
    sha256 cellar: :any, arm64_linux:       "ee2c7688f3cc68964a915a9025d3860396926fc6ac37527020ed77abe456a8f4"
    sha256 cellar: :any, x86_64_linux:      "e6151c2d3edeebafea2368c514a51da0e1d685795c984583c5b4f06b98a7e14c"
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