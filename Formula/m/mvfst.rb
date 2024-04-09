class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookincubatormvfst"
  url "https:github.comfacebookincubatormvfstarchiverefstagsv2024.04.08.00.tar.gz"
  sha256 "f0745b81ec5fefd53ca43f6d399108e88264b8e14e329b47eba64f3872982160"
  license "MIT"
  head "https:github.comfacebookincubatormvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05858138ddef74dcfb24923e9caf42922731ddcea78bea03694affa630ba794d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98a9049b4fa8e354ffb98afdebac297f44429d8d91527505519af29e82460100"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21c4296ea9d025497b0b398b7a84e0e2a4aef836320c2fa271781cf405c8f858"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5c1fbe3e6da70060e1177dd074d1fb6b39142b32d7115a79969f40082a90d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "80bc1b256a21924ffdfc0cb19691007f3ce6420cdb85c57c6d6ba89479159e94"
    sha256 cellar: :any_skip_relocation, monterey:       "3bbb495e4d057099eb3421daf99f49240101538d4ea1d01a311901fce734ec61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8ffb6475104a970d497864cde37ed47c10b3e8af2d5b08a0b783ae88cefb41"
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

    (testpath"CMakeLists.txt").atomic_write <<~CMAKE
      cmake_minimum_required(VERSION 3.20)
      project(echo CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}cmake")
      find_package(fizz REQUIRED)
      find_package(gflags REQUIRED)
      find_package(GTest REQUIRED)
      find_package(mvfst REQUIRED)

      add_executable(echo
        quicsamplesechomain.cpp
        quiccommontestTestUtils.cpp
        quiccommontestTestPacketBuilders.cpp
      )
      target_link_libraries(echo ${mvfst_LIBRARIES} fizz::fizz_test_support GTest::gmock)
      target_include_directories(echo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    CMAKE

    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."

    server_port = free_port
    server_pid = spawn ".echo", "--mode", "server",
                                 "--host", "127.0.0.1", "--port", server_port.to_s
    sleep 5

    Open3.popen3(
      ".echo", "--mode", "client",
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