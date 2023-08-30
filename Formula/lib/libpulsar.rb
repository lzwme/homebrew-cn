class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  sha256 "0e04c67d7b644a92081eb6993ebd1579e05080c1fff651728dfa04b054e637bf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8229566c45ac5c509c72834338f50eb5a97168173076806c7358a89378a2f038"
    sha256 cellar: :any,                 arm64_monterey: "f8b05e4dc0445477e78cb9fa4bac94f7d23487e82c1ec68214306a349860e6ce"
    sha256 cellar: :any,                 arm64_big_sur:  "ac9f1d9af3a4ab9ff83f990ef1c7928bd7bcdb0e8cf737a0f1b7ec8bf20aebb7"
    sha256 cellar: :any,                 ventura:        "3163588eac0d48b5a107774f9a48c9472d1679da50c14034be21c342d1defc0a"
    sha256 cellar: :any,                 monterey:       "d994b8e9149329553cbe142bdbbeb194cf4d336dc1cff7e5b4a78422e79906ae"
    sha256 cellar: :any,                 big_sur:        "545df93525f0dd465f6b63349b3ef4ad72d1f04a94f1cac2c291ced7c89ca749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e6cdb5d4f5a0ff2635041dfd8e3261e7312d570d9d3882f9c8f7e9fcffeada"
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