class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.0/llvm-project-22.1.0.src.tar.xz"
  sha256 "25d2e2adc4356d758405dd885fcfd6447bce82a90eb78b6b87ce0934bd077173"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38e4a66e44ae6e47041cdc211f538cc2346a892cd3e5dcab1580f00c974a1d75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38e4a66e44ae6e47041cdc211f538cc2346a892cd3e5dcab1580f00c974a1d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38e4a66e44ae6e47041cdc211f538cc2346a892cd3e5dcab1580f00c974a1d75"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e4a66e44ae6e47041cdc211f538cc2346a892cd3e5dcab1580f00c974a1d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38e4a66e44ae6e47041cdc211f538cc2346a892cd3e5dcab1580f00c974a1d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42fb758912ea56012072ee1f48e8e11fc6ae3399b4261bc9af0306610611a8de"
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