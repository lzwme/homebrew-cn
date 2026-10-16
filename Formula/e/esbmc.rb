class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker for C, C++, and Python"
  homepage "https://esbmc.github.io/"
  url "https://ghfast.top/https://github.com/esbmc/esbmc/archive/refs/tags/v8.6.tar.gz"
  sha256 "a691bbf63a51da753a24b59027dd603c91bc2e90fcdd1abc042e241453164f5a"
  license "Apache-2.0"
  head "https://github.com/esbmc/esbmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "44476a30964abea53df222aa536bd7d471bd1b39e943aa259baec8c1cd4bf08e"
    sha256 cellar: :any, arm64_tahoe:       "0995d9e8ede3f65925393ff0102cf79a2259a8c8eb7da12c6ca2fa35f1fa0122"
    sha256 cellar: :any, arm64_sequoia:     "7f355de6103d392b9259139afc71665206dfdee0204ce61e8764ccc99e001dfb"
    sha256 cellar: :any, arm64_linux:       "e27f24bbda9154222a0de7c60859add61e858f26d3875bce0c7c3b2dbc215da7"
    sha256 cellar: :any, x86_64_linux:      "894c0cce54af2776b08ca7530d071a5f929aeec07002683f2473086a53b768b8"
  end

  depends_on "bison" => :build # macOS ships 2.3; esbmc requires >= 2.6.1
  depends_on "cmake" => :build
  depends_on "immer" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "bitwuzla"
  depends_on "boost"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm@22"
  depends_on "python@3.14"
  depends_on "yaml-cpp"
  depends_on "z3"

  uses_from_macos "flex" => :build

  # Avoid std::atomic<double> arithmetic, which needs libc++ 18 or newer.
  patch :DATA

  def install
    args = %W[
      -DLLVM_DIR=#{formula_opt_lib("llvm@22")}/cmake/llvm
      -DClang_DIR=#{formula_opt_lib("llvm@22")}/cmake/clang
      -DPython3_EXECUTABLE=#{python3}
      -DBitwuzla_DIR=#{formula_opt_prefix("bitwuzla")}
      -DENABLE_PYTHON_FRONTEND=ON
      -DENABLE_FUZZER=OFF
      -DENABLE_Z3=ON
      -DZ3_DIR=#{formula_opt_lib("z3")}/cmake/z3
      -DENABLE_BOOLECTOR=OFF
      -DENABLE_BITWUZLA=ON
      -DENABLE_GOTO_CONTRACTOR=OFF
      -DBUILD_STATIC=OFF
    ]
    args << "-DC2GOTO_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    args << "-DENABLE_BUNDLE_LIBC_32BIT=OFF" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.env_script_all_files libexec/"bin", PATH: "#{formula_opt_libexec("python@3.14")}/bin:$PATH"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      int main() {
        int x = 5;
        assert(x == 5);
        return 0;
      }
    C
    output = shell_output("#{bin}/esbmc #{testpath}/test.c --no-bounds-check --no-pointer-check 2>&1")
    assert_match "VERIFICATION SUCCESSFUL", output

    (testpath/"test.py").write <<~PYTHON
      value = 5
      assert value != 5
    PYTHON
    output = shell_output("#{bin}/esbmc #{testpath}/test.py 2>&1", 1)
    assert_match "VERIFICATION FAILED", output
  end
end

__END__
diff --git a/src/esbmc/bmc.cpp b/src/esbmc/bmc.cpp
--- a/src/esbmc/bmc.cpp
+++ b/src/esbmc/bmc.cpp
@@ -3037,7 +3037,12 @@
       note_cov_suppressed_violation(claim.claim_cstr);
     }
 
-    solver_stats.total_time_ms.fetch_add(solve_stop - solve_start);
+    // libc++ before 18 has no std::atomic<double> arithmetic (P0020R6),
+    // so accumulate with a compare-exchange loop instead.
+    double prev = solver_stats.total_time_ms.load(std::memory_order_relaxed);
+    while (!solver_stats.total_time_ms.compare_exchange_weak(
+      prev, prev + (solve_stop - solve_start), std::memory_order_relaxed))
+      ;
 
     // A claim that reached no verdict — a backend failure (P_ERROR) or an
     // SMTLIB-only emission (P_SMTLIB) — would otherwise leave final_result at