class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.07.31.00.tar.gz"
  sha256 "d10ba63e98ab75d418fb41132feee64883465e04e9bcf2b7ee60e0df3ca6f9bf"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fedff24aa1433e9e1b278d4d9f78a947cc24596902e248d911c885c8105607dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a13ee2bd72ea26713850734f94b6ec90fe7003d540e9f8fbb50dc699ac45e6ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e07d88bf7bca0db090c077f8d6d7225b9277ba128d5e1cc2d4a556f3a41fdd75"
    sha256 cellar: :any_skip_relocation, ventura:        "10fb52429ea0db5a460e0f72e3073c79333e5bf757601cf3c17d4969de20f940"
    sha256 cellar: :any_skip_relocation, monterey:       "6b618b26f57a5cce2c6efed943e33a8299d20ebcf1c07437b9b153e591fb8f24"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc2ab1e28dd14237eba27af61fccf61ff3f7eccaa7df6d4d3e2e95831c778139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f5828445a284dc0e3a0ef831b215d84a2a977f29c9592f4b29b87318cf2a39"
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