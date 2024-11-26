class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https:github.comKhronosGroupSPIRV-LLVM-Translator"
  url "https:github.comKhronosGroupSPIRV-LLVM-Translatorarchiverefstagsv19.1.1.tar.gz"
  sha256 "7f6f7a1af0eb40910ddf3a7647d2186c8c5dc5a47945afa935aeec56bacf4336"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62d76c96df71b0aa9f7257c036ff8d8342e13380433e1daa273e7d2454d0aff2"
    sha256 cellar: :any,                 arm64_sonoma:  "4aad85a9f27af462b66cfcea86dffb97512d473f3cd9080cc9afeae2b67d0d86"
    sha256 cellar: :any,                 arm64_ventura: "eb001b3a78850766e51973ab4ff11c2c17e4c7614c33c95158404f5b94a75662"
    sha256 cellar: :any,                 sonoma:        "57b763cbe611d7337efcefddff2726dc20f310040671490cdb52fed6711dbd05"
    sha256 cellar: :any,                 ventura:       "d202af3ab5a2eede7ab4b6f376548ff8fcbc7620684f06af7c4d7253a0fa56dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3963067069c2ca89dc384241a9e01cc3edb91e558ea7684eb9cc67a3abf5fcf7"
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