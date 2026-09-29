class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.72.1",
      revision: "de5eddd973a48689ceedd12d24bf42358e5694d5"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256               arm64_golden_gate: "348218fc1d773cfbabde2750e93e7bb5e13ee8d13f9a2fb30e090477268b7747"
    sha256               arm64_tahoe:       "fd99303849388424b3d1f6851e06b2f1bb8d15f70bc0f8a677031ddee34ca753"
    sha256               arm64_sequoia:     "cd4bd1d7aa2bc58d097cdf486f83670681e99f67f7c8f0f984dbdb6adf55385b"
    sha256 cellar: :any, arm64_linux:       "93f21b5893b5d465106d341105235e1b49270ce42a1c18942fb1c74ba5404079"
    sha256 cellar: :any, x86_64_linux:      "05dcfed1415f78b413719003fa56fe8d8f15bc6654c309569a230313d600f2f5"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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

  def install
    pic_args = []
    if OS.linux?
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
      inreplace "lib/CMakeLists.txt", "-DBENCHMARK_ENABLE_WERROR=OFF ", "\\0-DHAVE_CXX_FLAG_WTHREAD_SAFETY=OFF "
      # aarch64's small-model GOT overflows with the default -fpic
      pic_args << "-DPONY_PIC_FLAG=-fPIC"
    end

    # Build the vendored LLVM that the main configure step links against
    system "cmake", "-DJOBS=#{ENV.make_jobs}", *pic_args, "-P", "lib/build-libs.cmake"

    # ponyc requires a lowercase build type (it doubles as the output dir name)
    cmake_args = std_cmake_args.map { |arg| arg.sub("-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_BUILD_TYPE=release") }
    system "cmake", "-S", ".", "-B", "build/build_release", *pic_args, *cmake_args
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