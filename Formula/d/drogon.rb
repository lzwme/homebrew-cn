class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https:drogon.org"
  # pull from git tag to get submodules
  url "https:github.comdrogonframeworkdrogon.git",
      tag:      "v1.9.2",
      revision: "93c568bb953725a5e73a4997aa5b87a6e6aa233b"
  license "MIT"
  head "https:github.comdrogonframeworkdrogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6de4eecaaef04c670e5e271116b71fde80659047c0fcf70a821fd73bf5dcc42c"
    sha256 cellar: :any,                 arm64_ventura:  "8eac077e3b15cb1f24c66a6f74b1c0e4c99b743b1c28d763e1788f2f82be2051"
    sha256 cellar: :any,                 arm64_monterey: "907d5d2588bab01cc4ed8f9cf26e2de827f94d7c7954c9a3564564af6fee4399"
    sha256 cellar: :any,                 sonoma:         "dd23e1c77bf221de20223ad866e3ad886db7efca7ab7cf00e88e8f85f7c735b0"
    sha256 cellar: :any,                 ventura:        "04b386fc507018437baf97652f582fcb17068d3d24faffec2b56cbf4dcd085c5"
    sha256 cellar: :any,                 monterey:       "253f253456a7551e30f8de2ca5c0e0172799715a54077aeb099c7880990a0b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46cff0bb72012214a14f53f7d12c15b05ce49f54f2b128c0ddf8c8f0fe2c2307"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "ossp-uuid"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

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