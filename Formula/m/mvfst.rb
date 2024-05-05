class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookincubatormvfst"
  url "https:github.comfacebookincubatormvfstarchiverefstagsv2024.05.02.00.tar.gz"
  sha256 "e77133e4a4e5d0eca4550851f479ac7ac40e05853fb3dba5508d3412f5d401ee"
  license "MIT"
  head "https:github.comfacebookincubatormvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fb4a1abf6f69fbe2c34d11ec0a7bdd89c3459b9c6ae59e778fe58196bb206f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77d8405775110d90f258df723b4d812b4487b0cb5d69345a560af3e141d74f32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be8a2d867c1612724614803256ca5db0f5a9de3e9b7b2c1f91d180f4b37ea41"
    sha256 cellar: :any_skip_relocation, sonoma:         "888c278a7d5bfa4be55e3f202bf3d7bf30588ae87dbc041ba1bd1fcfe0774b21"
    sha256 cellar: :any_skip_relocation, ventura:        "f1d6456b75c28910c6530b0b31a42d4fbdf0bc79c0b5b3468b570dae66811e25"
    sha256 cellar: :any_skip_relocation, monterey:       "3285edf73f419ea40bef09a4aef1efc90f17bb4cc6dc26b201afb89da344269d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e7c2bad0d60c9e8c3a91f2998764048ec78a9ea060a07e23f686a4fab5a0e5"
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