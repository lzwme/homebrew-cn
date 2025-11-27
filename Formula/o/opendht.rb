class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://ghfast.top/https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "76d88164a71e56be4d49a377475242f5e3b999c76beb68293d22c2b68f1bd827"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d23979db7272632a86a24e635a3178e427b22f68c53421a5b86127f019e2572"
    sha256 cellar: :any,                 arm64_sequoia: "cf59c78e4bc871a0069789408ba6f9f7265af46e08a8410c4d6c66f756072c3f"
    sha256 cellar: :any,                 arm64_sonoma:  "da296cec4e5407c92ec14ef5c19bb21d84dc3a507857fbc2d726c78009ff08b5"
    sha256 cellar: :any,                 sonoma:        "965b1063ef809e583482af7976d787902b463a3a112cad025332c5fdfbd01eac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fd1316cdabce280162bf8626e158e7ff4b2d4399713e225d9556c61fc1f48cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7e1af5c0b4a847b40c6c61e54f8cc8f8182a1d84b77f7526d1b97ec5d50a26"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "fmt"
  depends_on "gnutls"
  depends_on "msgpack-cxx"
  depends_on "nettle"
  depends_on "readline"

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
    (testpath/"test.cpp").write <<~CPP
      #include <opendht.h>
      int main() {
        dht::DhtRunner node;

        // Launch a dht node on a new thread, using a
        // generated RSA key pair, and listen on port 4222.
        node.run(4222, dht::crypto::generateIdentity(), true);
        node.join();

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end