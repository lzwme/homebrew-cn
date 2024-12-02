class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https:github.comKhronosGroupSPIRV-LLVM-Translator"
  url "https:github.comKhronosGroupSPIRV-LLVM-Translatorarchiverefstagsv19.1.2.tar.gz"
  sha256 "67be5fd119a0a575b82289f870064198484eb41f0591f557166a6c1884c906bf"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "44ce6e5219100530d9bad16c6e0b2f5fe2b3207ff96028359981c5ad242dacb7"
    sha256 cellar: :any,                 arm64_sonoma:  "1d7482b7aca002c037aa5bab906af1c1d96e53487db05cb2ab26ea19d3e2ad72"
    sha256 cellar: :any,                 arm64_ventura: "bca69e1f11b7708d07a679f61b5e4d8866f807061fa73f20725e551ec9ab9b89"
    sha256 cellar: :any,                 sonoma:        "f0b2114e4c8d55b04963b0d798f8b348757233b4802ba15e3a93515b39419b44"
    sha256 cellar: :any,                 ventura:       "78edc059eced747b6daa71bfaefdd147034032f15e7f80e274b16caa9e7fb827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a5d9eb6e00bec535f8724b120457c505b71b97b30539fbbfd3aad60cc1ea1f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "spirv-headers" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLLVM_BUILD_TOOLS=ON",
                    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=#{Formula["spirv-headers"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.ll").write <<~EOS
      target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
      target triple = "spir64-unknown-unknown"

      define spir_kernel void @foo() {
        ret void
      }
    EOS
    system llvm.opt_bin"llvm-as", "test.ll"
    system bin"llvm-spirv", "test.bc"
    assert_path_exists testpath"test.spv"
  end
end