class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.10.23.00.tar.gz"
  sha256 "e6d9bd598dccb44ce5e98eb0064d3863084dd11d5a943da99d9c919b1fe476e8"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6ad51507e7bc11ed512c00c3ff05d8f37ddbe79dcc9151207667ec2853aa55d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6990eae48ee8de605527b3ebfab1ca58863950c16398c8012bf4a58f35a483d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2da187cf12405c985f2fd83b27ec74c34347226afd97809628efe390f343838"
    sha256 cellar: :any_skip_relocation, sonoma:         "465eb5e694fd0f9c520b2702ed765b0656ce9a1dd461b04aee90c3598988008c"
    sha256 cellar: :any_skip_relocation, ventura:        "40fa74bed2fa1bb6dfc216a441a4b7962431b93918a3d8e5aafb1a2d859ff409"
    sha256 cellar: :any_skip_relocation, monterey:       "dce462a53c7870cabdbec597f775a07d45e1fbbe044e71320635b0dd8a4ef727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa2755dd98989d928ff4b316892c4cb03b1cffd6d631f204bda4d4489ebd616"
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