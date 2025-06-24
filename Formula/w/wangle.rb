class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglearchiverefstagsv2025.06.23.00.tar.gz"
  sha256 "17590983cbb1a79bf21e8b03b34da0c8cd8bea93f0f80b387b136ce636f2ef9e"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e49e24ded9079fe578ff6a52b74d377b9e86337fbacbc8860557cfeea75727dd"
    sha256 cellar: :any,                 arm64_sonoma:  "a9dfd9fbbefe3c00d30bf0ec4c35b9a528dafbd0807d8fe94a58af50e264f2ad"
    sha256 cellar: :any,                 arm64_ventura: "7d6db4d0b1e91c82c7ed99fb7fed4f7dbec5f0dcc7801929189f81b0282a9e9a"
    sha256 cellar: :any,                 sonoma:        "a4e062feb4205836c2386afe31e00480a9a0e3205e5ac73bb29fc1414c16fae7"
    sha256 cellar: :any,                 ventura:       "c7711fe0709b5bc44e68cbf3969300188e9b1201ec540587d3b23af979e54e18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e880bc01e9a2e5c8b177f8aeb415b9292dc522112100b29ad3193abae984153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "210a3af8dcd3c8b1f7e9266dbca4709d7ebda78b77029a867ecab0711006c452"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "bzip2"

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    linker_flags = %w[-dead_strip_dylibs]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", "wangle", "-B", "buildshared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", "wangle", "-B", "buildstatic", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install "buildstaticliblibwangle.a"

    pkgshare.install Dir["wangleexampleecho*.cpp"]
  end

  test do
    # libsodium has no CMake file but fizz runs `find_dependency(Sodium)` so fetch a copy from mvfst
    resource "FindSodium.cmake" do
      url "https:raw.githubusercontent.comfacebookmvfstv2024.09.02.00cmakeFindSodium.cmake"
      sha256 "39710ab4525cf7538a66163232dd828af121672da820e1c4809ee704011f4224"
    end
    (testpath"cmake").install resource("FindSodium.cmake")

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      find_package(gflags REQUIRED)
      find_package(folly CONFIG REQUIRED)
      find_package(fizz CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)

      add_executable(EchoClient #{pkgshare}EchoClient.cpp)
      target_link_libraries(EchoClient wangle::wangle)
      add_executable(EchoServer #{pkgshare}EchoServer.cpp)
      target_link_libraries(EchoServer wangle::wangle)
    CMAKE

    ENV.delete "CPATH"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_MODULE_PATH=#{testpath}cmake", "-Wno-dev"
    system "cmake", "--build", "build"

    port = free_port
    fork { exec testpath"buildEchoServer", "-port", port.to_s }
    sleep 30

    require "pty"
    output = ""
    PTY.spawn(testpath"buildEchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 60
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end