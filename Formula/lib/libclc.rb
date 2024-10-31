class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https:libclc.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.3libclc-19.1.3.src.tar.xz"
  sha256 "b49fab401aaa65272f0480f6d707a9a175ea8e68b6c5aa910457c4166aa6328f"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89112655124692416a9288c515af4c390bce661327d4fcc89dcb42cfd2af959b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89112655124692416a9288c515af4c390bce661327d4fcc89dcb42cfd2af959b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89112655124692416a9288c515af4c390bce661327d4fcc89dcb42cfd2af959b"
    sha256 cellar: :any_skip_relocation, sonoma:        "89112655124692416a9288c515af4c390bce661327d4fcc89dcb42cfd2af959b"
    sha256 cellar: :any_skip_relocation, ventura:       "89112655124692416a9288c515af4c390bce661327d4fcc89dcb42cfd2af959b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b19b67f106a9803f326cf66bed7ee9158ac41a3f2dbc6f9510d71962cd3d6af"
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