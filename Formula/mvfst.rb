class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.07.24.00.tar.gz"
  sha256 "ec841fb5da4fc701b52c17f2abba24827e8f9a2682ec755bd8a1f226fb1e78d1"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02c7e86c08be10da84abba8c04bcc8c2d8f018cf45c1ead24543915bb4935878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f4608c0a161c7981e2195994656e8709c372f014b76e5bc1e17d7da473792e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "465aaf093ee6cabed1c1a310147faa0e2efb1c4b2d8327791999e731e10c22d0"
    sha256 cellar: :any_skip_relocation, ventura:        "552638bc9073418a72b3c9e71c776fd54085357f5af8702a28e77a44375ab14f"
    sha256 cellar: :any_skip_relocation, monterey:       "fe1a7645d3b095ba6d8776fb11414d85d8aa1861b6876ad5cffd3d75a9e5e108"
    sha256 cellar: :any_skip_relocation, big_sur:        "317739e5c47a529498cda0acbfdcc10cf1f52f37ec87caf38a09b81867ae2a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc16531bfefb839055b7d8abc0cb9a53df6bcd14fadbbb296068e40054807ebc"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "_build",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    ENV.delete "CPATH"
    stable.stage testpath

    (testpath/"CMakeLists.txt").atomic_write <<~CMAKE
      cmake_minimum_required(VERSION 3.20)
      project(echo CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
      find_package(fizz REQUIRED)
      find_package(gflags REQUIRED)
      find_package(GTest REQUIRED)
      find_package(mvfst REQUIRED)

      add_executable(echo
        quic/samples/echo/main.cpp
        quic/common/test/TestUtils.cpp
        quic/common/test/TestPacketBuilders.cpp
      )
      target_link_libraries(echo ${mvfst_LIBRARIES} fizz::fizz_test_support GTest::gmock)
      target_include_directories(echo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    CMAKE

    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."

    server_port = free_port
    server_pid = spawn "./echo", "--mode", "server",
                                 "--host", "127.0.0.1", "--port", server_port.to_s
    sleep 5

    Open3.popen3(
      "./echo", "--mode", "client",
                "--host", "127.0.0.1", "--port", server_port.to_s
    ) do |stdin, _, stderr|
      stdin.write "Hello world!\n"
      Timeout.timeout(15) do
        stderr.each do |line|
          break if line.include? "Client received data=echo Hello world!"
        end
      end
      stdin.close
    end
  ensure
    Process.kill "TERM", server_pid
  end
end