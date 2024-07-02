class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https:github.comKhronosGroupSPIRV-LLVM-Translator"
  url "https:github.comKhronosGroupSPIRV-LLVM-Translatorarchiverefstagsv18.1.2.tar.gz"
  sha256 "4724372934041c8feb8bcafea1c9d086ab2de9f323599068943ef61ddb0bca51"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5de9420ed17ed223e11abfdcf06cdf7842ce567c401acb90d36f8966bb22a2fa"
    sha256 cellar: :any,                 arm64_ventura:  "77f4e83d4eb8bb51f023c5bae2b3e451e54c91c0899d3755e88a7054976206f2"
    sha256 cellar: :any,                 arm64_monterey: "f432cfc334e134dac4138e35b5843a2f95bf5c6cf5f6423fdd0c0b40afb58b12"
    sha256 cellar: :any,                 sonoma:         "892c601abeda81dc20c866d92b29cdc23ccc457217d3e687b623600aa2c9afc1"
    sha256 cellar: :any,                 ventura:        "63f878680379431aa3a63d5b0c8fec70fca5a8e3cff537495efc69dcc88791d8"
    sha256 cellar: :any,                 monterey:       "01bd9487a2b98d5d08da1c49c50d58c3265952e7ce883c3a1adccf579c6b09ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e6ea5f82cdf011387aef252d371d43988603b43f9761c98e61ca87a0c6c3c58"
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