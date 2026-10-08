class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://ghfast.top/https://github.com/microsoft/SEAL/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "71bc8384effdc91350040a728319baf7d49732a92faf93b2508bb428b0e780b8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c338394a5384411a3c7aed945985d7c17f2357fdc665e38506d4dcab733fc189"
    sha256 cellar: :any, arm64_tahoe:       "b562782fc44a65a394a1522a17bf886d2f01baff015f8ed8d5558f4e503016e9"
    sha256 cellar: :any, arm64_sequoia:     "2b726165cc163d99b7dbc8472fee9da5530548ff692981b1f4338246e1ac6ff0"
    sha256 cellar: :any, arm64_linux:       "20e1134282da453b63890955f9d1e5e7f01308bf2248fa546dfc0fc20d329efd"
    sha256 cellar: :any, x86_64_linux:      "286c6b93adf298779e5bffde5b93af6bf15fe908c4eec88a85fe1cd889a07731"
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