class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https:www.ponylang.io"
  url "https:github.componylangponyc.git",
      tag:      "0.58.0",
      revision: "a161b7c97666f820bbacbb328d95dc820f353edd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "168e58b69895afdd7126a664cf8aa8e7bbc1456ca8d1a62cba7caeae03731493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f511583c161f1076b34288b778d01e03697627b22e63a3b323629fc3ac5a84a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0171c02bd241b4f9ae682cd3a1be98d6a0e2e2178659b3c88ec0abcea24702bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e019e470d42c29c8ec6406d467ad87629248c0a6734d5e14f03f5b0520c1525c"
    sha256 cellar: :any_skip_relocation, ventura:        "1de5358be7775545b8a412990fecbd8427408032586ca803c02ff69cef58b3c0"
    sha256 cellar: :any_skip_relocation, monterey:       "09b08be2958e0e9911113e7f4ca3423a10042a3a6c6343133f2dc939846d7a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1373acf0b7066045f2957f232180fe51030954412f72abd1b113baccab0c7fa0"
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