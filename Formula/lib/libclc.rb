class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.4libclc-19.1.4.src.tar.xz"
  sha256 "d73969262195a0aef9643c80431f46061353c41021951bd96cf25e912cec5077"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "020834a7b15653d4e1fd3ceeb9eaaebca9c8948cc054c5633f337ab2b6c62c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "020834a7b15653d4e1fd3ceeb9eaaebca9c8948cc054c5633f337ab2b6c62c2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "020834a7b15653d4e1fd3ceeb9eaaebca9c8948cc054c5633f337ab2b6c62c2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "020834a7b15653d4e1fd3ceeb9eaaebca9c8948cc054c5633f337ab2b6c62c2a"
    sha256 cellar: :any_skip_relocation, ventura:       "020834a7b15653d4e1fd3ceeb9eaaebca9c8948cc054c5633f337ab2b6c62c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f08fca7c8ffaa532652b066f300eb67b3d12acefce84bda6152b6bfde899ad8"
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