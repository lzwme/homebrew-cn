class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.60.1",
      revision: "4f05c28ce49bd65641d4eac717cf85f6678f524b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04d0c47585629ca9e0c2ab9f2ecb2685602415a0e698ab9218a4b05650c059ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a901c6ebbd181be4f8032538ff8b5829dfd4243bed973f72791c40caf3aa35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f2c107bb386f01e9b5e69918d466880712be2472888820828bfe06ae75a4a05"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c0f8f3bafe0251581d4459c712f14a5bc1dc103b422a53ca681573ed4e2decd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38fa6c0a4497e879fc16d70f753db39eb6393fb741281d28f7323dabeddc8795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d66ff1755803272861389a41d5ccefacf1b4545cdf820348e0665cc8db69f7"
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