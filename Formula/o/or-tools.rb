class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://ghproxy.com/https://github.com/google/or-tools/archive/v9.7.tar.gz"
  sha256 "054d9517fc6c83f15150c93ef1c2c674ffd7d4a0d1fdc78f6ef8bc3e25c2e339"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "621316a16b4959714c83e876559199d18e3d74a1f786649461239013d2608150"
    sha256 cellar: :any,                 arm64_monterey: "bd036250efb03140433302c34894b5ca2ca8387a075c59144572906412197a96"
    sha256 cellar: :any,                 arm64_big_sur:  "95c8b1f0db6e428b8371161dc9bdd1c00c8ecfd213d525b06ca0c555ba1c6bc9"
    sha256 cellar: :any,                 ventura:        "6feae7accd621dd0c4ab8017dc589edc78ed5975e0f5e672c341d63165b6cd7b"
    sha256 cellar: :any,                 monterey:       "fcd1f3ff6b070c53f9552f67d51afe08f52c5e0d25573308eeeaaf11f5559d21"
    sha256 cellar: :any,                 big_sur:        "114a33b956dfcbecc2583fa2ca65b688a7c6bf47a54a015251463ec396397bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44d19520e08821a7e0abc9f4b38641f07c0bf86006bd77475f34f7bc7e78478"
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