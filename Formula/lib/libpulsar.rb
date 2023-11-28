class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.4.1/apache-pulsar-client-cpp-3.4.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.4.1/apache-pulsar-client-cpp-3.4.1.tar.gz"
  sha256 "ceac72fbcf1f1b6827658020770aec25c20772ce5ec9ec36e64f07ba5b806c5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cfcde3e4b7ad0413818d4d1d5e836fba2a8b410541acc7986789231f94d0b21d"
    sha256 cellar: :any,                 arm64_ventura:  "b4be24e1393102731ed42aa7026a31566d06c4a170ebd9c7378439964cf2725e"
    sha256 cellar: :any,                 arm64_monterey: "232aed55cfb842cdf3d390a24b966c39da000349d1ddb0202bfa7bdc30eb6d42"
    sha256 cellar: :any,                 sonoma:         "d7a6ef0b4e5b9de90a9db43097c62645ff5772a8dc36c4d012ebadb00d03849a"
    sha256 cellar: :any,                 ventura:        "52cdb9807586c227658e5711b467414d741877937e77bfe328410d63aa51ab4d"
    sha256 cellar: :any,                 monterey:       "cc8d6a80d6490df8fa22ca95d45c5194dfb3351d3b049d7543401fc8731bfa31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c186bd944ef0a0e53f61fc61a6313ddb7021c053439325c86d139d4ac009539"
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