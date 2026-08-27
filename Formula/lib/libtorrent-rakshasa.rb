class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.21.tar.gz"
  sha256 "21f41cd378ff142743f55e4f45863f9269b642e347ff37e3165de21af3dc5370"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4f39775e1d55223a4df2293a2da5eecfae163993c4a7c1cdc1c1f7bc7050e83"
    sha256 cellar: :any, arm64_sequoia: "77f681a4d823bbf99acae4db3d96605600082361f6f1611e330390c744ad7ec9"
    sha256 cellar: :any, arm64_sonoma:  "f73651b3d88201265b4f6e423cd5d55b5f7375eb766e5c79d1f4dbaa2179806a"
    sha256 cellar: :any, sonoma:        "b3bd8ffece06e0b8784b31f3eee5edf2ff30885a761f907598f6be0d946dbf02"
    sha256 cellar: :any, arm64_linux:   "6338b1f806f2a68617384d6b401ed95c324d2991489ab8e5800be1862d56cc71"
    sha256 cellar: :any, x86_64_linux:  "baeaa3ca8a0bcb2d0eb51aa5c4bd42fc74e9f453c2da745685f90952eae01d05"
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