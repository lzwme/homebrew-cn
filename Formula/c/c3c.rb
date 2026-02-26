class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://ghfast.top/https://github.com/c3lang/c3c/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "d9867c80e9dea5a96badd7c88937e155ead31f3dc6aa0758010ce0734877d17b"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/c3lang/c3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "75db4fd26a35a994b38fdc355687c178a2534b91b29aee1c4ebcaf2cccae5631"
    sha256 cellar: :any,                 arm64_sequoia: "c29ed6db61145bfecd814f0282c714d535ecfe137059b81470a90f35500378a2"
    sha256 cellar: :any,                 arm64_sonoma:  "1b337ce43b666888056594646bfa5bb2b43b4e7f9ad928626ee813d16b89a2e7"
    sha256 cellar: :any,                 sonoma:        "1ca708ab4d74fb62f739843a96b3f7cee84218fa3753be5f08682a9417fbe879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f1113d1e81e0fd414418dc37b9d52378c66c7107aea48a678e4da1cd1819c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5a17aec2c7421b8342f6ba2e58f271d689e947350bf60eaa818f79481a39f8a"
  end

  depends_on "cmake" => :build
  depends_on "lld@21"
  depends_on "llvm@21"

  uses_from_macos "curl"

  def install
    lld = Formula["lld@21"]
    llvm = Formula["llvm@21"]

    args = [
      "-DC3_LINK_DYNAMIC=ON",
      "-DC3_USE_MIMALLOC=OFF",
      "-DC3_USE_TB=OFF",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
      "-DLLVM=#{llvm.opt_lib/shared_library("libLLVM")}",
      "-DLLD_COFF=#{lld.opt_lib/shared_library("liblldCOFF")}",
      "-DLLD_COMMON=#{lld.opt_lib/shared_library("liblldCommon")}",
      "-DLLD_ELF=#{lld.opt_lib/shared_library("liblldELF")}",
      "-DLLD_MACHO=#{lld.opt_lib/shared_library("liblldMachO")}",
      "-DLLD_MINGW=#{lld.opt_lib/shared_library("liblldMinGW")}",
      "-DLLD_WASM=#{lld.opt_lib/shared_library("liblldWasm")}",
    ]
    args << "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # The build copies LLVM runtime libraries into its `bin` directory.
    # Let's replace those copies with a symlink instead.
    libexec.install bin.children
    bin.install_symlink libexec.children.select { |child| child.file? && child.executable? }
    rm_r libexec/"c3c_rt"
    libexec.install_symlink llvm.opt_lib/"clang"/llvm.version.major/"lib/darwin" => "c3c_rt"
  end

  test do
    (testpath/"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end