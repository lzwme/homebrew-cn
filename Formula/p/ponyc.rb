class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https:www.ponylang.io"
  url "https:github.componylangponyc.git",
      tag:      "0.58.7",
      revision: "5520c88f99321868e99869371568b42361f486be"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74467e96e8ad256189b439f4539c07d4951f55d8fa9ec9f8c45cd10b6a7f811d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b35bcd81da005cba8d97ec8874996941430719f94f752a19e0ed3ddb67b809d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47aab7c021bf216c19649896e2023ebfbfe62bf425e00c4cfd3d0150e51f2bfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "294b9f87956c0283a30fcb001570aeef9f04d1a3c05e2d1b94a0fdcf0911d4c9"
    sha256 cellar: :any_skip_relocation, ventura:       "7ec72690695b618867f51f2802a01b3d67aec5dabaf48e025f06e50b025f1fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c460471cb83bb45b13c932b42725f02872ad44d61f45498df9f5b73979da00bb"
  end

  depends_on "cmake" => :build

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<~EOS
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

    system bin"ponyc", "-rexpr", "#{prefix}packagesstdlib"

    (testpath"testmain.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system bin"ponyc", "test"
    assert_equal "Hello World!", shell_output(".test1").strip
  end
end