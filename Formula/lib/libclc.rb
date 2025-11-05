class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.5/libclc-21.1.5.src.tar.xz"
  sha256 "1fc88ddae5965b66e94de74fb294b7dfdf5827f3abb22a8657e8e03c6c9b381f"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7715b89992ec876f0f57ac164b91eca8a9f3d11d61487c3d112b3e9a01db401b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7715b89992ec876f0f57ac164b91eca8a9f3d11d61487c3d112b3e9a01db401b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7715b89992ec876f0f57ac164b91eca8a9f3d11d61487c3d112b3e9a01db401b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7715b89992ec876f0f57ac164b91eca8a9f3d11d61487c3d112b3e9a01db401b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7715b89992ec876f0f57ac164b91eca8a9f3d11d61487c3d112b3e9a01db401b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eefd98ae374b6c5676dd5574fa6388d3e70881b4a8bb9519f1e19d776b01eba"
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