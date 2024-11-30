class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https:drogon.org"
  # pull from git tag to get submodules
  url "https:github.comdrogonframeworkdrogon.git",
      tag:      "v1.9.8",
      revision: "6d9ecb8d8d8dcbbc14db618c0687c7ae4c792f1b"
  license "MIT"
  head "https:github.comdrogonframeworkdrogon.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "d7713ae1b91274ee539bcf3111396ec341664bb66b360143be1bc02ee1d527bb"
    sha256                               arm64_sonoma:  "918e9594835f3f5ff27992fefc91867c58148b21f203e1dacc305d6db9e6bda6"
    sha256                               arm64_ventura: "4f6b123877a15d6ddc9eb00dcd6a8ad384c2f5f23a25a3e440767ea52652175a"
    sha256                               sonoma:        "0d5ac27f514e7014ee8c605c7a6a3dbb8f36bf61bb1cd89e84e26fd6f0102d66"
    sha256                               ventura:       "f11e22833092ef33c773b2781cca9d5285419e3b42f3807cc38ae619d5e69cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37802093942e430f38b315d72c019af76246e27fd7acf55f40c6c0009e3d0dcb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@3"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    args << "-DUUID_DIR=#{Formula["util-linux"].opt_prefix}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      system "cmake", "-S", ".", "-B", "build"
      system "cmake", "--build", "build"

      begin
        pid = spawn("buildhello")
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