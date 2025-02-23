class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https:www.ponylang.io"
  url "https:github.componylangponyc.git",
      tag:      "0.58.11",
      revision: "7110b5ee498cd617eb95818ac290dcc6b8b2a1fd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1d38a57bc750b39e095cae360b06be4a0a65528fa735b2d8c4ecccf6a9eb26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "331426a1d7de5af677bf8048d6028b3bc1b66445b88e9c3368b0997d243e423a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c30b0cf7587472c785c88b50fd299f4336fbb436763e6a5f1eb15326708e330b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f063326b659a535f61e0a89b2753c56b01eeb03774c1dd5b30dfc1ad679883f"
    sha256 cellar: :any_skip_relocation, ventura:       "fdf1f329342338752daf06b8b768813d4746b10c58dfa22b6cf11d8162798c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095046664c6c4eaa32719ded6ac7c90d398715eb326ad1f89ebc95662cf5b181"
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