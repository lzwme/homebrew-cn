class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://ghfast.top/https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v23.1.2.tar.gz"
  sha256 "b657254b5e0a2dda7914a8cb1eace467f22847d75d877b83829026c1452f827a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "010ac01aa2ca80f3b4e79b5445494ed709e9d2c4c6dad00c1185618bfa03238d"
    sha256 cellar: :any, arm64_tahoe:       "bf3ff1c931ea367a8b753b7534d7c1c5db17d713363db1f658434aee7b83462b"
    sha256 cellar: :any, arm64_sequoia:     "59f20e81ba5090ec36eeade29e6bf4f7856e73abd37591e701730040bb99d286"
    sha256 cellar: :any, arm64_linux:       "06ec194ab721c11b4dbe2624c4b30e28f51bf0b5df5652dc637a0c5c97284ef2"
    sha256 cellar: :any, x86_64_linux:      "d69cf5dfc75f73a9c2d4ad19ad195f1056458191c014e57d3772d20c52597c0b"
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
                    "-DCCACHE_ALLOWED=OFF",
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