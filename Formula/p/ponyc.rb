class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.77.1",
      revision: "907c389719e67c3d1b44db9ac788908b8194789d"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_golden_gate: "7de57c11ad3495a3e8a2633674091251232375af17d3595fa0febdf3c8799a10"
    sha256               arm64_tahoe:       "51ede3da3b0aadee2e13c6862bcb9b936ae6bbb31cafb8783d6ab61af9bcd398"
    sha256               arm64_sequoia:     "c0362b6b20abf1d3ea56150e05da6cb62df6bc0c32551a986e906c6db7ecbe4f"
    sha256 cellar: :any, arm64_linux:       "85981ec65bfc57c908e253a0d7cf104e7175e3dc1e1c6e19bc7920a5ea2f2473"
    sha256 cellar: :any, x86_64_linux:      "bc6810345236e5c61e5376c2a4e702ae6bf049e4f197ae1fcf3a7f8650e7dd99"
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