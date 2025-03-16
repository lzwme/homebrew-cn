class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.0/apache-pulsar-client-cpp-3.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.0/apache-pulsar-client-cpp-3.7.0.tar.gz"
  sha256 "3223cfeda484ab7b580f4a8768b5a85739cc064005c765c06cde67c3238639c9"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e937ba8b9230a840dff62707c799e478720b9d4a01b96c0cf112c4185df95bb3"
    sha256 cellar: :any,                 arm64_sonoma:  "90212ffaaa73f7c17c8fe95d67686bb3533285869df4adef757598ec8863f634"
    sha256 cellar: :any,                 arm64_ventura: "7fa9b18338c6c0c89222cb85750cd42eca9af31bc8e3198125e63beedf570457"
    sha256 cellar: :any,                 sonoma:        "6707b7473cdcd2d99a4175f22f944957b2bb7017761105eb6399edecb90d472c"
    sha256 cellar: :any,                 ventura:       "eef1c13ae3c8c21c5cb4979f65f0744061295215b33a267ae59ffa83db95901f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f05721483717a63f13231d9009470d6354ba662ad8780dcf8662487dd3fd4f"
  end

  depends_on "asio" => :build # FIXME: Not compatible with Boost.Asio 1.87+
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

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=ON
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end