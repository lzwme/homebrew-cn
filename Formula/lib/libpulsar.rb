class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  sha256 "d24990757319dfa9c9e5d3263f60105dd9e12ddeaf1396d6b397f87dab2fd7d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a08b3483b74be83bc5ccecb061825df782d4f034e39c9fb4cb7c57a6d9a6a1c9"
    sha256 cellar: :any,                 arm64_ventura:  "21515bff2543c94ae83043cbc4aa8ad0a81adf27cd5a48a0dfb89e42c0e4f94b"
    sha256 cellar: :any,                 arm64_monterey: "f683513f15b32eddcabc1f7189f996d2e1b529eba88b9d852f765c323754ae6a"
    sha256 cellar: :any,                 sonoma:         "9de9907d629344d85aea0db2dc90eed47bab34fe7562a4e6e60d8b760db88b20"
    sha256 cellar: :any,                 ventura:        "2dfbdae8e6b3130179a2306025006d37bab8899906544abbb0da1522cc1a65d1"
    sha256 cellar: :any,                 monterey:       "dd274f1f6042234cbbe75b40c2f6dded59d38ffdc8e8737a38c26bf93cf1f07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3447063797b661017795f2a6bc02af991e687614234a0ad864870b5808f83ddc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON # protocolbuffers/protobuf#12292
      -Dprotobuf_MODULE_COMPATIBLE=ON # protocolbuffers/protobuf#1931
      -DCMAKE_CXX_STANDARD=17
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end