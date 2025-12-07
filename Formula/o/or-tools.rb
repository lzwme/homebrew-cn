class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  license "Apache-2.0"
  revision 9
  head "https://github.com/google/or-tools.git", branch: "stable"

  # Remove `stable` block when patch is no longer needed.
  stable do
    url "https://ghfast.top/https://github.com/google/or-tools/archive/refs/tags/v9.14.tar.gz"
    sha256 "9019facf316b54ee72bb58827efc875df4cfbb328fbf2b367615bf2226dd94ca"

    # Fix for wrong target name for `libscip`.
    # https://github.com/google/or-tools/issues/4750.
    patch do
      url "https://github.com/google/or-tools/commit/9d3350dcbc746d154f22a8b44d21f624604bd6c3.patch?full_index=1"
      sha256 "fb39e1aa1215d685419837dc6cef339cda36e704a68afc475a820f74c0653a61"
    end

    # Workaround for SCIP 10 compatibility.
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "77367f0a8d406375be72d7d6c96e26b5c1891f994a85ab7bf01d5e9305cfe2e9"
    sha256 cellar: :any, arm64_sequoia: "582e9f727a2f706eb561e7e05e36289337dff6c5584702f6934295f8e8d08d76"
    sha256 cellar: :any, arm64_sonoma:  "c25fe2a1d9d167d6d4d04c53c60e595e0890a91db91ba9a9ffd19767b04146c1"
    sha256 cellar: :any, sonoma:        "d2f676b856070f592d82ffab5d4a5f2d7455e511b31f9829ca749ab62efcfb19"
    sha256               arm64_linux:   "10a9f21a0b1b6fdd2ed56edb3bc3a3366ee81f6f49783ba345a06e0b764c516b"
    sha256               x86_64_linux:  "eb3091e6c99c57c686715ed4760054e8dfb6c2162b067f610626a0918e7f2764"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "eigen"
  depends_on "highs"
  depends_on "openblas"
  depends_on "osi"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "scip"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Workaround until upstream updates Abseil. Likely will be handled by sync with internal copy
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/6d739af5/Patches/or-tools/abseil-bump.diff"
    sha256 "586f6c0f16acd58be769436aae4d272356bd4740d6426a9ed8d92795d34bab8e"
  end

  def install
    args = %w[
      -DUSE_HIGHS=ON
      -DBUILD_DEPS=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
      -DUSE_SCIP=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(ortools CONFIG REQUIRED)
      add_executable(simple_lp_program #{pkgshare}/simple_lp_program.cc)
      target_compile_features(simple_lp_program PUBLIC cxx_std_17)
      target_link_libraries(simple_lp_program PRIVATE ortools::ortools)
    CMAKE
    cmake_args = []
    build_env = {}
    if OS.mac?
      build_env["CPATH"] = nil
    else
      cmake_args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"
    end
    with_env(build_env) do
      system "cmake", "-S", ".", "-B", ".", *cmake_args, *std_cmake_args
      system "cmake", "--build", "."
    end
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    absl_libs = %w[
      absl_check
      absl_log_initialize
      absl_flags
      absl_flags_parse
    ]
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs #{absl_libs.join(" ")}").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"

    # Highs backend
    (testpath/"highs_test.cc").write <<~EOS
      #include "ortools/linear_solver/linear_solver.h"
      using operations_research::MPSolver;
      int main() {
        if (!MPSolver::SupportsProblemType(MPSolver::HIGHS_LINEAR_PROGRAMMING)) return 1;
        MPSolver solver("t", MPSolver::HIGHS_LINEAR_PROGRAMMING);
        auto* x = solver.MakeNumVar(0.0, 1.0, "x");
        auto* obj = solver.MutableObjective();
        obj->SetCoefficient(x, 1.0);
        obj->SetMaximization();
        if (solver.Solve() != MPSolver::OPTIMAL) return 2;
        return x->solution_value() > 0.99 ? 0 : 3;
      }
    EOS
    system ENV.cxx, "-std=c++17", "highs_test.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs #{absl_libs.join(" ")}").chomp.split,
                    "-o", "highs_test"
    system "./highs_test"
  end
end

__END__
diff --git a/ortools/linear_solver/proto_solver/scip_proto_solver.cc b/ortools/linear_solver/proto_solver/scip_proto_solver.cc
index f40a10d4749..d96d74755da 100644
--- a/ortools/linear_solver/proto_solver/scip_proto_solver.cc
+++ b/ortools/linear_solver/proto_solver/scip_proto_solver.cc
@@ -50,7 +50,13 @@
 #include "scip/cons_indicator.h"
 #include "scip/cons_linear.h"
 #include "scip/cons_or.h"
+#if SCIP_VERSION_MAJOR >= 10
+#include "scip/cons_nonlinear.h"
+#define SCIPcreateConsBasicQuadratic SCIPcreateConsBasicQuadraticNonlinear
+#define SCIPcreateConsQuadratic SCIPcreateConsQuadraticNonlinear
+#else
 #include "scip/cons_quadratic.h"
+#endif  // SCIP_VERSION_MAJOR >= 10
 #include "scip/cons_sos1.h"
 #include "scip/cons_sos2.h"
 #include "scip/def.h"
diff --git a/ortools/gscip/gscip.cc b/ortools/gscip/gscip.cc
index 872043d23aa..7bcac209d5f 100644
--- a/ortools/gscip/gscip.cc
+++ b/ortools/gscip/gscip.cc
@@ -47,7 +47,12 @@
 #include "scip/cons_indicator.h"
 #include "scip/cons_linear.h"
 #include "scip/cons_or.h"
+#if SCIP_VERSION_MAJOR >= 10
+#include "scip/cons_nonlinear.h"
+#define SCIPcreateConsQuadratic SCIPcreateConsQuadraticNonlinear
+#else
 #include "scip/cons_quadratic.h"
+#endif  // SCIP_VERSION_MAJOR >= 10
 #include "scip/cons_sos1.h"
 #include "scip/cons_sos2.h"
 #include "scip/def.h"