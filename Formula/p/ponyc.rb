class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.61.0",
      revision: "4d9b18e1c087bc46fb8e45d47d30147e4b1760be"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a607579fb0763c69dd3b85a8b366984ade6d8da215a411866fd75894bb694e56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87fc81aa43554cbacc862e62c91325573dd71f33ef758bfffd227d4854dc72a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1e9111d3389e319324a1d39bfc7326f72678adc1d0ad104b29038e54d400ccf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dafd057fae809776d547a68758857d6d23f6392f97ab0af9601a13cefc9e2dbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e776af8e23906a67e4316de8068a21da5b425c9fb254f025724365ee45a39f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8204b8876faf1ebfd7c1931dbc6a93b2bb80b2dd5d581ade60a862e5e10f04"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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