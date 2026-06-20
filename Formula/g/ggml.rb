class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://ghfast.top/https://github.com/ggml-org/ggml/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "298e958817a126c44bb8e97c97d5d53d00bd15eca22bebf805f278223fe29e07"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "1edd059a303f9f3bdfdc744597a7e1b317b40c702e3ea6f12c5bc193555e8ab8"
    sha256 arm64_sequoia: "dde84f55a6b9fc497578f67e20e12a2e15ce4bc4039feaaf285b347480696f4d"
    sha256 arm64_sonoma:  "ead65b2224ef334201c15a23be5bb615cd904257d68317894b4bac7d0b6597ff"
    sha256 sonoma:        "dd393c7a890d649742ca177b8ef68c3d4366d4af5c0019975b7ba83eef36380c"
    sha256 arm64_linux:   "d5e7c051500746275175aafaacd85616e06cdb84b1347f1adc4221fdd2481d43"
    sha256 x86_64_linux:  "11b281ca73a4967470107d17dba8c789fe4be87620123d67649ed1c0ee5df514"
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
    url "https://ghfast.top/https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.15.2/tests/test-backend-ops.cpp"
    sha256 "8088bebadb9e66d8a9603081476e1f69b154456259afa2b6a1e57b3173e95d53"

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