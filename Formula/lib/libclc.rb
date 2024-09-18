class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.0libclc-19.1.0.src.tar.xz"
  sha256 "85bccf65c429a22367c73accac7c4c2d9586f1b2ce036b3395b3debc3867e932"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc0b9ef83c06e113afcfa2f5294bbfbea3ac9c4919c3ac9340b28f62b6a1701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc0b9ef83c06e113afcfa2f5294bbfbea3ac9c4919c3ac9340b28f62b6a1701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bc0b9ef83c06e113afcfa2f5294bbfbea3ac9c4919c3ac9340b28f62b6a1701"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bc0b9ef83c06e113afcfa2f5294bbfbea3ac9c4919c3ac9340b28f62b6a1701"
    sha256 cellar: :any_skip_relocation, ventura:       "7bc0b9ef83c06e113afcfa2f5294bbfbea3ac9c4919c3ac9340b28f62b6a1701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2b1d9c725fc796be615bd2e5aacb5f055050b9a113b7864981649fa80c6fffc"
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