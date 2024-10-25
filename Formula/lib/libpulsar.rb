class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  sha256 "522ca67bc911fcd4c0c9e4278628c9167b614a887c63fb04b04370156254d3b3"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29e1d2754eefb335d901ab5878f07113fb473de3e80c440dd30cabd9c3e46c0b"
    sha256 cellar: :any,                 arm64_sonoma:  "ed30f70676852c031d57e4aa014ef8f4b5f0d68eaa82956fbeeee8e3cd78c743"
    sha256 cellar: :any,                 arm64_ventura: "56ba5abcb1a5004e8388f45001c6881a008fac8d5065aecc06fc2df39e2cef09"
    sha256 cellar: :any,                 sonoma:        "7065abc593ef929783442ba62b3616eda4e4c546f2238366c5ac0860430aa2f6"
    sha256 cellar: :any,                 ventura:       "a78aaafae59aa21c03a56feab640f5b8179b221a068fd0cbb8cda07ba1a3f5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e988998856c14cee75a14a6a8d77baade48238a306d1072df5bf807bb35a048"
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