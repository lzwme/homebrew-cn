class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.6libclc-18.1.6.src.tar.xz"
  sha256 "adb73f49798cc271216ca7368da6991d5562efe7cffe2ad42d411bfa4a5c66dc"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4b471f7ae123958a7ab2b061ebb893fd72af7e77f23a1aa6be3e2dca58ea08c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4b471f7ae123958a7ab2b061ebb893fd72af7e77f23a1aa6be3e2dca58ea08c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4b471f7ae123958a7ab2b061ebb893fd72af7e77f23a1aa6be3e2dca58ea08c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4b471f7ae123958a7ab2b061ebb893fd72af7e77f23a1aa6be3e2dca58ea08c"
    sha256 cellar: :any_skip_relocation, ventura:        "c4b471f7ae123958a7ab2b061ebb893fd72af7e77f23a1aa6be3e2dca58ea08c"
    sha256 cellar: :any_skip_relocation, monterey:       "c4b471f7ae123958a7ab2b061ebb893fd72af7e77f23a1aa6be3e2dca58ea08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2ede2370c2bc7120fcd30c17e10bc68e5e9b1367441c6b01d9251e7efea8718"
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