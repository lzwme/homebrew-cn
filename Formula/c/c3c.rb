class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https:github.comc3langc3c"
  url "https:github.comc3langc3carchiverefstagsv0.6.8.tar.gz"
  sha256 "f84cb31954100e8b9af67e6d8f8ab66526964c07230c1cbc4ab9a16102d84562"
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
    sha256 cellar: :any, arm64_sequoia: "e8bbd2763c670ba8e2ace676eb18c7fc8ee03f42aaec19777ed230337ad778e8"
    sha256 cellar: :any, arm64_sonoma:  "e8d5ce6f914cb3ac611e76102eff6a81ab05180dabac63143d7abe8cccdfe0b7"
    sha256 cellar: :any, arm64_ventura: "f22286709d993d82e0f93b268a12eb648dfe1b71a23a9aad34d67ca5e58e15d8"
    sha256 cellar: :any, sonoma:        "9549e22881b981f11afc3bd3e003ce96948daf9efdd66a5ad7ea582193ab5f3e"
    sha256 cellar: :any, ventura:       "98d0dce27cd81b573d44cd823c904767ae2522b7bdac0d9b46aa5114dd409a98"
    sha256               x86_64_linux:  "265de4641c331430bdba1b940b0be1b31fd25f38d30f6c38473eb3099260a6c3"
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