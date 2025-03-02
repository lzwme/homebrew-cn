class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https:www.ponylang.io"
  url "https:github.componylangponyc.git",
      tag:      "0.58.12",
      revision: "a3a8dfea4e0a677b35bf0b453730029bd3ed3bb1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dbf122a9d26a17c3bbf26f291afc99bce8960bbdfbbeabeb92c07c5e2221ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a38f361eafc8b42a47bcdbfd3a67623cd7452ca6c0fe10f1387e5a7418fb8e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "423ab7ffa4d1cd22d4d29536d58512b8e366a158b19a37f139cd9304099fa89f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f9b820b9908876c951958520faf2a2443c40851709866b8c677113ff7808bba"
    sha256 cellar: :any_skip_relocation, ventura:       "950be014ac6b1606dbdca3e2fad01e08d4a691ed58da2ccd1d43ba585867e0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe3efbfad06fd8e73ee0b56f528f3f03916350b102d60f108c55b74763ed67d"
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

    (testpath"testmain.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin"ponyc", "test"
    assert_equal "Hello World!", shell_output(".test1").strip
  end
end