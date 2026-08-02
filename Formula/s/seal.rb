class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://ghfast.top/https://github.com/microsoft/SEAL/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "008c34afa40a2e69f201fd5f2991a7d649a055600f6f0c1a2e51b2e71fbb03d2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7a4bbc4925939413f33f6ab2e802d11e5bad6f35cf8498e0f85660cd1307d2db"
    sha256 cellar: :any, arm64_sequoia: "10388214fc661deabe1fee6a37fe582e352189a72d72b76d6666be6f699e5edb"
    sha256 cellar: :any, arm64_sonoma:  "4f24fba62bf6d1a5e6d5bfc279e03b8da557d1363c8a65900d3f22e5070aa25b"
    sha256 cellar: :any, sonoma:        "290fa276ac4730ce5c610eb5411895b26fc1b6243dd41c746cfa54dbcd6d66a1"
    sha256 cellar: :any, arm64_linux:   "b5900478a4343b5510f5b3f30be7dc6a17b67fd1a77f9e59b1bda26e29a74d02"
    sha256 cellar: :any, x86_64_linux:  "8be95ea11a71b878297694cc090ea59f26ac029db7ce5d80f927b5a546e9b742"
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