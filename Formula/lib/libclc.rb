class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.3/libclc-21.1.3.src.tar.xz"
  sha256 "7ec2e1207739d617580a3585549c55cd73e44a6565e39e074344df41e5253868"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd2ae5de5484143457e99afefc23657cc070fefe9a0a1fe352bc1efb01b96a7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd2ae5de5484143457e99afefc23657cc070fefe9a0a1fe352bc1efb01b96a7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd2ae5de5484143457e99afefc23657cc070fefe9a0a1fe352bc1efb01b96a7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd2ae5de5484143457e99afefc23657cc070fefe9a0a1fe352bc1efb01b96a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd2ae5de5484143457e99afefc23657cc070fefe9a0a1fe352bc1efb01b96a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42afca736e7b367c2bb86c7d0051b993c2f8f9170ef29ad3aa912f5270c3a8c1"
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
    ir = shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
    assert_match('target triple = "nvptx-unknown-nvidiacl"', ir)
    assert_match(/define .* @foo\(/, ir)
  end
end