class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.6libclc-19.1.6.src.tar.xz"
  sha256 "9fb7807c245b265cc1158105a52abaf8199a13834e2d2e94d742ce436a1e82d7"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e650a4a48a9b086daa704ac5fea47f5ab552cb9aee02d9ba47324a463db19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4e650a4a48a9b086daa704ac5fea47f5ab552cb9aee02d9ba47324a463db19f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4e650a4a48a9b086daa704ac5fea47f5ab552cb9aee02d9ba47324a463db19f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4e650a4a48a9b086daa704ac5fea47f5ab552cb9aee02d9ba47324a463db19f"
    sha256 cellar: :any_skip_relocation, ventura:       "d4e650a4a48a9b086daa704ac5fea47f5ab552cb9aee02d9ba47324a463db19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48bcec01c7418f3c60ec9d4d8a4a523b57674cc2a69ca30a330d3b1290e283dd"
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