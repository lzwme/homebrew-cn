class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://ghfast.top/https://github.com/c3lang/c3c/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "410267a3d771ac4b4d6bcc29be0faf30d4959c24b31f9d1bd00661656072dc2b"
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
    sha256 cellar: :any,                 arm64_sequoia: "6c6831e67b3dad521d8c952587f054c675416f72fe1df21cb5bc6d75a4c4c39b"
    sha256 cellar: :any,                 arm64_sonoma:  "7cb8c949acc82ab4d2a3f4279e294a353979fda24c427ddba0678cd8f42cc94b"
    sha256 cellar: :any,                 arm64_ventura: "5b8ba42df1119e4e12ca6d5875fb1a40b575052e8770d01050042bd9481a128f"
    sha256 cellar: :any,                 sonoma:        "a88eee60a639b90a3affa3d6d53e3f688beaca668ce4e80453da6fd627092a67"
    sha256 cellar: :any,                 ventura:       "5acba9a1b246a4d3570bb96979c9ed980cec990deabc27085c56b1f07e7b0e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0906c3318ecfc1939351517388b35075a30e80bfce62171ecb2a762bf9f0ddc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f323f8a473cdeb8360441d31e160b9026fd5085da47d8a02a3b4318b48378af9"
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