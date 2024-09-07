class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https:developers.google.comoptimization"
  url "https:github.comgoogleor-toolsarchiverefstagsv9.10.tar.gz"
  sha256 "e7c27a832f3595d4ae1d7e53edae595d0347db55c82c309c8f24227e675fd378"
  license "Apache-2.0"
  revision 6
  head "https:github.comgoogleor-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3fd0cc967876d244b1a7456b0dc1d98606545133baf04d8930b28d912c985a70"
    sha256 cellar: :any,                 arm64_ventura:  "9c943b3ac25a1d3d6e11ebbea68b9bd3bc9ae4216ce1c1c4f178dfcf99bcb85e"
    sha256 cellar: :any,                 arm64_monterey: "189bd9ada8a9db5194170ee0bbc29380c077dc890e21420c1fbf568c1681e2d3"
    sha256 cellar: :any,                 sonoma:         "7eab6a97d3f4f55e3db74762fffc0b271ab7e3c260422f0ad1155f35b552aa47"
    sha256 cellar: :any,                 ventura:        "7f260757e05df90b01f6f1927ab15e24097687dd4380e44b806bd399baaedc97"
    sha256 cellar: :any,                 monterey:       "5490c0750741fc9f5c932399bd3f97acfbd5f0474f075b614cd3c1751b8f1a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4620e2edbe255510b13509f8dc56412a9b6f92f3f6652a69f49d90b5d15d3151"
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