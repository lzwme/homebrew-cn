class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookincubatormvfst"
  url "https:github.comfacebookincubatormvfstarchiverefstagsv2024.04.01.00.tar.gz"
  sha256 "e39c4d7dd87520fcce6a3d5d398b5d03bd3e680186b9b0db23f02b502c6bcb1e"
  license "MIT"
  head "https:github.comfacebookincubatormvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b225f94a119bdc852cae7183d6492da1383021d84688444232d25d6d4e9c58fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d122efff6c6308363ab26256edb44bbeee0ae40dbb23cf4cd649027f6cd86c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b439cdfb27ece99e9fa3921142a4ee701ecb078213bd7fdb4e7dfd0d687fc01c"
    sha256 cellar: :any_skip_relocation, sonoma:         "84522a046c1d2f9baae31692375c5bc3b2934551ea582f1be4c2d59b084d75ec"
    sha256 cellar: :any_skip_relocation, ventura:        "f0489b18ba2e05776d5146d8c4906f349e38b6be0626d15040780757c1083f8b"
    sha256 cellar: :any_skip_relocation, monterey:       "dd8be43201636a5a77ba3d98a2c61311e40b10c806c8d92800ec80b4c3eebdc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6aa3b893de2ac27eb8d1d8398b871aee316aface04be568f385c385e56f4394"
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