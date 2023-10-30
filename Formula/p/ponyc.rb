class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.57.1",
      revision: "6ed042ee16a5d77671da56cfbd72f0330f072e50"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72f3f45057a514be7022a38732d0175e424d992129c25b6d3ea828e657b0c43c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcc55418f16795f434c36ae314bc971a93eb620a1442998770bf01a54986af36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28a4e42870418c4d92a1649b7206cf55a722dedfd470cb245520fde73b3d1bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "209b96b37ad14982ac9be5dff61d889b9a7d3c7f19c05f42f64a52ffb40919d2"
    sha256 cellar: :any_skip_relocation, ventura:        "8cc0690a280320875f9d8b890fb7b0e665f6aa1d3244fa69d51c3f56370c25ab"
    sha256 cellar: :any_skip_relocation, monterey:       "0e07e03d03a382caf73dde4e32e7ca8ca91645568f1b4553b7af5553345b78ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdbbea1ece403cd68980d289fd691e75c4bd731d8f6c4c8e65f19fc511b97596"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "zlib"

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<-EOS
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

    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end