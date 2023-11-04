class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  sha256 "0e04c67d7b644a92081eb6993ebd1579e05080c1fff651728dfa04b054e637bf"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aa1d893b5e754c6481a04abad5edeb456b8175e1d9ef52a82b6e6a2a52ef50cc"
    sha256 cellar: :any,                 arm64_ventura:  "7ffae0d6d174779a371b19bffc883d2c32f593c79c473e123a1b27a15f88e487"
    sha256 cellar: :any,                 arm64_monterey: "cd2315a88b977eea60f30bab86e7173d20d3ed6b61b896f465c9b4110f65db31"
    sha256 cellar: :any,                 sonoma:         "355bef364ab476fd2cd34f9281216a0d3ab83b243baebf90807c6c65847c099b"
    sha256 cellar: :any,                 ventura:        "1de8a706f646d9d851a3f28fa0a990606fa873a82e83c28648728368875e6c94"
    sha256 cellar: :any,                 monterey:       "a12f9035b44acfcfc8b6b76e0b5c455e594c331e065d3e97b4e772a32b9e4ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "465e5ebe35eb37058e63fb9464552acd1fb00369a7e588050b9d56efa3f8a754"
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