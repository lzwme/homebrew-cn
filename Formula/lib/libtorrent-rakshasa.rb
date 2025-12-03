class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "fdd94681b92d8a5bc6077bb54d8c6529fe8bfa700af9ec118e0292c8200dbcb3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df2e0abb9463f3eeb4b71fb4f2c568b1aab6a80d0517320ecb346ef2612d253c"
    sha256 cellar: :any,                 arm64_sequoia: "2a077459adddde59729fd5c6d39c17c67d5718d72efd14471390ebe4671e623a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc88497dad0fb41cb08cd2228eb7c52c8e0003b2762a33d48c3d1332e2331e25"
    sha256 cellar: :any,                 sonoma:        "0b518050450ae26eb103b4a73b6814dff7620acb3c050d25290ea57cc078ebdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cae30e9f03c85ba8ff3f4844dfa0b5aa743ee420d168b9af3d7775ca5c48b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5718a52ed4829255d3564c23d1a00e0ddf8599650dc5f16399433887dfcb7480"
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