class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  sha256 "522ca67bc911fcd4c0c9e4278628c9167b614a887c63fb04b04370156254d3b3"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "acb18afe36302ed87cedd1527f8fd8136041ef6a6c739543c844869ec8c19c30"
    sha256 cellar: :any,                 arm64_sonoma:  "02b2efb614507e949025a6cd790dc59e6d037ae4fb845d9bc519b560f6bb4db9"
    sha256 cellar: :any,                 arm64_ventura: "dd04c9f7a04707d1bd3edf31be9585b447e30798138a15afc2d87ed47c4f5b16"
    sha256 cellar: :any,                 sonoma:        "d7f71129697cf7127d45324074eeac2dc07f60dff7985e876046cc6aeab4124f"
    sha256 cellar: :any,                 ventura:       "46473d2024cb838f50c0ed3ce58d50849ec0840a0171189eb13c8f7f250c73ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5498a1d28d3e2f99b51056e2a88dd8289aee8b961b88cf182abe8b4cc434c250"
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