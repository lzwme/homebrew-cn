class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://ghproxy.com/https://github.com/google/or-tools/archive/v9.6.tar.gz"
  sha256 "bc4b07dc9c23f0cca43b1f5c889f08a59c8f2515836b03d4cc7e0f8f2c879234"
  license "Apache-2.0"
  revision 4
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "377884e4b2394b19dc13f748e4aa39a4c4d67f77ffd20ca45296f3a033bb10f8"
    sha256 cellar: :any,                 arm64_monterey: "2f10817c4343154e98e1e8462408c19030bbdeb2c8c7a3e657bc50f7e943fc22"
    sha256 cellar: :any,                 arm64_big_sur:  "6cba750eed1316bdd235742c5db675341088b8232bafe87741b4ccb2dc96ebfa"
    sha256 cellar: :any,                 ventura:        "06a2aa2fdb949a0a36b9eee76afeddaebd09a109cacb70ca0ff4d1a60b70b255"
    sha256 cellar: :any,                 monterey:       "be3ea00e6a151026e9626c6239271a12501f516b8b6724c88fdfbdf37e0c749d"
    sha256 cellar: :any,                 big_sur:        "fa9ebd2c1d8f0e6e321c7c8c47ff62204028131a962b01e31d3da6625c4404cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4cd46165f682741913d2d47be369a3a7b5c60890800fe19a4580c6551b741c7"
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

  # Fix definition duplicated from Protobuf.
  # https://github.com/google/or-tools/issues/3826
  patch :DATA

  # Also, fix use of StringPiece for new re2.
  # https://github.com/google/or-tools/pull/3840
  patch do
    url "https://github.com/google/or-tools/commit/8844e557bfc36c1b171b84048a5c40b6dbc97206.patch?full_index=1"
    sha256 "c884d9d011548e28b503a424ac1d2be8197b0090d3f473708f3330b319130da0"
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

__END__
diff --git a/ortools/base/logging.h b/ortools/base/logging.h
index 7f570f9..183b3a4 100644
--- a/ortools/base/logging.h
+++ b/ortools/base/logging.h
@@ -52,6 +52,7 @@ enum LogSeverity {
 };
 }  // namespace google

+#if GOOGLE_PROTOBUF_VERSION <= 3021012
 // Implementation of the `AbslStringify` interface. This adds `DebugString()`
 // to the sink. Do not rely on exact format.
 namespace google {
@@ -62,5 +63,6 @@ void AbslStringify(Sink& sink, const Message& msg) {
 }
 }  // namespace protobuf
 }  // namespace google
+#endif

 #endif  // OR_TOOLS_BASE_LOGGING_H_