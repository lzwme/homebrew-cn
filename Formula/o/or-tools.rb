class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  license "Apache-2.0"
  revision 3
  head "https://github.com/google/or-tools.git", branch: "stable"

  # Remove `stable` block when patch is no longer needed.
  stable do
    url "https://ghfast.top/https://github.com/google/or-tools/archive/refs/tags/v9.14.tar.gz"
    sha256 "9019facf316b54ee72bb58827efc875df4cfbb328fbf2b367615bf2226dd94ca"

    # Fix for wrong target name for `libscip`.
    # https://github.com/google/or-tools/issues/4750.
    patch do
      url "https://github.com/google/or-tools/commit/9d3350dcbc746d154f22a8b44d21f624604bd6c3.patch?full_index=1"
      sha256 "fb39e1aa1215d685419837dc6cef339cda36e704a68afc475a820f74c0653a61"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ce649587c5f2d0202701b4a5df43cdb9135757bcd8f0ebc28c70d49e336c09a4"
    sha256 cellar: :any, arm64_sonoma:  "cfa19ff800a4fa5ffc7822689e34d91446affa2e36fbc9495fcb93d77a7c1a87"
    sha256 cellar: :any, arm64_ventura: "cade2913e7c6c0c916568b9004732f591e4a701c7f31be38918c5376077831c0"
    sha256 cellar: :any, sonoma:        "2a4d4e198fe9f2f6b2acee2c192bda29345ee089d65f2339164e1e12bee83bfd"
    sha256 cellar: :any, ventura:       "902c0119349430b42956eef021c163d4b496ac1482dc6658b3cadfc140c0e484"
    sha256               arm64_linux:   "e9d93b5d72e6f1afa9116644477c59c66949259a19fe2318b7ca292022f2aa73"
    sha256               x86_64_linux:  "0c01f6f3ddec8e2f8ee32aa1081692ca66ce35adaa8aca7b7b284a6a86b10bb2"
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
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # FIXME: Upstream enabled Highs support in their binary distribution, but our build fails with it.
    args = %w[
      -DUSE_HIGHS=OFF
      -DBUILD_DEPS=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
      -DUSE_SCIP=ON
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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(ortools CONFIG REQUIRED)
      add_executable(simple_lp_program #{pkgshare}/simple_lp_program.cc)
      target_compile_features(simple_lp_program PUBLIC cxx_std_17)
      target_link_libraries(simple_lp_program PRIVATE ortools::ortools)
    CMAKE
    cmake_args = []
    build_env = {}
    if OS.mac?
      build_env["CPATH"] = nil
    else
      cmake_args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"
    end
    with_env(build_env) do
      system "cmake", "-S", ".", "-B", ".", *cmake_args, *std_cmake_args
      system "cmake", "--build", "."
    end
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    absl_libs = %w[
      absl_check
      absl_log_initialize
      absl_flags
      absl_flags_parse
    ]
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs #{absl_libs.join(" ")}").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end