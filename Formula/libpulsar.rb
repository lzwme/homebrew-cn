class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  sha256 "e1d007d140906e4e7fc2b47414d551f3c7024bd9d35c8be1bbde3078dc2bddbc"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "90526241d41eff910253ed0f240b05a7da8d60824ebbbd9a0988e3cd8583a33e"
    sha256 cellar: :any,                 arm64_monterey: "c759b8c1ccd18ce4f800408d6ae2b421c22de79e435f38770ec1ab0987902331"
    sha256 cellar: :any,                 arm64_big_sur:  "d5c782656fe87b6fe8d70616f757574f47e3a73f4f4071ca31187d41114b1ee2"
    sha256 cellar: :any,                 ventura:        "103123de1c8aa504d301ccc6010ee6d631abddf59e0c0ef0e82701eae829e122"
    sha256 cellar: :any,                 monterey:       "5dbd1f11db66d58bb2fcc283e84eef283cc2bf6b4db7c179e7f80cfc588db3e2"
    sha256 cellar: :any,                 big_sur:        "bb0e5135f5ae7fa24e93268d30640a50eab1966276fa44f3db3e24c9db46faca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f28629d8cd9580b745623e4d6055a746c4e3eef55664e54c64bbfeb15846349"
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
    # Needed for `protobuf`, which depends on `abseil`.
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD 17"
    system "cmake", "-S", ".", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON", # protocolbuffers/protobuf#12292
                    "-Dprotobuf_MODULE_COMPATIBLE=ON", # protocolbuffers/protobuf#1931
                    "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                    "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                    "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib/shared_library("libprotobuf")}",
                    *std_cmake_args
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