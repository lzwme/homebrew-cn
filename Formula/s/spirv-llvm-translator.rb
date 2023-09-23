class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://ghproxy.com/https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v16.0.0.tar.gz"
  sha256 "305fac5bb8efdad9054f0d27b5b765aca8b3349a500e2ba0c927763e42badc2b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcf217abc3cf6dff0301f12d3cc96361e4795d98b36d7db301e5db06421c4fb0"
    sha256 cellar: :any,                 arm64_ventura:  "82cb73e5f654afa05b7216ced0ea9c0faadb40469053ba0242391ebfb3e6ad5d"
    sha256 cellar: :any,                 arm64_monterey: "cc3218029bf78c8b44484105f4260f7b9e985b00569b09eb87f4980c58e4d79e"
    sha256 cellar: :any,                 arm64_big_sur:  "03c9ae50323c6f0d5f0209c5861529d1dda363b17a20306c5efbc177f831a0a3"
    sha256 cellar: :any,                 sonoma:         "b3034ad8eb4e4224e3b2eccf614391dda06c165525b806cac25aa937c7a27daa"
    sha256 cellar: :any,                 ventura:        "3ec6762a23e42954c15e075b8139555dea129c192ccac7dc6bfe66331058dbd6"
    sha256 cellar: :any,                 monterey:       "f311b176fe18873113fcf5e22ec209d4f360df8badbe89c724770e9c287d32ee"
    sha256 cellar: :any,                 big_sur:        "fff2616cc45266a010d662ad32baf046ec6bfafe3d4e570c5d15ba01edd73742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333574e0d95b281a71dcac5f4e8346ffefabd0f4b11e6a607317ab8b97050cd4"
  end

  depends_on "cmake" => :build
  depends_on "llvm@16"

  # See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56480
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLLVM_BUILD_TOOLS=ON", *std_cmake_args
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
    assert_predicate testpath/"test.spv", :exist?
  end
end