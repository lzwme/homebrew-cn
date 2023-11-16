class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.11.13.00.tar.gz"
  sha256 "d295360febdaeb887a8e7598bde4e4f223122d9cc69225803a40acca798a5627"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "970fac75b3371a46af89de75eeea0237d3ed6ca249f844402161c1a39a170b1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a07032dee9ba119607792dfe8789d9d0c469883f3f80d2154910298fcd057278"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af41c60b0448b11844f88e3dbf60278ab82e692f03f7c891b0d4aa68525090c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c39e2988d1a838f83eeb266b69662baaf9d04a7d02d3515ba43a1e71ba965a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "8e5b5f1df3bdf6fcf8f09a89f20d9873a8fc4fee98d19b95340a6160eade3c37"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d286efc1c1c7129eee0dff26186d4cccf730ee4cc643348efd0c5eaf288fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc75010bdb044197718c54e462460914dbeab230fcf3f30591af7b6afe5c199e"
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