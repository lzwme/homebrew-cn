class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://ghfast.top/https://github.com/ggml-org/ggml/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "b041330a598b5704c48d61b47f86011aa3f37aa03726c5b80805307924e68967"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "e34a22e0f1471c63702bbea95b5ffeabac3b1d6d8cacbc8d1eb19ddc3c51347a"
    sha256 arm64_sequoia: "6292d02c3ecb92d4fd5ca4034c1fb9c8a69b4a21fb775145b1f142ec6e793e81"
    sha256 arm64_sonoma:  "9788da6d7ef816cf401edc739d80d7ac34c51ada144788c95467af691615728a"
    sha256 sonoma:        "98577259736f26f6d00dc5095dee2ceff81bee9a7b0a80e414785678fc3ba99a"
    sha256 arm64_linux:   "77ae6df44fbb63fa3e8f2b9307bbe17ec436b45dca2e8651e6b91330996b6a1b"
    sha256 x86_64_linux:  "1c75d1519d106755fd7f4a87a9cb5456da7af2f0c60bbb451c48e667c5fd5678"
  end

  depends_on "cmake" => [:build, :test]

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "shaderc" => :build
    depends_on "openblas"
    depends_on "spirv-headers"
    depends_on "vulkan-loader"
  end

  # These were previously provided by `llama.cpp`
  link_overwrite "include/ggml*", "include/gguf.h", "lib/cmake/ggml/", "lib/libggml*"

  # Lengthy test so not worth installing. Shorter examples/tests haven't been ported to new DL backend
  resource "test-backend-ops.cpp" do
    url "https://ghfast.top/https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.12.0/tests/test-backend-ops.cpp"
    sha256 "cc5b21ce121498fb30f3cc90440f7c835ed0a87e6d3c45eb2d3e789a696466ac"

    livecheck do
      formula :parent
    end
  end

  def install
    # CPU detection is needed to build multiple backends, particularly on ARM (e.g. `-march=armv8.x-a+...`)
    ENV.runtime_cpu_detection

    # TODO: Workaround for GCC 12 as armv9.2-a was added in GCC 13. Remove after Ubuntu 24.04 migration
    if Hardware::CPU.arm? && ENV.compiler.to_s.start_with?("gcc") && DevelopmentTools.gcc_version(ENV.compiler) < 13
      inreplace "src/ggml-cpu/CMakeLists.txt", "if (GGML_INTERNAL_SME)", "if (OFF)"
    end

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BACKEND_DIR=#{libexec}
      -DGGML_BACKEND_DL=ON
      -DGGML_BLAS=ON
      -DGGML_BUILD_EXAMPLES=OFF
      -DGGML_BUILD_TESTS=OFF
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_NATIVE=OFF
    ]

    # Enabling OpenBLAS for BLAS support and Vulkan for GPU support on Linux
    args += %w[-DGGML_BLAS_VENDOR=OpenBLAS -DGGML_VULKAN=ON] if OS.linux?

    # Not building Metal backend and CPU variants on Intel macOS
    if OS.mac? && Hardware::CPU.intel?
      args += %w[-DGGML_METAL=OFF -DGGML_METAL_EMBED_LIBRARY=ON]
    elsif build.bottle?
      args << "-DGGML_CPU_ALL_VARIANTS=ON"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("test-backend-ops.cpp")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(ggml REQUIRED)
      add_executable(test test-backend-ops.cpp)
      target_link_libraries(test PRIVATE ggml::ggml)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_match(/[1-9] backends passed/, shell_output("./build/test -o ABS"))
  end
end