class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https:github.comc3langc3c"
  url "https:github.comc3langc3carchiverefstagsv0.6.5.tar.gz"
  sha256 "e232344bf5fea87bebab3173a89d3414d7c0d1bab695f15e4b8f99d7bfaceb06"
  license "LGPL-3.0-only"
  head "https:github.comc3langc3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ef26d694347066ad9580cd148994affb8cecd10bc59b4d2301f12af0b95937f7"
    sha256 cellar: :any, arm64_sonoma:  "fc6130e48bbd19a31e559002c8d394ab8269fae17072816e8b45b5588c477fc4"
    sha256 cellar: :any, arm64_ventura: "8a1bb245fdaada56e63803cee75e94ebeefa7d3b5be2b2137cc2c234831761fc"
    sha256 cellar: :any, sonoma:        "6148ebda35d3ffeca59e942c65b965d4f5439a6c3c570c0a844468ff6b29a768"
    sha256 cellar: :any, ventura:       "79f02a1a38ff0f153188955e058edb47ce1c907acb75085302a057dac71d7b5c"
    sha256               x86_64_linux:  "d3f9f880e762f11586661c29dd980497b0c21735eea8aeea219e66709a830925"
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