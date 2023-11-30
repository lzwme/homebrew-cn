class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.11.27.00.tar.gz"
  sha256 "26d9a221fd2a9e8790aef4810dcd55575f5773572855c5d876fcb139014961e9"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd123567d727b7292fa2e0513bbbd8f8e52bd2d94b981f08b1cf77135484ced1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b33c4d37dd6ba0627aa4e373b8c2795741f9073e91b15bb179834b4cdcebb561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc69b97cbb3f5ad498b769fc08965fcb40f1b4d01afb028b615e793c199e53c"
    sha256 cellar: :any_skip_relocation, sonoma:         "91164c416147af8e34688b27e9ac87a05142c886feacbde67f6624f508f25fa8"
    sha256 cellar: :any_skip_relocation, ventura:        "decb8cdedbcf401136d40d89a0272ac14617aebda905227f0688d1f6df4b24e2"
    sha256 cellar: :any_skip_relocation, monterey:       "79f0df9cad8b4d0ad468effd37e489d5a125353b87e968ce8fe4ecc1cf9dc913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e18cdb27127b2b3d988d31f9c28b3ce98f9bf9718a90e1f99827fe838785334"
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