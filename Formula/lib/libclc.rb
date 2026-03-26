class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.2/llvm-project-22.1.2.src.tar.xz"
  sha256 "62f2f13ff25b1bb28ea507888e858212d19aafb65e8e72b4a65ee0629ec4ae0c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e16de6eb361b027296ad2276caf549d8ae5c9a2bca673df619009a26b87aff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e16de6eb361b027296ad2276caf549d8ae5c9a2bca673df619009a26b87aff3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e16de6eb361b027296ad2276caf549d8ae5c9a2bca673df619009a26b87aff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e16de6eb361b027296ad2276caf549d8ae5c9a2bca673df619009a26b87aff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e16de6eb361b027296ad2276caf549d8ae5c9a2bca673df619009a26b87aff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0208db6ea68fb2f01a75d7237a4a307ea6e75dd643f33e4c052628c76c022dc"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", "libclc", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    (testpath/"add_sat.cl").write <<~C
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    C

    clang_args = %W[
      -target nvptx64--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx64--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    ir = shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
    assert_match('target triple = "nvptx64-unknown-nvidiacl"', ir)
    assert_match(/define .* @foo\(/, ir)
  end
end