class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.60.2",
      revision: "365ae7e47dda5f7a29855269c3c6a99470089dbe"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "397910fb8bb16de5ac87198126735e0712a44a30702b7f7286ac841ad63efd26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a594f2fe1b319661a1780a5afd7e28820c307b9760b665263a36079ec9ebd2db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01d67540c893de48f3ace0171a254ba4190e2a166d56f438df55f31d3bf47de3"
    sha256 cellar: :any_skip_relocation, sonoma:        "83582f3083d6c56c8fc3b812391d3d0c26d086402c67d87e33d34fbc9d9c2779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a05716a657194204e3b21ba9e892f786e06c19e444a37a5d6b1709d2442a2d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "423a54c69c996ad290dacba3c36b73f6c0b5af1e13a5fbc60b8718a34275cd10"
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