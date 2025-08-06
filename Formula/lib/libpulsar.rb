class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  sha256 "e4eee34cfa3d5838c08f20ac70f5b28239cb137bb59c75199f809141070620dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a45ef331ab3ba08002332e340aeb0c1aea3f4b2463815a4a0423fedaa7e5554b"
    sha256 cellar: :any,                 arm64_sonoma:  "1575519667526ab1cc14a4d4c38447ac12342884c06396897be2a31d2a44f3ff"
    sha256 cellar: :any,                 arm64_ventura: "77361fedffdd111e6417f6123ba9365b9cf5e39050523f94ea915a3159f175b0"
    sha256 cellar: :any,                 sonoma:        "b9a50db3df086b014ca95c2488751517c4afc22ab61e04c55c1c12e8fa3311e6"
    sha256 cellar: :any,                 ventura:       "c9260119842a8ed7cd4857d32aaece69f9f11eae9595fd023159ae8d88953bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97b4db1a95c7f7288db2f33ddd9e2fcce573fb0d30b5a49ca822776b72a03c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb9b0f03c645727f796c138dd2b0666bdbe097e77ad55e14cc6ad0f5633b7189"
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