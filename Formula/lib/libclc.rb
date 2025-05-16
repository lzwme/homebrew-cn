class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.5libclc-20.1.5.src.tar.xz"
  sha256 "7aabcc31eff12bc54778c38752192939df8d983002c961cb1ac97f57e50ccff1"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bfc4156222dfcef2378951f8d8e7825b040c4bd7bc6aee3b2c5e0351dce0408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bfc4156222dfcef2378951f8d8e7825b040c4bd7bc6aee3b2c5e0351dce0408"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bfc4156222dfcef2378951f8d8e7825b040c4bd7bc6aee3b2c5e0351dce0408"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bfc4156222dfcef2378951f8d8e7825b040c4bd7bc6aee3b2c5e0351dce0408"
    sha256 cellar: :any_skip_relocation, ventura:       "5bfc4156222dfcef2378951f8d8e7825b040c4bd7bc6aee3b2c5e0351dce0408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bfc4156222dfcef2378951f8d8e7825b040c4bd7bc6aee3b2c5e0351dce0408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91c6dbbb914a3f24ca32b20f59cbeaa8ab7ca800fe240ab4ecdf6af48d81d54f"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share"pkgconfiglibclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}clcnvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin"clang", *clang_args, ".add_sat.cl"
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}llvm-dis .add_sat.bc -o -")
  end
end