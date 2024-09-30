class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https:github.comc3langc3c"
  url "https:github.comc3langc3carchiverefstagsv0.6.2.tar.gz"
  sha256 "e39f98d5a78f9d3aa8da4ce07062b4ca93d25b88107961cbd3af2b3f6bcf8e78"
  license "LGPL-3.0-only"
  revision 2
  head "https:github.comc3langc3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_sequoia: "d488a63b27a6a18fe9e59c311134825cacfef3619ea91da0735b47d29930b5cf"
    sha256 cellar: :any, arm64_sonoma:  "8edab84fb832b61e809264d3291c61a173feddaa97ca7d769646cb2f76e7b480"
    sha256 cellar: :any, arm64_ventura: "50055c81de8b6863611c6a9e865b84676127fa75666e657d7216cd85ad6602af"
    sha256 cellar: :any, sonoma:        "23781283ba1e2d5cf7298d0f5f05289257c5e0d364bdf89514051fc2918a84de"
    sha256 cellar: :any, ventura:       "8a51c9cf989584c5aa0d496d45f9d6a4ba355341c507cb5f239f89231082ed5c"
    sha256               x86_64_linux:  "4036b3f850ea5debfe6da393675295ae920c3b3ccb6900e5877324edb1addcf9"
  end

  depends_on "cmake" => :build
  depends_on "lld"
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Linking dynamically with LLVM fails with GCC.
  fails_with :gcc

  def install
    args = [
      "-DC3_LINK_DYNAMIC=ON",
      "-DC3_USE_MIMALLOC=OFF",
      "-DC3_USE_TB=OFF",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
      "-DLLVM=#{Formula["llvm"].opt_libshared_library("libLLVM")}",
      "-DLLD_COFF=#{Formula["lld"].opt_libshared_library("liblldCOFF")}",
      "-DLLD_COMMON=#{Formula["lld"].opt_libshared_library("liblldCommon")}",
      "-DLLD_ELF=#{Formula["lld"].opt_libshared_library("liblldELF")}",
      "-DLLD_MACHO=#{Formula["lld"].opt_libshared_library("liblldMachO")}",
      "-DLLD_MINGW=#{Formula["lld"].opt_libshared_library("liblldMinGW")}",
      "-DLLD_WASM=#{Formula["lld"].opt_libshared_library("liblldWasm")}",
    ]

    ENV.append "LDFLAGS", "-lzstd -lz"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # The build copies LLVM runtime libraries into its `bin` directory.
    # Let's replace those copies with a symlink instead.
    libexec.install bin.children
    bin.install_symlink libexec.children.select { |child| child.file? && child.executable? }
    rm_r libexec"c3c_rt"
    llvm = Formula["llvm"]
    libexec.install_symlink llvm.opt_lib"clang"llvm.version.major"libdarwin" => "c3c_rt"
  end

  test do
    (testpath"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}test")
  end
end