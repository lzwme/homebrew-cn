class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://ghfast.top/https://github.com/microsoft/SEAL/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "77debe0a4a1d8b1b97cd66c7dad29c072d6e52108ed22ceb6669c2e7690a7c15"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "965588c516a8726756caec9bae0e64610dcfc442c42e04b9690c5efbe7d018dc"
    sha256 cellar: :any, arm64_tahoe:       "c95f9e405c114050faa70e8af1e38b3f3e0817f3f384560ecf5030b8184ced9a"
    sha256 cellar: :any, arm64_sequoia:     "e44e1a5bfd2a8cb5e635db977e31d2d978527b55942d4db9c2316f821dbcb401"
    sha256 cellar: :any, arm64_linux:       "f6cb77cbf6d91bc8d75c0f03d351384e2397d683e576d32933b34cbb2fdb045d"
    sha256 cellar: :any, x86_64_linux:      "21ca40ceddfefdb3067715adbd9921ea1a4525dc94a39a2a0a1819bbfc1995ec"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "cpu_features"
  end

  resource "hexl" do
    url "https://ghfast.top/https://github.com/IntelLabs/hexl/archive/refs/tags/v1.2.6.tar.gz"
    sha256 "5035cedff6984060c10e2ce7587dab83483787ea2010e1b60d18d19bb3538f3b"
  end

  deny_network_access!

  def install
    # Support Microsoft GSL 5.x, which upstream has not widened its version request to yet
    inreplace "CMakeLists.txt", "Microsoft.GSL 4 CONFIG", "Microsoft.GSL 5 CONFIG"

    if Hardware::CPU.intel?
      resource("hexl").stage do
        hexl_args = %w[
          -DHEXL_BENCHMARK=OFF
          -DHEXL_TESTING=OFF
          -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        ]
        system "cmake", "-S", ".", "-B", "build", *hexl_args, *std_cmake_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
      ENV.append "LDFLAGS", "-L#{lib}"
    end

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DSEAL_BUILD_DEPS=OFF
      -DSEAL_USE_ALIGNED_ALLOC=#{OS.mac? ? "ON" : "OFF"}
      -DSEAL_USE_INTEL_HEXL=#{Hardware::CPU.intel? ? "ON" : "OFF"}
      -DCMAKE_CXX_FLAGS=-I#{include}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "native/examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath

    # remove the partial CMakeLists
    File.delete testpath/"examples/CMakeLists.txt"

    # Chip in a new "CMakeLists.txt" for example code tests
    (testpath/"examples/CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.12)
      project(SEALExamples VERSION #{version} LANGUAGES CXX)
      # Executable will be in ../bin
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${SEALExamples_SOURCE_DIR}/../bin)

      add_executable(sealexamples examples.cpp)
      target_sources(sealexamples
          PRIVATE
              1_bfv_basics.cpp
              2_encoders.cpp
              3_levels.cpp
              4_bgv_basics.cpp
              5_ckks_basics.cpp
              6_rotation.cpp
              7_serialization.cpp
              8_performance.cpp
      )

      # Import Microsoft SEAL
      find_package(SEAL #{version} EXACT REQUIRED
          # Providing a path so this can be built without installing Microsoft SEAL
          PATHS ${SEALExamples_SOURCE_DIR}/../src/cmake
      )

      # Link Microsoft SEAL
      target_link_libraries(sealexamples SEAL::seal_shared)
    CMAKE

    system "cmake", "-S", "examples", "-B", "build", "-DHEXL_DIR=#{lib}/cmake"
    system "cmake", "--build", "build", "--target", "sealexamples"

    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Parameter validation (success): valid", pipe_output("bin/sealexamples", input)
  end
end