class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  sha256 "d24990757319dfa9c9e5d3263f60105dd9e12ddeaf1396d6b397f87dab2fd7d1"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0c5ef204fdc54e838c6ee779115afc39d107c02440d3e8f72d083d5a31c50d7c"
    sha256 cellar: :any,                 arm64_ventura:  "306fd27fff16defcd154917c64bbb83b9c7c72ae48542759aad7d7976c90afa4"
    sha256 cellar: :any,                 arm64_monterey: "b7c27b1bd79506e649566304bb41e8cef2cc05804b33a5496c4d9c6c13cefa2d"
    sha256 cellar: :any,                 sonoma:         "f8e8eeab829650977ff6b82cfc3c5746670afea53800974884d7de9410a5b317"
    sha256 cellar: :any,                 ventura:        "b72590a3d670864533b7369a1cc09326b9f94374faf1a273cc2f1213614c44d3"
    sha256 cellar: :any,                 monterey:       "958decd7095ac57a5ed4a1af095f496a66a9bc87eac980e8f394a907bec3793c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27e46b763bf60838cb9fcdd8e53fd5097d5bc657b5bfa9a2ded1f008dfb7f28e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "abseil"
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
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