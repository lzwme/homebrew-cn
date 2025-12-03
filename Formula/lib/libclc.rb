class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.7/libclc-21.1.7.src.tar.xz"
  sha256 "de1c8dbffdce898a4c5e70fb7f5aa6dea1e429f63471773da8cb3cdf9e945403"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf9eb311a85996dea23d8887e8c4b68fd2a42b9f51500dd0a17f55a8cd1a747b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf9eb311a85996dea23d8887e8c4b68fd2a42b9f51500dd0a17f55a8cd1a747b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf9eb311a85996dea23d8887e8c4b68fd2a42b9f51500dd0a17f55a8cd1a747b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf9eb311a85996dea23d8887e8c4b68fd2a42b9f51500dd0a17f55a8cd1a747b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf9eb311a85996dea23d8887e8c4b68fd2a42b9f51500dd0a17f55a8cd1a747b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e031f965cdd5e279f3cd2bd4f7809ea5910f08f123ab61580906208c8f44da42"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    ir = shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
    assert_match('target triple = "nvptx-unknown-nvidiacl"', ir)
    assert_match(/define .* @foo\(/, ir)
  end
end