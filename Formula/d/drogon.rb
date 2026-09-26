class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.13",
      revision: "4c5430757ea5451a7c38fbbef4b4bef7dbb47f2f"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "d0e62373deac65d1fb493b679c8bcd8df49fc2525cd0bbb46f2469323e7b9edf"
    sha256 cellar: :any, arm64_tahoe:       "18dca8c71ad37b5bbb770932d6caaf0fb548ba7f139a6539b6966027ef111a03"
    sha256 cellar: :any, arm64_sequoia:     "6814df6a07b39480cb2813ef644eb323d6082ecee79619825183d6d792bec4a3"
    sha256 cellar: :any, arm64_linux:       "09023fabf142669b866365a24071e244380fa43a7144490a2d5d455c984f676e"
    sha256 cellar: :any, x86_64_linux:      "fae8c1fdfe1d13392e692a87f7c024b13337ef047c4d7b46872e951c77eb7e22"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@4"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    args << "-DUUID_DIR=#{formula_opt_prefix("util-linux")}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH=#{formula_opt_prefix("openssl@4")}"
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