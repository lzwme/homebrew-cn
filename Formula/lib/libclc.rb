class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.5libclc-19.1.5.src.tar.xz"
  sha256 "95ee4b8694fd7b1405d362b9ed758be3e88a81c9ee80c1e8433183f0ddde070e"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4c3e941d8bcef5c9f84161437e7c0d35f63c98e20f88dd125db91ed8b8d0b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b4c3e941d8bcef5c9f84161437e7c0d35f63c98e20f88dd125db91ed8b8d0b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b4c3e941d8bcef5c9f84161437e7c0d35f63c98e20f88dd125db91ed8b8d0b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b4c3e941d8bcef5c9f84161437e7c0d35f63c98e20f88dd125db91ed8b8d0b2"
    sha256 cellar: :any_skip_relocation, ventura:       "5b4c3e941d8bcef5c9f84161437e7c0d35f63c98e20f88dd125db91ed8b8d0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2deadf35baf81547213c75458f7f776d55d2c3797a63e6ef67030dcf10283e95"
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