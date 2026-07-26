class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://ghfast.top/https://github.com/microsoft/SEAL/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "0946b267a436a85c3488fe433fb61e3fcded1232443602ce056c49eb960bcdb0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7ce91ba1309e490534718ab89e1084c745c508e91cd788a8a79c42431f301829"
    sha256 cellar: :any, arm64_sequoia: "651aa7cdd6d7051ccc94255516f712d42383dac1f0708da61e6fb8a8ad5ad704"
    sha256 cellar: :any, arm64_sonoma:  "0101e1dc32f13f7db69132f51aa403f99a246bc24b7ef0c400e4007dbe048528"
    sha256 cellar: :any, sonoma:        "ca7b504f2c0ffd137c54b1acc84e06d4332f3cb806c0a67c806595256942a5b2"
    sha256 cellar: :any, arm64_linux:   "97ac1554acfa95b46565156996035775cdaaa16e87fc6eb31dadf93b63d8caf2"
    sha256 cellar: :any, x86_64_linux:  "d5f91c1d76cb63b7f812faab78a1be52e74111924edaeda403ce067f70e7ac0d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "hexl" do
    url "https://ghfast.top/https://github.com/IntelLabs/hexl/archive/refs/tags/v1.2.6.tar.gz"
    sha256 "5035cedff6984060c10e2ce7587dab83483787ea2010e1b60d18d19bb3538f3b"
  end

  def install
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