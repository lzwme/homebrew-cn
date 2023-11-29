class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/libclc-17.0.6.src.tar.xz"
  sha256 "122f641d94d5dfbb3c37534f2b76612fa59d15c36c2a4917369a85eaaca32148"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9b401e7ac7a4c60545a672ce19bc9f3f14ac6b70ceca4835c135e29657a9127"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9b401e7ac7a4c60545a672ce19bc9f3f14ac6b70ceca4835c135e29657a9127"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9b401e7ac7a4c60545a672ce19bc9f3f14ac6b70ceca4835c135e29657a9127"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9b401e7ac7a4c60545a672ce19bc9f3f14ac6b70ceca4835c135e29657a9127"
    sha256 cellar: :any_skip_relocation, ventura:        "a9b401e7ac7a4c60545a672ce19bc9f3f14ac6b70ceca4835c135e29657a9127"
    sha256 cellar: :any_skip_relocation, monterey:       "a9b401e7ac7a4c60545a672ce19bc9f3f14ac6b70ceca4835c135e29657a9127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d12d969c9fab6386e7fdce428c86149e8cfe9d36cc08637ca639646dbb2ced"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
  end
end