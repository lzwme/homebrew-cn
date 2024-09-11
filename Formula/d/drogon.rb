class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https:drogon.org"
  # pull from git tag to get submodules
  url "https:github.comdrogonframeworkdrogon.git",
      tag:      "v1.9.7",
      revision: "73406d122543f548c9d07076e16880b777bfc109"
  license "MIT"
  head "https:github.comdrogonframeworkdrogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf7c74284852f6d0994801dcb43ec9ee803f8461c0dbe73d08b1939c5f054f98"
    sha256 cellar: :any,                 arm64_ventura:  "84487ed585e740da2bdb68b51bee8d0e44200d0cb042fc0937715518101e96b9"
    sha256 cellar: :any,                 arm64_monterey: "deec7b3c03c52359fa5e2ee1f00364051f544e7bf149aef99d9b1f161de0a065"
    sha256 cellar: :any,                 sonoma:         "9241c4a8d933f212f5035a318764eae45718b055e5ff44367c2728dfca831e86"
    sha256 cellar: :any,                 ventura:        "dc5c334e6b4e70c8691cdc35d310c389a1ba9c9f2648ec4fb8190944faee7253"
    sha256 cellar: :any,                 monterey:       "be8f0e7ecd6bcda797c7caacd41a2b61735ea0ab7a67a5112efff31718321132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c2cedaf64eb00ddc705fcbaebcea12c940fbf7ca2d1a221f50a1895298490b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@3"
  depends_on "ossp-uuid"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    if OS.linux?
      cmake_args << "-DUUID_LIBRARIES=uuid"
      cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}ossp"
    end

    system "cmake", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      cmake_args = []
      if OS.linux?
        cmake_args << "-DUUID_LIBRARIES=uuid"
        cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}ossp"
      end

      system "cmake", "-B", "build", *cmake_args
      system "cmake", "--build", "build"

      begin
        pid = fork { exec "buildhello" }
        sleep 1
        result = shell_output("curl -s 127.0.0.1:#{port}")
        assert_match "<hr><center>drogon", result
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    end
  end
end