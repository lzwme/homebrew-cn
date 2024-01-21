class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglereleasesdownloadv2024.01.15.00wangle-v2024.01.15.00.tar.gz"
  sha256 "04223dd7db263bdd2c02d1223cec37932671b36e07e8ffe2426be8140ffc6cac"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f03caa807e9a9b58a818c99e126fa013f396747ebc6d1b0539e974aac217c204"
    sha256 cellar: :any,                 arm64_ventura:  "6b0487db09c025d7da0527c4de50d25e3e2b8af3fcf1a44411e3414b07a49e32"
    sha256 cellar: :any,                 arm64_monterey: "b8a6de08d5747d8c7baef678485ece06965f6767a0387dd70f8fb2861fc2f186"
    sha256 cellar: :any,                 sonoma:         "5b49ac16f6353ceec9dc29b1974609267c5260d9543961c950b023c875161fc3"
    sha256 cellar: :any,                 ventura:        "d6650df41b9e4fb544f0c43817e49b2091e70a2216775a4447f06bcb733977b7"
    sha256 cellar: :any,                 monterey:       "404c168bd4b0e6f4a324006c998d9a5a96a9e708d8ec9293ba6ad54b1d988a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7abdb9995ceee7fc2721a8f730f370387532c7121edbaff414477e060a60df"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    cd "wangle" do
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "liblibwangle.a"

      pkgshare.install Dir["exampleecho*.cpp"]
    end
  end

  test do
    cxx_flags = %W[
      -std=c++17
      -I#{include}
      -I#{Formula["openssl@3"].opt_include}
      -L#{Formula["gflags"].opt_lib}
      -L#{Formula["glog"].opt_lib}
      -L#{Formula["folly"].opt_lib}
      -L#{Formula["fizz"].opt_lib}
      -L#{lib}
      -lgflags
      -lglog
      -lfolly
      -lfizz
      -lwangle
    ]
    if OS.linux?
      cxx_flags << "-L#{Formula["boost"].opt_lib}"
      cxx_flags << "-lboost_context-mt"
      cxx_flags << "-ldl"
      cxx_flags << "-lpthread"
    end

    system ENV.cxx, pkgshare"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    fork { exec testpath"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
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