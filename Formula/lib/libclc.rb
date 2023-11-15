class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/libclc-17.0.5.src.tar.xz"
  sha256 "08de715d000d551c2587d6c30cafb0a11ecd89b765429847570d14e6f1f93249"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc5749ee5702e820b398e8c7a86658738953e26ad4b27cc714e81b9647f88bb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc5749ee5702e820b398e8c7a86658738953e26ad4b27cc714e81b9647f88bb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc5749ee5702e820b398e8c7a86658738953e26ad4b27cc714e81b9647f88bb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc5749ee5702e820b398e8c7a86658738953e26ad4b27cc714e81b9647f88bb0"
    sha256 cellar: :any_skip_relocation, ventura:        "fc5749ee5702e820b398e8c7a86658738953e26ad4b27cc714e81b9647f88bb0"
    sha256 cellar: :any_skip_relocation, monterey:       "fc5749ee5702e820b398e8c7a86658738953e26ad4b27cc714e81b9647f88bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca4047d568ec857c9d8faba879caa2117b158c1c865d9b9ebab4add35090b59"
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
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
  end
end