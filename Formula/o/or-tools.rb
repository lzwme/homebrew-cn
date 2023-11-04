class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://ghproxy.com/https://github.com/google/or-tools/archive/refs/tags/v9.7.tar.gz"
  sha256 "054d9517fc6c83f15150c93ef1c2c674ffd7d4a0d1fdc78f6ef8bc3e25c2e339"
  license "Apache-2.0"
  revision 5
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36a026337dbae0bd3cc6c0c6531088a82185f7b502e4b2adfcb8e6ba1a41bc53"
    sha256 cellar: :any,                 arm64_ventura:  "b2ae227b39a1269254fb914ff36fc8c1afcd1643e3dd3663bae3c965f78f0575"
    sha256 cellar: :any,                 arm64_monterey: "88810428d4cebbbc74c4a640e4307b8bdf0d48150af8b2a4d9b6559e21f0f2f4"
    sha256 cellar: :any,                 sonoma:         "85b37dc475189c708465dd9709bb63db6a9b8a37a0db9ec01e7f9e0845ce7e86"
    sha256 cellar: :any,                 ventura:        "4fea378372b1d5cdd4bc458b7f645e92a94701cfdbfffbb2a38dc243153267f4"
    sha256 cellar: :any,                 monterey:       "49aa546a8661f2f3a1a36587dfc20d32d16456167f5642078e5690d9f6149f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26d590f6120d25ac7d2abe3a1fbd5fadc8cedcd6161bef5fbb406c6707b664c9"
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

  # Fix build with abseil 20230802. Remove when included in a stable release.
  # (It suffices to look for commit 734df45, the last of the three below.)
  patch do
    url "https://github.com/google/or-tools/commit/bb7c013bf8a4f1217ef3feb8f9670e6057b43aff.patch?full_index=1"
    sha256 "ac2618ed0a4106ea0af37ea7fc91e34c2f93c2e17c264d9df31b5867ce302745"
  end
  patch do
    url "https://github.com/google/or-tools/commit/aaf306ca38a4d634113d25a31ae7a558f824cab0.patch?full_index=1"
    sha256 "e2f3cb11a9db4dc53e3452ae28dcd2160ca86886385acb0a9c3076b179a39e88"
  end
  patch do
    url "https://github.com/google/or-tools/commit/734df45de4cf8c1a59b3fef972182dd0b48ef3e2.patch?full_index=1"
    sha256 "9bffe6f80ef61da0591ec9970751a90cff5c023089d6bd6331686d8e5d3e87a1"
  end

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