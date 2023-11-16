class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://ghproxy.com/https://github.com/google/or-tools/archive/refs/tags/v9.8.tar.gz"
  sha256 "85e10e7acf0a9d9a3b891b9b108f76e252849418c6230daea94ac429af8a4ea4"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1912b2832e4dba2dccff8b200e457e6033345a565745ab701d8ef3bd672e566"
    sha256 cellar: :any,                 arm64_ventura:  "376168b9817bb0aae9b1256a3fa51b8bd2bc1f86f42b1892c4fc869e585e5998"
    sha256 cellar: :any,                 arm64_monterey: "21e1db64a945de4ae95afd9e81e33f761a50847446ad2ff853e91085af392635"
    sha256 cellar: :any,                 sonoma:         "bc816232179ce6e4ebc9e4286c97371b1753947be2deb777b0c1ab086c1c7c6f"
    sha256 cellar: :any,                 ventura:        "73c351a9b4fb389364be6c8c7e05b45093b3aa60269d372a5f7502d1d833aee1"
    sha256 cellar: :any,                 monterey:       "5d02cdb5186f03dea4d7b4d46bd7af076fdc8f64c9284cd1fbd4a7ba42a5a559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5eee7ab5b31eb708ae9f8e24d7fa4b6366dcefea28232ce2067cd7d7f81dddd"
  end

  depends_on "cmake" => :build
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

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = %w[
      -DUSE_SCIP=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
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
    system ENV.cxx, "-std=c++17", pkgshare/"simple_lp_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_lp_program"
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end