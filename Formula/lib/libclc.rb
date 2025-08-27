class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.0/libclc-21.1.0.src.tar.xz"
  sha256 "1fa36516a5bd56fd2bd4e6d327a85b6ee226747a79a17b004fc1a09933376743"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c42a66d132343fe931a0f63fc84c5f33fce1401b314dd6cc9308b6c9b18d8332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c42a66d132343fe931a0f63fc84c5f33fce1401b314dd6cc9308b6c9b18d8332"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c42a66d132343fe931a0f63fc84c5f33fce1401b314dd6cc9308b6c9b18d8332"
    sha256 cellar: :any_skip_relocation, sonoma:        "c42a66d132343fe931a0f63fc84c5f33fce1401b314dd6cc9308b6c9b18d8332"
    sha256 cellar: :any_skip_relocation, ventura:       "c42a66d132343fe931a0f63fc84c5f33fce1401b314dd6cc9308b6c9b18d8332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42a66d132343fe931a0f63fc84c5f33fce1401b314dd6cc9308b6c9b18d8332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cbb7c69a2fcc5955f2d4f4fbba7a8b62d4d59a4e55991b6497a12c45bb40e2c"
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