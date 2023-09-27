class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.09.25.00.tar.gz"
  sha256 "0b3ea29c669d7db18597cc1ac9834037e81b222b76d7f8e808c7bb40bc3d7b68"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "567061cb114a2cb41966544a6471afeccc2dcc57d015a22b07047fd603ea7cd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75517ec21c201c7b89a958c5d260fc4ec9d54441fae5900d9c228c5390bc0200"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ebbbb76d058980646224629ed2ef24c162bc753b93490c01b5adc26cedee6e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c60c2cde7418477bc723b894031ee330ceb6cfa1afb45b9172bca28ccea365d"
    sha256 cellar: :any_skip_relocation, ventura:        "aa862e3860c6e8ed598f537e738bd848ad35dba67bca7b40f4d25d9299b89958"
    sha256 cellar: :any_skip_relocation, monterey:       "5178567648d3b35a29e5fcbeaa3b2c4b8c928c777f5b6411da4494d53a29660f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a06f978376a8e0fbbcffef42f2ba04c3fe38ca5aafef065310b926b9fa8dd005"
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