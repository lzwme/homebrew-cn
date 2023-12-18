class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https:developers.google.comoptimization"
  url "https:github.comgoogleor-toolsarchiverefstagsv9.8.tar.gz"
  sha256 "85e10e7acf0a9d9a3b891b9b108f76e252849418c6230daea94ac429af8a4ea4"
  license "Apache-2.0"
  revision 1
  head "https:github.comgoogleor-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67feee609bd7428218151deb105b1dd26c9a1502cd573045cdb3ba1bccb2cbf7"
    sha256 cellar: :any,                 arm64_ventura:  "e9e38937fa6af1e50d9703913d27d6318c60def4534d06fd747835eea014407c"
    sha256 cellar: :any,                 arm64_monterey: "f4c14812bdc299dc8e4f83ea416396b82b838326f5e6b9046ce08c109dc8bd3e"
    sha256 cellar: :any,                 sonoma:         "3059a2f1b5e2fcbea3cb84304abc48b729f787234c4cfdcbebe9e3bed458c0c6"
    sha256 cellar: :any,                 ventura:        "d43e4058808800070167b55b5a670efb860ba8a457ca51076c3cef46cada2762"
    sha256 cellar: :any,                 monterey:       "719836764bfb380bd57d8dd91b5ef3651a821731154c7de693131d1133a3ada5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cadd02aac6e23a1c023042b2c091416650b535c21252179e5b68af6074c0fdc8"
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