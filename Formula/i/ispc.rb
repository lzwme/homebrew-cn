class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://ghfast.top/https://github.com/ispc/ispc/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "671c79bdff2d97aead3897da1a6b67a163af8c4e329350d07cf3e63d592955ff"
  license "BSD-3-Clause"
  revision 1

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "71f5effcb42ca591e78651baf434f4ef46d2b725867e9ad266be4758337ca8ec"
    sha256 cellar: :any, arm64_tahoe:       "318e4fbcc3ad01b2853b84b735cb03a32584ad632ddd823ad98bf36ecc4902c1"
    sha256 cellar: :any, arm64_sequoia:     "3be3e6b2c8bd96adb633b50aadd491670afb0755398faad3441ade6c2e64923a"
    sha256 cellar: :any, arm64_linux:       "5fe01ed96b41f24bd2fa0204dad4a102d7b3a49e5ee52dd89d75cffd11694163"
    sha256 cellar: :any, x86_64_linux:      "e958ae79abb08ded50ebd89a39797a42987169e0188d4ffd4d65b1bbc93ed57d"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "tbb"
  end

  # Backport LLVM 24 devel support which allows building with LLVM 23.1.x stable release
  patch do
    url "https://github.com/ispc/ispc/commit/32217788b98b6e8d532799d7b10792fb7c1c732c.patch?full_index=1"
    sha256 "896666bba85daa114276eeae95701ff7a9190dae27927fc225b17dc57eec0532"
    type :backport
  end
  patch do
    url "https://github.com/ispc/ispc/commit/bc5136ff9a5f5acb52fede66333a1e4879328fc1.patch?full_index=1"
    sha256 "e5e13f1937190d3996ffcfb66b5eae0df28d7866cc9945f52ec1b7c0cfabfe4e"
    type :backport
  end

  deny_network_access!

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Disable 32-bit Linux x86 target to avoid needing 32-bit glibc headers which
    # are not available in our build environment. Also fix the dispatch target triple
    # so clang can find the architecture-specific glibc headers.
    if OS.linux? && Hardware::CPU.intel?
      inreplace "cmake/GenerateBuiltins.cmake" do |s|
        s.gsub! "builtin_to_cpp(32 linux x86)", "# builtin_to_cpp(32 linux x86)"
        s.gsub! "--target=x86_64-unknown-unknown", "--target=x86_64-unknown-linux-gnu"
      end
      inreplace "cmake/GenericTargets.cmake",
                "\"x86,32\"",
                "# \"x86,32\""

      # Patch the skip function to ignore 32-bit Unix/Linux targets during stdlib generation.
      # This prevents the build from running the new 'ispc' binary for 32-bit targets it doesn't support.
      inreplace "cmake/CommonStdlibBuiltins.cmake",
                "set(skip FALSE)",
                <<~CMAKE
                  if ("${bit}" STREQUAL "32" AND "${os}" STREQUAL "unix")
                    set(${out_skip} TRUE PARENT_SCOPE)
                    return()
                  endif()
                  set(skip FALSE)
                CMAKE
    end

    args = %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR=#{llvm.opt_bin}
    ]
    # We can target ARM for free on macOS, so let's use the upstream default there.
    args << "-DARM_ENABLED=OFF" if OS.linux? && Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"simple.ispc").write <<~ISPC
      export void simple(uniform float vin[], uniform float vout[], uniform int count) {
        foreach (index = 0 ... count) {
          float v = vin[index];
          if (v < 3.)
            v = v * v;
          else
            v = sqrt(v);
          vout[index] = v;
        }
      }
    ISPC

    if Hardware::CPU.arm?
      arch = "aarch64"
      target = "neon"
    else
      arch = "x86-64"
      target = "sse2"
    end
    system bin/"ispc", "--arch=#{arch}", "--target=#{target}", testpath/"simple.ispc",
                       "-o", "simple_ispc.o", "-h", "simple_ispc.h"

    (testpath/"simple.cpp").write <<~CPP
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end