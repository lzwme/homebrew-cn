class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https:github.comKhronosGroupSPIRV-LLVM-Translator"
  url "https:github.comKhronosGroupSPIRV-LLVM-Translatorarchiverefstagsv19.1.0.tar.gz"
  sha256 "2e64231db8646d8c220d44136712549b5d4c4194c6ce0e57c4f5ab342beee9a2"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b98f214b493c4923f8404e662321ff0e0946cc6a13deab71132052b7356b559"
    sha256 cellar: :any,                 arm64_sonoma:  "489b8d9d57221a75d790c4dacb37a08de3e69dc93b14d413a5a5a5409783680f"
    sha256 cellar: :any,                 arm64_ventura: "02bd03a07e219281b557e6774d3fd24d5859c776fafd3c145a52afb1f8a41eef"
    sha256 cellar: :any,                 sonoma:        "1319a331c15041133d588459d477c8560d6a2322eb2febd6e0d536f479ff9616"
    sha256 cellar: :any,                 ventura:       "fcca22e86795849db9f1aeb0470743e34a8ce62abefe8aeaa4ee233f57980dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b6346ed7638882655be66794959cda5e2874875c036b0c31a07d61ae3ba891"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "spirv-headers" => :build
  depends_on "llvm"

  # See https:gcc.gnu.orgbugzillashow_bug.cgi?id=56480
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    system "cmake", "-S", ".", "-B", "build",
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
    assert_predicate testpath"test.spv", :exist?
  end
end