class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https:www.ponylang.io"
  url "https:github.componylangponyc.git",
      tag:      "0.58.8",
      revision: "096db524fbf4b07f84b0548b90de4ea43e0aab7e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df221575035ca77e581c6c791a7a901f7d3b7120603b685c7167422c710b59f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a1c1d82fde2e5d6f4d17b44ff22d910fdac1d43364e40a9a6b221c0764c1b3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9675ed301be311c73ebd5beafa67989ae93ca26d20c5ec21c638fb8049abc67f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8ca64310790fa518b28e0b42e7aa67b6b5783143f72b1d6b12bf14a6d4dcff3"
    sha256 cellar: :any_skip_relocation, ventura:       "e8a3fc17a3b5b97204231e856774e787df0f5a967fcbd9af2e4a9fc0bfec6050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559cd467f0af3b3052390b6d32d51856ba0e3b04c4cd1a14443e85e243a53039"
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