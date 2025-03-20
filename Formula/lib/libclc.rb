class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.1libclc-20.1.1.src.tar.xz"
  sha256 "1162711df15884ae97e1aca9b3e9947e91eafca23f6f058b74c4e1bfef8cc2b6"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11365f93f58ece1a4287064bf5593c14c4dfd48a69a9932fa8d340c6bdce3e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11365f93f58ece1a4287064bf5593c14c4dfd48a69a9932fa8d340c6bdce3e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11365f93f58ece1a4287064bf5593c14c4dfd48a69a9932fa8d340c6bdce3e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "11365f93f58ece1a4287064bf5593c14c4dfd48a69a9932fa8d340c6bdce3e5c"
    sha256 cellar: :any_skip_relocation, ventura:       "11365f93f58ece1a4287064bf5593c14c4dfd48a69a9932fa8d340c6bdce3e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b59909210f0e9dde8d8da1da69f2002f07002e0bd2d2e8a24bc3673f5af15f"
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