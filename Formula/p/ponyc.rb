class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.60.5",
      revision: "f79c23905e2ec94d35918aaf9da44923d6a99338"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f525652d7951ed1555077911b4a1801204e4a52b18e5d3274f5d3684f03a818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e8e0bcb269d230c4c5d836d8060f0b165a0211162f54f7c2f00fd0d15360dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d68cfcf1721271206cbab5d7e9ca6bc52b457f7d44c3df38e1f4b0b02985d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "660361682ffab3966241fa8bbac5237e6a2963629fe290585fd84a0ca4c49caa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd23e96b88bdf0e73f58e204a368aaa141a54bd6139d13242a95881c1460912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5426abe29e4492be231b2aee9bc5b296665938b2bfff39052ecf1f63f8b27e88"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    if OS.linux?
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
      inreplace "lib/CMakeLists.txt", "-DBENCHMARK_ENABLE_WERROR=OFF ", "\\0-DHAVE_CXX_FLAG_WTHREAD_SAFETY=OFF "
      ENV["pic_flag"] = "-fPIC"
    end

    ENV["CMAKE_FLAGS"] = "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"

    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    # test ponyc
    system bin/"ponyc", "-rexpr", prefix/"packages/stdlib"
    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip

    # test pony-lsp
    require "open3"
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    Open3.popen3(bin/"pony-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end