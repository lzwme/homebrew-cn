class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://ghfast.top/https://github.com/c3lang/c3c/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "2d5fd6b0757549062af5162516b4715bf9af693de683cc9d8b1e81306432278b"
  license "LGPL-3.0-only"
  head "https://github.com/c3lang/c3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9474c09936af323ffe8079d408f58b005f4285fa719e463e2d4c388376d212f"
    sha256 cellar: :any,                 arm64_sequoia: "a4533e634978fa827e8f8aa1811ebb146c106a191f4bb901cabb0c1421965757"
    sha256 cellar: :any,                 arm64_sonoma:  "0ce8022328b926ccd7c30178ee811418b929bda1bc9a0d5b4196720dd8fc5eba"
    sha256 cellar: :any,                 sonoma:        "90501205402d067e4bd39f3602b10a9f281946c166121430b48d150f2c7395d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a770911ac6c9694cdf6655eda29a81b3e83b9f7b697058cdc55c330e4fe523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f47851237779fa5383e7b4fc2f868b1b4680e7b716f02802e9d9b2888566930e"
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