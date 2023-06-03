class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.4/libclc-16.0.4.src.tar.xz"
  sha256 "eab42fbfe21f6c8034b03a40ccdd07f5a1e3cfa35e41366474ff0c9f5f33f96c"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e0a44b0ee7e6d2b5c0dc6ff422681c075d519bf54cac370e77b6e371e453e93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e0a44b0ee7e6d2b5c0dc6ff422681c075d519bf54cac370e77b6e371e453e93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0a44b0ee7e6d2b5c0dc6ff422681c075d519bf54cac370e77b6e371e453e93"
    sha256 cellar: :any_skip_relocation, ventura:        "5e0a44b0ee7e6d2b5c0dc6ff422681c075d519bf54cac370e77b6e371e453e93"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0a44b0ee7e6d2b5c0dc6ff422681c075d519bf54cac370e77b6e371e453e93"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e0a44b0ee7e6d2b5c0dc6ff422681c075d519bf54cac370e77b6e371e453e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c839fd229150b8c5d638c4926aa8b118a5ad4a987948d7a495f147d1457f8338"
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