class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.60.6",
      revision: "1b870304ca4c6d8a098368a3fa32fa302fab7103"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a48ba74fe68aedda5d1bf06ff7d6a9e040b2cf1aaaa9585d9d562eaca8f2f94d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "611522401eb16fc9056bf384ab160f8c22dfede675822ddfbac2819e6cc63f85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c7363543033e2ff73ecf95cb576f9766ab8dc48c59ace413553200db33ea1d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "580688ca04f5fb8ae85a7c1dcc92232ccd4398c4187b3b68af4eb4c756d70e9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4d386b26d296eb47bead4e78c23ef17276d0e94fc913832e7007bc7c7fd358c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42ab7da0bd4366355c50e12323388c4c7d7a8f84d73d07793bb368f26e112328"
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