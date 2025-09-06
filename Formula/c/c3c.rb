class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://ghfast.top/https://github.com/c3lang/c3c/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "11ac63dde96e0458becf072126555eaa818a117f388f7f3c92330e1220096418"
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
    sha256 cellar: :any,                 arm64_sequoia: "e360b9f4b170344b6c20d3345bca8240a69b82ec78ced5340da330344b521edb"
    sha256 cellar: :any,                 arm64_sonoma:  "dea64f6da845b5aa4579745f82fb74d8f9850ab93c8ac4d0d91d79861d307bde"
    sha256 cellar: :any,                 arm64_ventura: "7136c6295ba01a79492b2a034b7443eb54141a8194728577e97c5eb5bc1199e3"
    sha256 cellar: :any,                 sonoma:        "89d197f2cf347e4134d09472abc105674b7be9deff7820a875e562a91416585c"
    sha256 cellar: :any,                 ventura:       "4fcb0dcdc064f502a4b345c70ffe19d316d393e7732fc9218dbca46b9d49be34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a42dbb3104b385594f63bdecb4580a0c2a14937854439936ffc12991db978efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "843d035987148fc169211c4af85011969d62aaee18ce2688a09db1d3d31306cb"
  end

  depends_on "cmake" => :build
  depends_on "lld@20"
  depends_on "llvm@20"

  uses_from_macos "curl"

  def install
    lld = Formula["lld@20"]
    llvm = Formula["llvm@20"]

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