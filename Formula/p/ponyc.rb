class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https:www.ponylang.io"
  url "https:github.componylangponyc.git",
      tag:      "0.58.3",
      revision: "59a59c213b1c40f8bd96cea5746f42197c578efc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8097e16d4e4e0a62caed8f585931625a7096984570f43b1ed84f0f1de1bc7df6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bbd295c7bd464cdf5018f3f83f01d9049479a2391255ab6508ae11a998845e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd4789f0bc14c592c8c3344f70464a3932855c2612899f20139ab8b929a858b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6ea8e5cfbf9e06982a34122eecb2ffca3666baab2c8f0d2aed17d6d44bf968b"
    sha256 cellar: :any_skip_relocation, ventura:        "fa676c3d9e92257ce8428a133d51dd8a887f8d5ceed9dc932ecb8b10a8fdf00a"
    sha256 cellar: :any_skip_relocation, monterey:       "ece917e6543c81030797c1dfaf315337d199817c24bab0dcb26d8d4717e66785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001c13c340f3d96556da3b9acc5bb9ef0551bb26b58ab5b9f14b66add0359945"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "zlib"

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<-EOS
      ...srcgbenchmarksrcthread_manager.h:50:31: error: expected ')' before '(' token
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

    system "#{bin}ponyc", "-rexpr", "#{prefix}packagesstdlib"

    (testpath"testmain.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}ponyc", "test"
    assert_equal "Hello World!", shell_output(".test1").strip
  end
end