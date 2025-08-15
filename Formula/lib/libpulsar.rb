class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  sha256 "e4eee34cfa3d5838c08f20ac70f5b28239cb137bb59c75199f809141070620dd"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "080993ea0c4f59d5ebb6a4c1d5a18f8266f558cbd5315b7a8556659e89f27d50"
    sha256 cellar: :any,                 arm64_sonoma:  "371875a22cd56bb7bd1554641acd73cc27ce667c6f1bda10570cba6ca2d317bf"
    sha256 cellar: :any,                 arm64_ventura: "1601e945c536d8a53afa86ad2ee29710f9d477c790b3a2dc768d36042d32c3d6"
    sha256 cellar: :any,                 sonoma:        "197b8ff5a595f98ad735fc3622a702d42512c8e46dd0fb688711c69a7a40a07b"
    sha256 cellar: :any,                 ventura:       "9c6d2f850d2204ea25f0e35ed0c6f53488d2068cdd7e33cb121eb9873a9c062b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "886699c29db597b3c2ffedb2d3f72421eab1bc09611cfbb67f2dbf1ff3750c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e762bc7124b3b1fbaecf582eced07298f206f94c4e38b54c22d6c21dacfc9a2"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "abseil"
  depends_on "openssl@3"
  depends_on "protobuf@29"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Backport of https://github.com/apache/pulsar-client-cpp/pull/477
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/93a4bb54004417c3742ca0e41183c662d9f417f5/libpulsar/asio.patch"
    sha256 "519ecb20d3721575a916f45e7e0d382ae61de38ceaee23b53b97c7b4fcdbc019"
  end

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end