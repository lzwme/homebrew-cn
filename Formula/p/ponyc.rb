class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.76.0",
      revision: "8315d082da3ce876d95e25cc646652916c910554"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_golden_gate: "8c0b84af020e3fb0983bc00c0620d13480716f0eea062ca17590cc9cdd3d9ce7"
    sha256               arm64_tahoe:       "c87728d9537dd23d2dccfdb00c7366ea96d9110d85d7f25176f0e09a2e843727"
    sha256               arm64_sequoia:     "a8a1e2ad761c4eb318fd86993071321a05e5abe5d1a84c4b29a19ce13968c29d"
    sha256 cellar: :any, arm64_linux:       "aedcb6c99b58acbe315a8aa59921a746ab4699830bb8a026da75cb6176cf2f50"
    sha256 cellar: :any, x86_64_linux:      "e0fc5b3b4158ae3b936c85be108acd711b4d7330294a1dcc10c1ab71bcd56f5b"
  end

  depends_on "cmake" => :build
  depends_on "google-benchmark" => :build
  depends_on "googletest" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    pic_args = []
    if OS.linux?
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
      # aarch64's small-model GOT overflows with the default -fpic
      pic_args << "-DPONY_PIC_FLAG=-fPIC"
    end

    # Use formulae instead of the tarballs `lib/CMakeLists.txt` downloads at build time
    inreplace "lib/CMakeLists.txt", /^ExternalProject_Add\((?:gbenchmark|googletest)$.*?^\)$/m, ""

    # Build the vendored LLVM that the main configure step links against
    system "cmake", "-DJOBS=#{ENV.make_jobs}", *pic_args, "-P", "lib/build-libs.cmake"

    # ponyc requires a lowercase build type (it doubles as the output dir name)
    cmake_args = std_cmake_args.map { |arg| arg.sub("-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_BUILD_TYPE=release") }
    system "cmake", "-S", ".", "-B", "build/build_release", *pic_args, *cmake_args,
                    "-DGTest_DIR=#{formula_opt_lib("googletest")}/cmake/GTest",
                    "-Dbenchmark_DIR=#{formula_opt_lib("google-benchmark")}/cmake/benchmark"
    system "cmake", "--build", "build/build_release"
    system "cmake", "--install", "build/build_release"
  end

  test do
    system bin/"ponyc", "-rexpr", "stdlib"
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