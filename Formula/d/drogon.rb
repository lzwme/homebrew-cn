class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.12",
      revision: "89aca8c7993c8194f2c109c1d06a3b45bf363d5d"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "661141d4f4f5c52605a0adebe33418ac677778f4d683d0c0786134eae5a4bf3f"
    sha256                               arm64_sequoia: "795425c3e71d1e871ab40a07efd3d0915016b079b7914147493c192fa8cba8af"
    sha256                               arm64_sonoma:  "ad3c7dbdd666305037c7a91afde3e4a5a6608333c87f76c8c2a9b3cdf2bba4da"
    sha256                               sonoma:        "37f3817fdf6577228cb5954858c9b3bf2e9f13cb367d0415a0c1f448ddab9302"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7784c5c3b1e48766ccca5bbd40cb4adb2f9be085de2b9ed2626f411d8ae51b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7ed5174166065dcce49c797b9e64ce167756455ab6c07a68cab1f6bac28128"
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