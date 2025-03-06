class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.0libclc-20.1.0.src.tar.xz"
  sha256 "02ee864c9974268509d3777e8f15bb3ebb2cc4ffe456d9aa79a352c5788c15a8"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ebc0a82779249a9c4e393477ce3faa74c859341b8717a5a77bb1619a3652f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15ebc0a82779249a9c4e393477ce3faa74c859341b8717a5a77bb1619a3652f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15ebc0a82779249a9c4e393477ce3faa74c859341b8717a5a77bb1619a3652f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ebc0a82779249a9c4e393477ce3faa74c859341b8717a5a77bb1619a3652f2"
    sha256 cellar: :any_skip_relocation, ventura:       "15ebc0a82779249a9c4e393477ce3faa74c859341b8717a5a77bb1619a3652f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c5acd4cbd601238e25000b4e2872d9b3bd8e38e415f51d69fc1d63b2239fa2e"
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