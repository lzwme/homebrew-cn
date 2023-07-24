class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  # TODO: Upstream has no tags yet. They will next week. Use the tag instead of a commit hash then.
  #       https://github.com/facebookincubator/mvfst/issues/301
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/403b412e57a00f79f3c36f3dbbf2aaf9fc9baa4b.tar.gz"
  version "2023.07.17.00"
  sha256 "de3e68e3081f5d56fc574f8b0e270ffc6dea932fa4839c4120c544da64f5c4c9"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65c6989f16ea97ed13ca448b171e37ada657c2f442d00bea5570eba0bb2770a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0c800342be7e59275e945d96c2f2c0e55c2bd34a74978c05fda83185101bc83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0ddafea903ea39992fc59853ebefa1464d9ddba6550e697fc369a426ee446fb"
    sha256 cellar: :any_skip_relocation, ventura:        "aab6753287475f5c2961b4b61ba8296f88d38972d1ef31c1dbed79be92d6b5c5"
    sha256 cellar: :any_skip_relocation, monterey:       "633055e166f77550f309390ab86dca7b6c7b1f58060a11413b7a9c5ce9a8181b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6daa382c6ef68ec0962eecb5eed305d05e9b8763d73e4d6018db1282ad9a306e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad8a2cfe8260f3012715b286dab13c29b9e79927e9dbd779142a5a5fa2f5b0d9"
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