class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "e96ec8d0ef07e0ce32bc6e9a280ef3511a3781b9f5a9a3fe34e6c4935c16b646"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92adc8acfc2869ff724ecde7079ab4e8c97d430f081b8f256792761205016e83"
    sha256 cellar: :any,                 arm64_sonoma:  "0b4e8351f20a19cc03562ed956aa5f7ac2a24c185580588272fc5e0d96624513"
    sha256 cellar: :any,                 arm64_ventura: "743fa97525ac3b73dd8bb1eec1f4237d9ec5d6b530bfff8de3c89c4cc52d033d"
    sha256 cellar: :any,                 sonoma:        "b63dfdbf9ec2e21980d5ff2509b3663eff6ddd6f2694fcb3440df813e0ac5188"
    sha256 cellar: :any,                 ventura:       "2e6bcf021853e82fe7ce8d6badc06daefe878c161a3605acedc3c2c722a6b83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cd4fe0945d62276bcb782603cb921f3b068853ee783a1d2ae994efe16d7de4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef82708e32d8f9f501499280d492f94e99bd78c02165b9073aed5ffa4b6bfa6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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