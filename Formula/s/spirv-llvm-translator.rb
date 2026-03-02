class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://ghfast.top/https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.5.tar.gz"
  sha256 "704fb1d0244a688b97decafbb51deb11774a081d5ef31652245a2527b658e0a7"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13fbb287c6deb77ab112b8baadd5d5a53eb86d5ddaa9c60baa3f9bc8c0cf0508"
    sha256 cellar: :any,                 arm64_sequoia: "aaedaf76eac2316de5e1c630dced5606a6b898c7ca60ceb2e2f5f4c5f3d0a19a"
    sha256 cellar: :any,                 arm64_sonoma:  "a15920a16fbc726935ac4282c65f22378d5df3f836a373f614f95b3fce1e83e9"
    sha256 cellar: :any,                 sonoma:        "98d0fee4adc63ba039e2aeb27ca713a5e75584803ee871ccb1f661b4d517c774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e40c1c035b59f6646f5c16ee9454c71efcadd5ac58ea0b17a5d6f82d9f35524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c2ec77f8a9a15558eaae584dff3851b8a835ea383aa49cb802197ad3cf3b54"
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