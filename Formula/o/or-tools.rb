class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https:developers.google.comoptimization"
  url "https:github.comgoogleor-toolsarchiverefstagsv9.10.tar.gz"
  sha256 "e7c27a832f3595d4ae1d7e53edae595d0347db55c82c309c8f24227e675fd378"
  license "Apache-2.0"
  head "https:github.comgoogleor-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d8e2918aeaf4d17efe104669cdf327dba186d2c666b9ff5d32b83892a9547a1c"
    sha256 cellar: :any,                 arm64_ventura:  "5a3e8de79956a254a4e5ad83a1e48b3063ffe13104b7d882fd6da1681c519231"
    sha256 cellar: :any,                 arm64_monterey: "63fe54e09c7ffe4ca0e44787085da69a079cc9f37dc05e8a3b54e8a0a37de51c"
    sha256 cellar: :any,                 sonoma:         "df862c31208cc5e35e575216e8e752bd0fcae86d200e24c7f916f1f9cdb83578"
    sha256 cellar: :any,                 ventura:        "942c3eac68f7546a5cdea0e76a99304ecdcd71ec4821266244bab3130ed939df"
    sha256 cellar: :any,                 monterey:       "3b8c3c6c9e9085325e0cc2c0737378afd4f88db82006e6183a282c32f0bf064d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31ef1d67aadd4c2573f79dbe79897552df37fc5e448ae94bbc23ea22efef9369"
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