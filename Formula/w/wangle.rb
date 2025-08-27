class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghfast.top/https://github.com/facebook/wangle/archive/refs/tags/v2025.08.25.00.tar.gz"
  sha256 "71966377103d7282bdc8b856b0f6457a8c4fed6691193b89632aaa463c88ac37"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17e7f0b3bcfd489d45e68ceb7cf8e047cddd714c7ddfde0452861e4e631e5fed"
    sha256 cellar: :any,                 arm64_sonoma:  "e9616d476dabca1caab22e93adbf29643c2cfae2790646e3f90cd289d7da5fb2"
    sha256 cellar: :any,                 arm64_ventura: "cab4ee31c2dbcc1a7a37d138d0d97f0f7fc1d546bef0ee1da4af9f00b2448f63"
    sha256 cellar: :any,                 sonoma:        "15d97ede9a3b53443de660d63713354f4fbe8d04b0859d784573258aa711420d"
    sha256 cellar: :any,                 ventura:       "32054ca7b3b66f40099288764b03dadcbc81f86172ab9a4438f1f53da9647429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8afd6b085afb84f218a0671e0c294e76835af46b28a8ccf53e6ab7827386e639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db0cfdef9a09b711394e0b54f9945f261b99ddd292f9c27fb4455f46c6d043cf"
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

    system "cmake", "-S", "wangle", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "wangle", "-B", "build/static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/lib/libwangle.a"

    pkgshare.install Dir["wangle/example/echo/*.cpp"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(folly CONFIG REQUIRED)
      find_package(fizz CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)

      add_executable(EchoClient #{pkgshare}/EchoClient.cpp)
      target_link_libraries(EchoClient wangle::wangle)
      add_executable(EchoServer #{pkgshare}/EchoServer.cpp)
      target_link_libraries(EchoServer wangle::wangle)
    CMAKE

    ENV.delete "CPATH"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_MODULE_PATH=#{testpath}/cmake", "-Wno-dev"
    system "cmake", "--build", "build"

    port = free_port
    fork { exec testpath/"build/EchoServer", "-port", port.to_s }
    sleep 30

    require "pty"
    output = ""
    PTY.spawn(testpath/"build/EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 60
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end