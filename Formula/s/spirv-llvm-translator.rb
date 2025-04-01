class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https:github.comKhronosGroupSPIRV-LLVM-Translator"
  url "https:github.comKhronosGroupSPIRV-LLVM-Translatorarchiverefstagsv20.1.0.tar.gz"
  sha256 "ffca6b2aa53076ef85a09676ef0079877cce4977d7aa64f5f5b33596c7d1d285"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "880034e0496b25f065103efd1afebf5886f2cc1c2e119cf3030578404051e1e6"
    sha256 cellar: :any,                 arm64_sonoma:  "18410e3d68bf104c60a045e9b841649956f32a19bf5da7ab5e5f63fc0fbcc616"
    sha256 cellar: :any,                 arm64_ventura: "4e248729f5b4c8beecbb0f0efda7c845958374f74114d2e5bd3f3290cbb936b2"
    sha256 cellar: :any,                 sonoma:        "505a40efe7c989fdfe684d0410bb7c3daeea5e2f87931da45cbb44d8b06bce70"
    sha256 cellar: :any,                 ventura:       "ee9bac1bb592384e69629e5c3f14720539d448fd3dbe616a727956cbb53c1ac0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4971fa330433b57692302527406fb71637bd2115353d2772e6b0892d2b82b2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc453d17448eb0ab9ab8cc657b12418f01a7fcaf2049cd863d4471dcfc69231"
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