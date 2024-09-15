class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https:developers.google.comoptimization"
  url "https:github.comgoogleor-toolsarchiverefstagsv9.11.tar.gz"
  sha256 "f6a0bd5b9f3058aa1a814b798db5d393c31ec9cbb6103486728997b49ab127bc"
  license "Apache-2.0"
  head "https:github.comgoogleor-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a7c407f0cb5c8dfb847c2893cff30069cd7aac94473e3a7a87cc8291bd75c71"
    sha256 cellar: :any,                 arm64_sonoma:  "bba4a158457e216d73dbe631a2859ccec20bee080218573ea8ece7f7fc072352"
    sha256 cellar: :any,                 arm64_ventura: "3ce1a5fc9ccf285d11dbbd8e31e8962c0f00f320b47e38c80801ab689bcf556f"
    sha256 cellar: :any,                 sonoma:        "e6a103ee26182137bb5fb932a3cb4f616583efab2cf7d6283a00ddaddbade492"
    sha256 cellar: :any,                 ventura:       "33d211762847d9c687e11e1b88328612ea33baaa5e87271385069d28e747c183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad44393215920cbc489a57bb9ac02380da4fa8e1ee33bb7adbe3ed028f56e80d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => [:build, :test]
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "eigen"
  depends_on "openblas"
  depends_on "osi"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "scip"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  # Add missing `#include`s to fix incompatibility with `abseil` 20240722.0.
  # https:github.comgoogleor-toolspull4339
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesbb1af4bcb2ac8b2af4de4411d1ce8a6876ed9c15or-toolsabseil-vlog-is-on.patch"
    sha256 "0f8f28e7363a36c6bafb9b60dc6da880b39d5b56d8ead350f27c8cb1e275f6b6"
  end

  def install
    # FIXME: Upstream enabled Highs support in their binary distribution, but our build fails with it.
    args = %w[
      -DUSE_HIGHS=OFF
      -DBUILD_DEPS=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ortoolslinear_solversamplessimple_lp_program.cc"
    pkgshare.install "ortoolsconstraint_solversamplessimple_routing_program.cc"
    pkgshare.install "ortoolssatsamplessimple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(ortools CONFIG REQUIRED)
      add_executable(simple_lp_program #{pkgshare}simple_lp_program.cc)
      target_compile_features(simple_lp_program PUBLIC cxx_std_17)
      target_link_libraries(simple_lp_program PRIVATE ortools::ortools)
    EOS
    cmake_args = []
    build_env = {}
    if OS.mac?
      build_env["CPATH"] = nil
    else
      cmake_args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}lib"
    end
    with_env(build_env) do
      system "cmake", "-S", ".", "-B", ".", *cmake_args, *std_cmake_args
      system "cmake", "--build", "."
    end
    system ".simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare"simple_routing_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system ".simple_routing_program"

    # Sat Solver
    system ENV.cxx, "-std=c++17", pkgshare"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system ".simple_sat_program"
  end
end