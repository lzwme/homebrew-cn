class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://ghproxy.com/https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "f369fa5380320f2b9431efa8aa3ec006991215b2b8af4a945a5b1690cc4ee460"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5580dc4ad82929b304a32a2e10387261ee9185e3d207cbc3191c3483253e8d5b"
    sha256 cellar: :any,                 arm64_monterey: "a41aba08bedd5c141739c96eb2c5e69c389226762345fc66988e6e3bc22ae7b1"
    sha256 cellar: :any,                 arm64_big_sur:  "14891a38e059bd8ed7b685d0bfce720bc323fcb1cd0dfeffa0f6dd97ba62c067"
    sha256 cellar: :any,                 ventura:        "7534beb9ee623d4a5b275fa19dbef6124e68b1c4e23ef97a16f6b05f048a087f"
    sha256 cellar: :any,                 monterey:       "500d565cca0ca89cd2a10578ecf1e35a9e05688886ffdfbb2627862f2b1d0d3d"
    sha256 cellar: :any,                 big_sur:        "b8ee7d44fd52a36864b3e64c62e0136f37d68265935a77cd71ff172bcfd3fb80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c62a1238439c5e245cb4a7dc85ee1d43468d30c5a0c3ee959092cbaf95db21"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "gnutls"
  depends_on "msgpack-cxx"
  depends_on "nettle"
  depends_on "readline"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENDHT_C=ON",
                    "-DOPENDHT_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opendht.h>
      int main() {
        dht::DhtRunner node;

        // Launch a dht node on a new thread, using a
        // generated RSA key pair, and listen on port 4222.
        node.run(4222, dht::crypto::generateIdentity(), true);
        node.join();

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end