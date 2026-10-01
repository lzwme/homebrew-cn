class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.74.0",
      revision: "95ad18015d04f4414d0fd4f469ed6b2e9b9b9e73"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_golden_gate: "a350d62804d577d9e0b787732ba11fe6d3a17dda4947ce1637aa7cee76bd8ab5"
    sha256               arm64_tahoe:       "a716aec9b7e4d5d08ca7707068a6b8dce8fc9a140d74d9c59cdcaff0c6d76252"
    sha256               arm64_sequoia:     "0783cb117a44d3e0a29e9a506e823e893c7eae9bb86e8dbc3743863b7f6d29b8"
    sha256 cellar: :any, arm64_linux:       "546963b0f054b214ed68baad00ed869a686974eb1b5a8180e91962a7dec07815"
    sha256 cellar: :any, x86_64_linux:      "ea4bfcf9a6000a16cd8cdc443994a6a2c47b3d2040d426ece74ad339a9222f33"
  end

  depends_on "cmake" => :build
  depends_on "google-benchmark" => :build
  depends_on "googletest" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch do
    url "https://github.com/llvm/llvm-project/commit/b8007a8e4020b8bca2b12e941660e10bf5bf6716.patch?full_index=1"
    sha256 "e41e300eb6f5cca9172ab344e572c3fb24f0d05885ae23dd7cb4f9c2528839f7"
    directory "lib/llvm/src"
    type :backport
    resolves "https://github.com/llvm/llvm-project/pull/222721"
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