class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https:github.comKhronosGroupSPIRV-LLVM-Translator"
  url "https:github.comKhronosGroupSPIRV-LLVM-Translatorarchiverefstagsv18.1.4.tar.gz"
  sha256 "7d2d0fe478f4b6c5cc1fcb689a1b75506e353633d61d45191be5e6aaf18b9456"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b60437b157cac562ae507475ccd561fcd0181771ad514620d8e9a93352cfcd9d"
    sha256 cellar: :any,                 arm64_sonoma:   "fa18462c9609f3ec61da4c2c8268508679e3c8e53c30452bcd55ac40fabcccd4"
    sha256 cellar: :any,                 arm64_ventura:  "8431842e0f6fdaa46be135ba407d0b6b7bfd173368755eeff703de92e2c62907"
    sha256 cellar: :any,                 arm64_monterey: "6288b9be8c7ab125cd95a1a3f4426624507dcd304435bb6d30b4ef3582d83aab"
    sha256 cellar: :any,                 sonoma:         "19d837682d94ca2eb1501ba04f3eb48094adf6945d953eda17c20b53a505c719"
    sha256 cellar: :any,                 ventura:        "988be22119eb887cdc2449236087cf58809fe0af549f4ccfc3d4fb429f39c146"
    sha256 cellar: :any,                 monterey:       "362152a78f2b2aa706be81f54cc7e84e80f06de7c8cf4df649f89ed8f7609551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dd5270867e409c03c58239c09f9836ae8c342ef5bd596bb4d8d37a2d930fa21"
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