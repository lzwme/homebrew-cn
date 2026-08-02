class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.68.0",
      revision: "1d66f613d8a13de2f3b12ff45abfaa263ff185c3"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "40af1640e48d89c5914cdaba1fca86c22ffc3bfed9d723a0c2cd87fa7232ee72"
    sha256                               arm64_sequoia: "cfab4ceedc7053bad46362d17497b34b0ef7702a8330c9a1f8e3275fb272bbc6"
    sha256                               arm64_sonoma:  "59db53446fe5c4075bfc622849f09da4ae4ba14e1817de98a5713ba4b0c2dd2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e1a86c4cb139ad70d0019542b35de78bcfbccc5ddb098ef8ae4a1e94367f53a"
    sha256 cellar: :any,                 arm64_linux:   "7b3e2980a4b74bd2eca0dc1832e2c3b0ec3bb71133d0947af4c9815763e0e87a"
    sha256 cellar: :any,                 x86_64_linux:  "68f14cc3495e0de8a56be0e0ea7eb7cd943f1691c5b6bbae80545375a3259564"
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