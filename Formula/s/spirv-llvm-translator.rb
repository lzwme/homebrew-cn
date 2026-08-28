class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://ghfast.top/https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v23.1.0.tar.gz"
  sha256 "188148437567a678965ef66254ac510dbc124d9818c332602f9d20cacc3e77ee"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d2ecee091ee8abef4720bda6db46548cebe2c8f2a22a6a1fc89f15ec66ff4dc"
    sha256 cellar: :any, arm64_sequoia: "70b11e16c91d5d00ac872e904b3ea432933c56dd21b3e49771a559bcf5df0f63"
    sha256 cellar: :any, arm64_sonoma:  "908491ded9cc9d5eb0fabf7abf9d1b802949c0203ada66da1f4dfa615add4b09"
    sha256 cellar: :any, sonoma:        "5ac6cc78edc0c0ac7626dacae5e90a12cb2ddf0ae4686d69e4ad0d98f4c38b8e"
    sha256 cellar: :any, arm64_linux:   "f66fcd23d92a8b377232fcf71308db552c2eff502ee9b38e652273cd5176a285"
    sha256 cellar: :any, x86_64_linux:  "e11142730c454097201991b324c01ac7a74fa0f8b30f37089741a601902f8879"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "spirv-headers" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLLVM_BUILD_TOOLS=ON",
                    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=#{formula_opt_prefix("spirv-headers")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.ll").write <<~LLVM
      target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
      target triple = "spir64-unknown-unknown"

      define spir_kernel void @foo() {
        ret void
      }
    LLVM
    system llvm.opt_bin/"llvm-as", "test.ll"
    system bin/"llvm-spirv", "test.bc"
    assert_path_exists testpath/"test.spv"
  end
end