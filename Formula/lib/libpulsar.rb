class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.4.0/apache-pulsar-client-cpp-3.4.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.4.0/apache-pulsar-client-cpp-3.4.0.tar.gz"
  sha256 "b4dfb0608d1b0b11250cf4213fa223c463f71f4c8e8e068c5bf49e35bfdcc020"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d20ae44296fd773b3b4098599ecb3304a4210648f71463c87fc5f4447fe9a07b"
    sha256 cellar: :any,                 arm64_ventura:  "b9e928d65212929c2736dad78d59cbbc134782ea4cf463af48be44367959030d"
    sha256 cellar: :any,                 arm64_monterey: "def28af5026734fc7d3119226fa6257ad88df9814299e3b94324066f85adfc6d"
    sha256 cellar: :any,                 sonoma:         "bd2c63a9a532ea40bfd44a1c0f0d2d0b7d914aac6b37b07a6be0def034fcaae7"
    sha256 cellar: :any,                 ventura:        "9e151881411802beb6293363bcee1d405519915a356f960242ad41deb8e643c2"
    sha256 cellar: :any,                 monterey:       "d400bee7e6524d6ec90b81603b0a5160c8f6a3be993efc244e34895a7e0f4221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6f986ff2bc245db122f9700f129643d317b50278e474e925bfb3f6fe02a46d"
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