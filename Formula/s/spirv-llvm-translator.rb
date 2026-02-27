class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://ghfast.top/https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.4.tar.gz"
  sha256 "e900c907b62f82cf541a611b33d6685f375fe3bda6f041087fcdba350ffb437d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49ae5180fca71957689214bd940514f18d64ceca1ec7802c6fe8fe59aacfc5d4"
    sha256 cellar: :any,                 arm64_sequoia: "74d12ce9654cc016f3af5fd56be811e32b5d56c03ef3e855448cc1e3a2f074aa"
    sha256 cellar: :any,                 arm64_sonoma:  "ab89e4507be9de24f2a792402bb5d12e1850d968d8a55a8c41dc4517f46575f8"
    sha256 cellar: :any,                 sonoma:        "2a4139abad8d0e88e3ab5afa5820bbeb481fa3864d67e846d5ba4198446b3daf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "763645afef10c0477541c242518dc739f7738143f9fd278d21676ad995c9ad17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d240afe67389509e855bf41234291d9d599abec6a5a239d1a7e2576e61192d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "spirv-headers" => :build
  depends_on "llvm@21"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
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
    (testpath/"test.ll").write <<~EOS
      target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
      target triple = "spir64-unknown-unknown"

      define spir_kernel void @foo() {
        ret void
      }
    EOS
    system llvm.opt_bin/"llvm-as", "test.ll"
    system bin/"llvm-spirv", "test.bc"
    assert_path_exists testpath/"test.spv"
  end
end