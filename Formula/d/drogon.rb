class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.0",
      revision: "f215cb15a0f53abd0ca7ee8b95ed8c9c3b40d262"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b6a5ea32a06ee2d6652765c81824cc9c91729148d5855bb93e4289947b0cad77"
    sha256 cellar: :any,                 arm64_ventura:  "842b27f46b747ff28ee2e2016b711307b4571ea46205408fd2383667a72b715c"
    sha256 cellar: :any,                 arm64_monterey: "a2c0c047baee797ccb168ebe3ee367616efb3ba20cffcfd3b23481cd0105d373"
    sha256 cellar: :any,                 sonoma:         "ad61fadbc79b1c64563f2740e136456164abcafa0932fbe2c7b68ba58baf9ceb"
    sha256 cellar: :any,                 ventura:        "93a80937abe843287ab95692591d21c1edd400eaac607ef3ae1286bd21485161"
    sha256 cellar: :any,                 monterey:       "a636c7ca2b6e186a3752391324315dd9cfdf90bd2b9faf5681c37fd310140f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527ddd673f5bb543620a8b54e35a63e14b141bb6baa1f694b5610e52f7a15936"
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
      cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}/ossp"
    end

    system "cmake", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      cmake_args = []
      if OS.linux?
        cmake_args << "-DUUID_LIBRARIES=uuid"
        cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}/ossp"
      end

      system "cmake", "-B", "build", *cmake_args
      system "cmake", "--build", "build"

      begin
        pid = fork { exec "build/hello" }
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