class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.62.1",
      revision: "49f73be6ed5c61735e65874a5991866828312114"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "5ffb0be97114bd06d618e3e35ad34a11bac430a5277cea97a1c316d3166f012b"
    sha256                               arm64_sequoia: "2f471497263293080a0e50589404d1a77c424a64c24a0190b827f77b231c1993"
    sha256                               arm64_sonoma:  "2c1fe26819791e8083cd43abab97d7e5dd79df0c55462c2392f08fe62e26466a"
    sha256 cellar: :any_skip_relocation, sonoma:        "615de979a2788aa0fad3d93e6909604d587c6f94b52fb32d77e5af77b2e8a397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c4c55314fd56ff47a3bfc6a9485f0309ac96f58fedc56618d3602650c0fa43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c36c0bdd741e7ed1dd5febde7ae5c522bbe98b3d025caaba4a4cc95b6fe091c"
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