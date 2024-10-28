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
    sha256 cellar: :any,                 arm64_sequoia: "104d0bcb26fdf65349b70c67fcaf5332c59b5c8a687de02a42e55e95b7822132"
    sha256 cellar: :any,                 arm64_sonoma:  "ed7df8b6d3de6cb9591a19aff68a08a85655e8de7f5b2eac2d38eb14b4cfaa98"
    sha256 cellar: :any,                 arm64_ventura: "6be94afa6a2f76bf1ca3bcc9c208699fcd593fa6cca818405ed4fe9eb255b523"
    sha256 cellar: :any,                 sonoma:        "cf4dda4f454e4d79efab47179a4b271ed1abe4047357b2c96f035b8d3269cf25"
    sha256 cellar: :any,                 ventura:       "2e4aa714582bb75849194dfde74de99fa1f5a4077d8aec2016a8c07467a0099c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781436bf99dc8ba66be94afe8f63474cfe4b78c78cbd34d8b7d3695ba10804e9"
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
    args = []
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