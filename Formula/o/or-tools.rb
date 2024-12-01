class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https:developers.google.comoptimization"
  url "https:github.comgoogleor-toolsarchiverefstagsv9.11.tar.gz"
  sha256 "f6a0bd5b9f3058aa1a814b798db5d393c31ec9cbb6103486728997b49ab127bc"
  license "Apache-2.0"
  revision 4
  head "https:github.comgoogleor-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0189a1b34fb06ac45ccaf84b741e48c10ac9436d1ef0565f84c0c8c2eaf6d47c"
    sha256 cellar: :any,                 arm64_sonoma:  "ca6f558d5b4f5c9b11e93b2208013d4a17c987ba3787d5103254a40c18eef8f2"
    sha256 cellar: :any,                 arm64_ventura: "53bcdd91ecae85c07c0e2cd708c563124dafa0aadfc32257a64f829f03a1d85a"
    sha256 cellar: :any,                 sonoma:        "6f89d06cf849de9fecbd8a45cbcaf52753185781fab9613e6ed674b1a03db538"
    sha256 cellar: :any,                 ventura:       "b7ba160c36920b17cdd510d2dec36a3d98a989e342b71c7995d701320cf40f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f711a7703364c5c97f58bfd8db94f35bb223bf7b4a7f3fbb714e23c921110e64"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
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
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(ortools CONFIG REQUIRED)
      add_executable(simple_lp_program #{pkgshare}simple_lp_program.cc)
      target_compile_features(simple_lp_program PUBLIC cxx_std_17)
      target_link_libraries(simple_lp_program PRIVATE ortools::ortools)
    CMAKE
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
                    *shell_output("pkg-config --cflags --libs absl_check absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system ".simple_sat_program"
  end
end