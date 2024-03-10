class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.1libclc-18.1.1.src.tar.xz"
  sha256 "ad0c98e623a8f73a4af3b243aa8157b3cecfd6b30cd696961325d68af0549f64"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b8b55531c5bb18c21c80e296d133b90d592d8b81626d595812fbecdcbf0dfd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b8b55531c5bb18c21c80e296d133b90d592d8b81626d595812fbecdcbf0dfd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b8b55531c5bb18c21c80e296d133b90d592d8b81626d595812fbecdcbf0dfd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b8b55531c5bb18c21c80e296d133b90d592d8b81626d595812fbecdcbf0dfd8"
    sha256 cellar: :any_skip_relocation, ventura:        "1b8b55531c5bb18c21c80e296d133b90d592d8b81626d595812fbecdcbf0dfd8"
    sha256 cellar: :any_skip_relocation, monterey:       "1b8b55531c5bb18c21c80e296d133b90d592d8b81626d595812fbecdcbf0dfd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ff78604be14f231026cac2c6e1a6aa198130ae9dfcc469bc7d5b021c7dab4d"
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