class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.71.0",
      revision: "a0a717d0a1435b077cf130b51b233a0ee49aaf13"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_tahoe:   "30f655f0753199e19f94c6a6946475d89f49d95beff77a5ba17befd8da960f8a"
    sha256               arm64_sequoia: "e8799c23b327a66c3a7bd229be4c28f50889b7061b13aa0634aa737036f00ef2"
    sha256               arm64_sonoma:  "4588411f7839e9d15d444e691d67b5dcf9d919906072ad95c0accc93a637182c"
    sha256 cellar: :any, arm64_linux:   "9defb6e761a42797f30d307572a70a1f26b244a378bd32d5e53e54ea6d94effc"
    sha256 cellar: :any, x86_64_linux:  "07223bb7f321aec7fd8e3030454e8d215d22a170d194e564ae5064ddd065e463"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
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