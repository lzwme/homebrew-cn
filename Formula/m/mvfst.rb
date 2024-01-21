class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookincubatormvfst"
  url "https:github.comfacebookincubatormvfstarchiverefstagsv2024.01.15.00.tar.gz"
  sha256 "c4a2a41916f9beec678c78d78eb2cd33f308d0fcdc8d6502a8aca0a0410e7828"
  license "MIT"
  head "https:github.comfacebookincubatormvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e7826ddb1522b1a70a297f8090741f89b2879883d273cab25bf70c673774919"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4f2167bae3661694fa9d86ac083313bc05a26892c4e1b14f6a276bb34b9fd77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d3e54f0ff0da82040ba459c047958920cc85d4d9b1615b37eac2de04b7adc56"
    sha256 cellar: :any_skip_relocation, sonoma:         "44a0a0b877758c3f453053239913e071f8a6e149d9222ff24a1b3d893ccb4ae1"
    sha256 cellar: :any_skip_relocation, ventura:        "2d38f2397ff3185be64fade8068034070b2dbb357990fa568df26e99aba3b360"
    sha256 cellar: :any_skip_relocation, monterey:       "640eb97518e9d0eb0b8f6898b6a1a197c80da976a0e3cafc7b1e279de37250fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977c516dcc58bdc2daabacd71f2ba55aa2e3f2cb2f21960d64fc259d2848990a"
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