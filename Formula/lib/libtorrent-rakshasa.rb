class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "68391b28a55cb039eb385a20cc9333ade0646bea4d13c05e2b40c080d33c7505"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae0771129005a0bbf084187d05c469d147316b4718b8c101f03c0752abf39e1c"
    sha256 cellar: :any,                 arm64_sequoia: "e91a14a3a1eddf59272e6dd3085942728d98eb39af80e4b5f0731b713597c4fe"
    sha256 cellar: :any,                 arm64_sonoma:  "90d91b3d5165b623bee6bb1f56dd696b66a651be5b9619878698cb456336b595"
    sha256 cellar: :any,                 sonoma:        "2aaf34648bf8c0b6352516c88c08a23b474a4ef0f7299b33430d57227ac29f7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "324fb7f349055b2699b6f9880da2105c150883a00ff883e9acefe0de4af8850b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203059f9361d69a2b31ddbfbb91f2421eacd8a21d465a943dbb433475ba4b278"
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