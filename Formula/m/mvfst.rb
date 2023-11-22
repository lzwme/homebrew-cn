class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.11.20.00.tar.gz"
  sha256 "483f2002f34189c3de1ec0931bfdf12bbc5aa0d9d56c02e646e33d453036ce64"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b50b517969050ce3553e408b88daef2db61a079711198869745164d3bde1ae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "411e07d5ae6d728196343258d9c735184f65e6c8e06e7d5e33f7b6e099454668"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bee1b446a7cc4ebd5142dc3484151a53598c9dd023172018eeee2c3c26b2fcef"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b63b57b85d5d63b8223417923598eb85886b0441f16669992c419b0e40a42c3"
    sha256 cellar: :any_skip_relocation, ventura:        "4b35af05dc7b96d3104c694e1c5272f073396e3845a6be7205899af729f66db1"
    sha256 cellar: :any_skip_relocation, monterey:       "da8558e9c67d39270b8f1b22d3428dadcd70172e16318545f7537511d550d494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea3fa33702e76cbb5b13f5f8a2492401dfaf612833fb19ae57041b97d3017c0"
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