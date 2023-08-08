class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.08.07.00.tar.gz"
  sha256 "d37a92ad59766ced085d5dca2ae5ba9667043c9f748cd1119b55e5928e1de9d6"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32996d4e4ffe56f2ef18e091df2c296b0d31c70271e1253bde0837eb52e1f6c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4a0ed0aa3285fca6e9438953e71ce8e34274af0cca4a5331fa146900d9e5a97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b20000f62bb38cae843603a9e3436adff2be688adfa395e5a0fee145c448242a"
    sha256 cellar: :any_skip_relocation, ventura:        "2627b756ffbf3f08a513866c325ca05b27ff1269b5e177709a12e97f62a9cac3"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd3876dfea53a9ce50d1bce07a37fb4160756f2f292d45a05902b2b8ad28abd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f2300a87f45bb509e61deac26eaa8de680dab1d4f26b0b56b01d8e82028745f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b5d343a58547033865f24dd6a0f7d1e783271de121d7f0c470b213de40858b"
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