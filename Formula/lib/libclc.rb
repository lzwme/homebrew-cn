class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.4/libclc-21.1.4.src.tar.xz"
  sha256 "2311128b86ae95b4319341671a8ec93950928d0bc4fa13d0e6a97d7a65507aaa"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae84a6b94c69a14cd7f470adccacf0a1eee8ef73b51a3ea31e2caf067d7cdf13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae84a6b94c69a14cd7f470adccacf0a1eee8ef73b51a3ea31e2caf067d7cdf13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae84a6b94c69a14cd7f470adccacf0a1eee8ef73b51a3ea31e2caf067d7cdf13"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae84a6b94c69a14cd7f470adccacf0a1eee8ef73b51a3ea31e2caf067d7cdf13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae84a6b94c69a14cd7f470adccacf0a1eee8ef73b51a3ea31e2caf067d7cdf13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81874b58f448c350f25ee580b1075e8e77558c29f823ad449eaec9a8946bf26c"
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