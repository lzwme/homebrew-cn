class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookincubatormvfst"
  url "https:github.comfacebookincubatormvfstarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "59a242a843845b3e82d7bd031e978d7e3cc7ad532f27a06ff8942159ca4fd845"
  license "MIT"
  head "https:github.comfacebookincubatormvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b13de783d2f81addc56dda054ca9b21379ad5399db67f62873be4c0b4a69ad94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68d2a05ac3d44f6fb033c4e7c2855b635a8700e7d9be83d4623e6324c2cdd466"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "405e94722293daa289d74b8b091ac4b6da78918ab92ce9c3ea15abcecca406bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b56555d5c51eb649ff51870c77ceb94d1f011645e57df86bec94a264672d5cd"
    sha256 cellar: :any_skip_relocation, ventura:        "c7dc2a65593900a22e99ea37aad0e8ccc3ac1c8a30419996318434b025541f05"
    sha256 cellar: :any_skip_relocation, monterey:       "505639c23728aee7cde31ba912d49a36a19c397a8293ee57aeb59f2840003601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ac93b936e5d3031ebe390f1023fc99fd9092e8160dc652cfd21cb5e84e16928"
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