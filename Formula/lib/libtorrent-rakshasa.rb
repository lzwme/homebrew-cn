class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://ghfast.top/https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.14.tar.gz"
  sha256 "a2ef0a1b4bff5e30c3cbfd4eac3bee5d85817af08d116c9f2982278c8e0540a5"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9195c6a19098e924984883febe8e40f7bd70ef520eae7aaea85d88327080235f"
    sha256 cellar: :any, arm64_sequoia: "82ddd2aa916c7578ec034fa36ed007528bbe799321598d1a13956dc85b2d2e80"
    sha256 cellar: :any, arm64_sonoma:  "875521c407b171a4aef028c8b40573680b48627164011c430621b4f43cca3b7c"
    sha256 cellar: :any, sonoma:        "f9ef25b907191f441371d385063220499f74f58ca6eb9b7defd428e1dfeea417"
    sha256 cellar: :any, arm64_linux:   "c9a8e15eefcbe495c9c24d749dcd6e6a44081d49fb640ea3af5d52d45f37b390"
    sha256 cellar: :any, x86_64_linux:  "772f30e1aebd86fe1744897d28eadc03d282d3175c846c8a860688cf9c77b9f8"
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