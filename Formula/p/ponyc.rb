class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.55.1",
      revision: "800527f783997c8a32066980a99fbffeeab10d11"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96d0dfc77a754bc9bdf078738a4a582c36099c73f9400855e872277fe52303de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4409d69ef04220c0ff504a9e7a9853abc4002a48fd283e1c34490bf284dd5595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09626299ee4361f0c89ff99e576e68f5d7faf22f108de127566d3c83268713e2"
    sha256 cellar: :any_skip_relocation, ventura:        "6ae38eccb5145c9aed1c4f2de2adf1dc40e336fbfe859e1ca044bfc8de30aad7"
    sha256 cellar: :any_skip_relocation, monterey:       "3ece8fc390107782d7663bb4fab0831bfb70c2ea8d42970d3a6511aff84e4263"
    sha256 cellar: :any_skip_relocation, big_sur:        "293495e4542c8bacf80465ff2aa87e4a44e8b0cf9d52f11183dd2b58063d67e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aaf2ca49ffb9b40ae75224b815cee5bebbcecb06a8c2fbd85c1dc9628a8be9a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

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