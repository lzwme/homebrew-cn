class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://ghfast.top/https://github.com/ggml-org/ggml/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "4e301d97b235ca01c35308eb0aa5770fdcc0f7dd4933a7e2f94247b027e1368d"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "d246f5889042b7886449910920c089bd057166c0b98ebfe7d1298c55fce2dd29"
    sha256 arm64_sequoia: "8c48348c12b87e75bd559535c8b1d2cbd777a6954c35a2101720a33b6288b4d7"
    sha256 arm64_sonoma:  "c9603cc6cde227bf032e4269c4c1573616a26f59469d2a0adeb84da179b5b083"
    sha256 sonoma:        "5bc0fa42991bf462d47dc80555887b89ea9735a11761302b727fb219043d118f"
    sha256 arm64_linux:   "d1c289ac2df1f7910ba4852070fb301e39be79e4d94d138c03a68ea2858ead76"
    sha256 x86_64_linux:  "c190524e745dfa0070aabb3b59e6443d8494916265f67276a6ea9b4f9b195501"
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

  on_arm do
    on_linux do
      # Ubuntu 24.04 has GCC 14 libstdc++ so we can build with brew GCC 14 without impacting GLIBCXX.
      # We don't use LLVM Clang as it defaults to linking to libomp rather than libgomp
      depends_on "gcc@14" => :build if DevelopmentTools.gcc_version < 14
    end

    fails_with :gcc do
      version "13"
      cause "error: invalid feature modifier 'sme' in '-march=armv9.2-a+dotprod+i8mm+nosve+sme'"
    end
  end

  # These were previously provided by `llama.cpp`
  link_overwrite "include/ggml*", "include/gguf.h", "lib/cmake/ggml/", "lib/libggml*"

  # Lengthy test so not worth installing. Shorter examples/tests haven't been ported to new DL backend
  resource "test-backend-ops.cpp" do
    url "https://ghfast.top/https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.14.0/tests/test-backend-ops.cpp"
    sha256 "cdf5ca89d548764b69547c8d1e95e58e70f9a936595e19d0a356a44ca4d3bb3e"

    livecheck do
      formula :parent
    end
  end

  def install
    # CPU detection is needed to build multiple backends, particularly on ARM (e.g. `-march=armv8.x-a+...`)
    ENV.runtime_cpu_detection

    # Workaround as brew will prioritize unversioned GCC versions which increases GLIBCXX
    # TODO: Remove once CI defaults to GCC 14+
    ENV.method(:"gcc-14").call if OS.linux? && deps.map(&:name).any?("gcc@14")

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
    args << "-DGGML_CPU_ALL_VARIANTS=ON" if build.bottle?

    # Enabling OpenBLAS for BLAS support and Vulkan for GPU support on Linux
    args += %w[-DGGML_BLAS_VENDOR=OpenBLAS -DGGML_VULKAN=ON] if OS.linux?

    # Not building Metal backend and Sapphire Rapids on Intel macOS
    if OS.mac? && Hardware::CPU.intel?
      args += %w[-DGGML_METAL=OFF -DGGML_METAL_EMBED_LIBRARY=ON]
      inreplace "src/CMakeLists.txt", /^(\s*)(ggml_add_cpu_backend_variant\(sapphirerapids)/, "\\1# \\2"
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

    ENV.method(DevelopmentTools.default_compiler).call if OS.linux? && Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_match(/[1-9] backends passed/, shell_output("./build/test -o ABS"))
  end
end