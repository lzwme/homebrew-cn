class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://ghproxy.com/https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.11.06.00.tar.gz"
  sha256 "107e6d46c8c8f98fb375082f9439692884be89ffbf29d1d7e5e422248de02f85"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b690b4587a3b3d48fc40bbac39595849e3a6be94a533d114f120ef0b20db1541"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8c7dce5a1ac68d465cef047b8e77ce92f051528e36a15080cca578e01dbfa6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2c2df218a0811ef2c4fb494c81cd29ad151a3810edef1ee279c88722386cc65"
    sha256 cellar: :any_skip_relocation, sonoma:         "99cddaac7307eea89495cc02e48f56a0abb64ba106460b22d7f4f114daca15de"
    sha256 cellar: :any_skip_relocation, ventura:        "eda346f4318e552b19924ae09d5bdd1588422220e471b77442bc6b425e1e42ad"
    sha256 cellar: :any_skip_relocation, monterey:       "3c4ab3cca2d214023a796421d89f5acd09fbb32e47c0354e31ac07a19061a622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4e39422008f58c913e665982b612e49449252369a958790b9864db26848910"
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