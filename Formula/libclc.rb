class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/libclc-16.0.3.src.tar.xz"
  sha256 "b8f11158cd298062602285391496bb2acaf7219923fdd13b93927753c491e7c1"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7e7a45d8c7df305449d1082b281ec250762eef12c0219fce56904635f68a2b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7e7a45d8c7df305449d1082b281ec250762eef12c0219fce56904635f68a2b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7e7a45d8c7df305449d1082b281ec250762eef12c0219fce56904635f68a2b6"
    sha256 cellar: :any_skip_relocation, ventura:        "f7e7a45d8c7df305449d1082b281ec250762eef12c0219fce56904635f68a2b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f7e7a45d8c7df305449d1082b281ec250762eef12c0219fce56904635f68a2b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7e7a45d8c7df305449d1082b281ec250762eef12c0219fce56904635f68a2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1294b05ecd01ca464cfd8e001b19312775c6db69d50cf9858bfd58ebb02ce84e"
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