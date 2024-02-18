class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https:developers.google.comoptimization"
  url "https:github.comgoogleor-toolsarchiverefstagsv9.8.tar.gz"
  sha256 "85e10e7acf0a9d9a3b891b9b108f76e252849418c6230daea94ac429af8a4ea4"
  license "Apache-2.0"
  revision 3
  head "https:github.comgoogleor-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e9644ac8bfc378d3aa48ac29969fa2b9f6c09939ca007b949e14022d39e9c9a"
    sha256 cellar: :any,                 arm64_ventura:  "947840ee31cd91495481cf5a4a12225d469f48e86d1eee2c25e0fdfcc32c423a"
    sha256 cellar: :any,                 arm64_monterey: "5af0d9aea159a06df82a07d981ecaa2f7e026aaf287f271a5ca12e6f11f3bac8"
    sha256 cellar: :any,                 sonoma:         "197a7573181ed9e3cd5b2a1672704238a828bf9748354895dd92f06c04fd2e0b"
    sha256 cellar: :any,                 ventura:        "564b785cdd5a3a876230073d3af3ec766e546f73e2b8863673ef9820acbbeb2b"
    sha256 cellar: :any,                 monterey:       "d909fc95db966cad4ef24d222c3a6254239e91d8c9f2f9321da5f13d68565dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd90d60424be3ee0c9729241f00e878318ae60348d2fcde92e6052fbdd2dd1a2"
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
    pkgshare.install "ortoolslinear_solversamplessimple_lp_program.cc"
    pkgshare.install "ortoolsconstraint_solversamplessimple_routing_program.cc"
    pkgshare.install "ortoolssatsamplessimple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17", pkgshare"simple_lp_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_lp_program"
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