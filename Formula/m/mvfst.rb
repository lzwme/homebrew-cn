class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.10.02.00.tar.gz"
  sha256 "aa95d2ea11d75c221fcbd94e69b6755e6a69b908d25cd4519474933eebfe7a71"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2fb81b99a2cc6f3038a9c75c6fdaf426b8d55fcb2a1f651f71e33783e22145d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b3d5e07e5c34b8ffeb1d30ab7c2361b8da316afbe81e2adde62560eadbd86c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a66ca4596c15c3bfa9991e13bf401012aa945473442918d735635bcfaa9aeb91"
    sha256 cellar: :any_skip_relocation, sonoma:         "c89fc5bcc2a4cd4ce7b92276061a764da0a03fc4ffc62052b84018928b130447"
    sha256 cellar: :any_skip_relocation, ventura:        "54ff23a3b37ebf516ca3f834efa8e0ec6305ba315d29c04440c4343d91c09e31"
    sha256 cellar: :any_skip_relocation, monterey:       "3b780078748840af1ccd7d0033c7bc754447cf8c66ebf3e374f7256b99e66189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e9d63555c9e09158fd9068f868fc29ae37e762f5a83445a03df786cdc96aa0"
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