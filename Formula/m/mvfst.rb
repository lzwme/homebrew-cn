class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookincubatormvfst"
  url "https:github.comfacebookincubatormvfstarchiverefstagsv2024.06.10.00.tar.gz"
  sha256 "cc75889429a66463cc8e607ba09d584fb4e6d2e69b1127a538043b367c54a1ae"
  license "MIT"
  head "https:github.comfacebookincubatormvfst.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "9807ead1cdec9312a434233435915fda38753b493388e1f0b82c34fa6b0c199e"
    sha256 cellar: :any,                 arm64_ventura:  "9f42fb882a4e8540c22f5dcf79b2e68f490a448b40f5680f0162820b9c0309b3"
    sha256 cellar: :any,                 arm64_monterey: "ac6755ede44509df56645d868996f13ddb30b19d0b02a530df0bfafb97eda66d"
    sha256 cellar: :any,                 sonoma:         "1ffd22b3b7e2096da6f958ef83df50383823b83a6a119beb071ff2c7c2241ddf"
    sha256 cellar: :any,                 ventura:        "4a33a960b8b47c1d1f2ecfb85e37bd339782010d5b5e916663aa00bf2120884b"
    sha256 cellar: :any,                 monterey:       "2030ecb20eac98ff8a1c1d3e6afd87b4f217a14631f5e07ea3389a78a62c6859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b877a36eee9be92c9ad14980a4bec394eabca3c30f0b947632c10e6dda498642"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_TESTS=OFF", *shared_args, *std_cmake_args
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