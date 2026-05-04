class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.12",
      revision: "89aca8c7993c8194f2c109c1d06a3b45bf363d5d"
  license "MIT"
  revision 1
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "da3e0590411f956b464e9967f1a2942e0bf81e90a1b96994a16cb88692b11e2f"
    sha256                               arm64_sequoia: "abaffd04eb7578816ac9b4c460bd2a3ad652fc6f239623955168ef5f08484987"
    sha256                               arm64_sonoma:  "951a407f1a3bb3ea3f8eb50688e8aa18a5582b39b683137d48e1814bc0fb0b92"
    sha256                               sonoma:        "99f19ef430cbcccfa26b130c44f20cff78a04a7e308039591fd0bd9a3b17de98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af8eb13bb5ece7d6af44a0e7f49c752474910c0d163029bcbf891c20f8f482c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d302c27e453199d62d13f6eefdca1e35c7e68057c7ecfbe0b7c0514ba7063d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    args << "-DUUID_DIR=#{Formula["util-linux"].opt_prefix}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      system "cmake", "-S", ".", "-B", "build"
      system "cmake", "--build", "build"

      begin
        pid = spawn("build/hello")
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