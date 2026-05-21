class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.6/llvm-project-22.1.6.src.tar.xz"
  sha256 "6e0b376a1f6d9873e7dfb09ae6e04b9c7024400f01733fa4c29be69d5c138bc2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0e5ca29bf5f066423aed16cbad1ddc208ac44ed8a583f6d9483693f474fd83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0e5ca29bf5f066423aed16cbad1ddc208ac44ed8a583f6d9483693f474fd83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc0e5ca29bf5f066423aed16cbad1ddc208ac44ed8a583f6d9483693f474fd83"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc0e5ca29bf5f066423aed16cbad1ddc208ac44ed8a583f6d9483693f474fd83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc0e5ca29bf5f066423aed16cbad1ddc208ac44ed8a583f6d9483693f474fd83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83818b1636c6e467ce61b51cc8861ccb77c5241edde7ac5858a1bfed0899c1c"
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