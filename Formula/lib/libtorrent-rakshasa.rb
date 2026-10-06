class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.25.tar.gz"
  sha256 "c0390ef3454e9456aadb21f704eac6ef659bccc2b3ceb8215f59f1ef30735a14"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f83860fe2d7ac4330fecd024c92b16b4499b1a116c37983cd91ee18fcd3f50f2"
    sha256 cellar: :any, arm64_tahoe:       "76fb4342ddafa6f21546db06d983b8eaf2ee501b344602df27b7f610e5d55baa"
    sha256 cellar: :any, arm64_sequoia:     "188a2ae6c2d1ee16b23342dcc8bd4ebd1cc45b06223bd63eead5156e26ddb04c"
    sha256 cellar: :any, arm64_linux:       "3c04e71156e22c0cff79c1469816532be707c3f3b52fc138b81b318814f0a3e7"
    sha256 cellar: :any, x86_64_linux:      "04793c568e46b30f4b1b70d93c7f672414ddc1d5507bb0a3313438eb75f364d1"
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