class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.60.3",
      revision: "44453bd92b08079b70eb4fb011cfcefa441c30c1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c7c542401071bab72bbe9a5da186c2cbcbcacb50df378b6f68603b3d738228f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d9fb446cdea21b3b942b2b1540aa9a3c94d2e75fad2ef14f76ef569f7b90d57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc160fc80dbc4f89b8a5238eb666faf01fcc85c4170609c0d2c473ac4178b8e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "847251349b3aea00ec716a6e8c36c86685a855fa5fc8ab91ada50dfb4aec2939"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f0e7b5414df009e5bbee1a791cbb65a16b001f8dad5c867bf4940de15469ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f34427ccc0e99367d1ac69e2f649795ed7a35f2efe9c5ef697368aad28d3d2"
  end

  depends_on "cmake" => :build

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<~EOS
      .../src/gbenchmark/src/thread_manager.h:50:31: error: expected ')' before '(' token
         50 |   GUARDED_BY(GetBenchmarkMutex()) Result results;
            |                               ^
    EOS
  end

  def install
    inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\"" if OS.linux?

    ENV["CMAKE_FLAGS"] = "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"

    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    # ENV["CC"] returns llvm_clang, which does not work in a test block.
    ENV.clang

    system bin/"ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end