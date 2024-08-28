class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookmvfst"
  url "https:github.comfacebookmvfstarchiverefstagsv2024.08.19.00.tar.gz"
  sha256 "f135b3d413e1e64544aa55345540bd132065189a0f4bb87ed933864fbfd2bdef"
  license "MIT"
  revision 1
  head "https:github.comfacebookmvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1cf63de14ed00385fffa456f380f4fba864fe0bc24c51ab67a4998172c508490"
    sha256 cellar: :any,                 arm64_ventura:  "a80cf99b509520094c7820d674565003b11d2a4291705f38c29ca240bed44b03"
    sha256 cellar: :any,                 arm64_monterey: "abe406efba14ad0813425dec9c20f3a26d94a4c69646d471b27d20081d099f03"
    sha256 cellar: :any,                 sonoma:         "5672337d623d72702728acfe3e4be5fbc4d8195c9711da90636d58ae481da920"
    sha256 cellar: :any,                 ventura:        "9147a8857c3775aa124ca01a50a163107826b6713a40baf88edb97585d6bb627"
    sha256 cellar: :any,                 monterey:       "a49f10079436d5574e416a449fc2b4008d5fd57bb3dc8c688103e8cfdc7e2a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "705dd30ebd70d9da9c2b1877fc7a3d016f9d34bd8e170b67f77611f75a6eb62f"
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