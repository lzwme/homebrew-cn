class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "3d666330073aff36db4d61f8a6819e5850802aed20795a0578186f9a6fe97d00"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "058f2065f58b1f2c62a0f5581440e6dfccf8bb2961d1175b519defdb4aa59c75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7217f7d6016582419123b8613f5ac1421060515edd55029d476fb3d53e0c097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17ba84ea36b553177c0bb14640063a0a4d1780a5fdcab987821f83a5ed662815"
    sha256 cellar: :any_skip_relocation, sonoma:         "19edb5810c518659d0c7ef1b2989bdf12d062c1aef1dafdcb7d793b4af3c4025"
    sha256 cellar: :any_skip_relocation, ventura:        "e0aaeb7e7036514b3fa5e43ca28232c2a8738414d5369142ab46ee69d813959e"
    sha256 cellar: :any_skip_relocation, monterey:       "15ea213b91449fc5a2574415fbef96f66fabcfd89ea3a43b212fd396d813a775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0afc7c2bbc403b89b337a2016b6fd2473fe99ce7be072a0b82bff1ffde16d1f"
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