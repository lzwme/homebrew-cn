class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://ghfast.top/https://github.com/ggml-org/ggml/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "62237df4f6b1f4206a08818cb6234c3408d0830b4fd40077fc469798995a9558"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "e94a9ec5dcd2143733f4a6327e8ca86daf4c8892556a82f8386d13ba2d959da5"
    sha256 arm64_sequoia: "7b284d38c1325d68c1dd06b70495c21e9197348fe58bcd2939d4bf692803f529"
    sha256 arm64_sonoma:  "1b6f1c9c52f36b570d276e15afa3cfa2de248a967566469e918c87ced6507c71"
    sha256 sonoma:        "fc0bf9abaf847380c33c48cfe8a6bc9a222cc13a413d58779718a957922d901b"
    sha256 arm64_linux:   "ea95ffa59c5b6e996dfb2c7df72367b92cbe9c127997c69fb48108a0e3c56ae3"
    sha256 x86_64_linux:  "0db1544642456b667a6040bf4dce267bde554be833664a3ae4136c41f763049c"
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
    url "https://ghfast.top/https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.10.1/tests/test-backend-ops.cpp"
    sha256 "4a661b4469d3485bbab99e4f71f68408e86c512f5ccc23b7dc451cc4058b491f"

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