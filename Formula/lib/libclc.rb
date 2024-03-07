class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.0libclc-18.1.0.src.tar.xz"
  sha256 "a2faf505c8c1703c21a2999a10b0f0b4d24180f407b1cafe8d08d04cedc30e5b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bc54bee1499f05f592843585ac909a10da2220f368d26f360c01cfa39280058"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bc54bee1499f05f592843585ac909a10da2220f368d26f360c01cfa39280058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bc54bee1499f05f592843585ac909a10da2220f368d26f360c01cfa39280058"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bc54bee1499f05f592843585ac909a10da2220f368d26f360c01cfa39280058"
    sha256 cellar: :any_skip_relocation, ventura:        "5bc54bee1499f05f592843585ac909a10da2220f368d26f360c01cfa39280058"
    sha256 cellar: :any_skip_relocation, monterey:       "5bc54bee1499f05f592843585ac909a10da2220f368d26f360c01cfa39280058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82691a4feabbcffc1ffe1932d16d82c8283d2324d003014fc17e8d605f51ce36"
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