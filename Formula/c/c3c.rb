class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https:github.comc3langc3c"
  url "https:github.comc3langc3carchiverefstagsv0.6.4.tar.gz"
  sha256 "26d67aa10bf54278b5b3fe6fead1ba95d086af89e56f01f3ccd65ca9a8009339"
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
    sha256 cellar: :any, arm64_sequoia: "f433b9e6d211285a7ae833a407756bc695bb9506faf3cbf9fd2a13a0435650ea"
    sha256 cellar: :any, arm64_sonoma:  "ad59c2e95cd71b22a5b9c9517d4aa8e68008b0f6ffe228f5e2b2057af07909f3"
    sha256 cellar: :any, arm64_ventura: "10575c80370a8f4179c7a24a7210b3fefba4077c00340ea6261f48fbb1bc4c71"
    sha256 cellar: :any, sonoma:        "04b13cede3306c56b05c6432b6d54c99e59c92673801f4b9717be204dfe4323c"
    sha256 cellar: :any, ventura:       "c6384da2f9ba750a0febda2954282c75abadd67b2332bbf3c96a3c2d485778c5"
    sha256               x86_64_linux:  "963de4571c150b77247bdb4534a25fe818d4a6d1dfbaf6ed26ca837d350de921"
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