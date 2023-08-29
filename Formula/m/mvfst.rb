class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.08.28.00.tar.gz"
  sha256 "705a8653c475733dcd9ed9b70e446e5c59668b21c248e30d6af4f190020a3f3f"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec894eff4d6e1c497971de858f50f675c8cdcb69b8ed902e5cd24785efb55578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f816c9b8d76590d5dbc2cbe004000da33450797fa277db55bc652fc6ea01d70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37d79c2a865385bcee2fad83d6a7e5a9117383529a1d8ba94c868d1a40d3e59e"
    sha256 cellar: :any_skip_relocation, ventura:        "407d1301167b9c9c170ae72b7eb84663c2ba0eb3a9490812490943b855f01d0a"
    sha256 cellar: :any_skip_relocation, monterey:       "c64616afe13ba99a753e1214eef85d93432149c6ff41163288ecc37a3228c6a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd7e3b773789828219039eba10b43605324b87650ed2ed1a507385ac76e724e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c938409bbb492f675267c6515a480636bca49b73575e5cdca1113460bb8ab68"
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