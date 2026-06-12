class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://ghfast.top/https://github.com/ggml-org/ggml/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "fbdede8944e623776c2d7400c8fa8716da17d010111497118433396493c961d8"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "afdcb8526a7d70d1bba65d4f8f41cb375ae9acd7c9292e13cfda8958f08518a1"
    sha256 arm64_sequoia: "4e590eece481e0fc58260d59d02a90ee5f29df7bcbe6bc8d75385c88d4ef0ba3"
    sha256 arm64_sonoma:  "acf5a244afcce3f94ba60a6c5cf1607eab1c1bf8bd49aedfb06ce8ae047e3798"
    sha256 sonoma:        "54d1477dbaa93369609d580aec927d5024cabbc3b0f7cdabe6197456f7c753cd"
    sha256 arm64_linux:   "3229fd68eb47cd03dc54b22d0d570b8f1e77314c618d7ec06fcfaf203ec958b5"
    sha256 x86_64_linux:  "d38387014ccbbe0995459904cd36ed19467562dd49fdff66a1dc1795b19339de"
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
    url "https://ghfast.top/https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.15.0/tests/test-backend-ops.cpp"
    sha256 "d6d2cf22f2abee6e52d0078dd2e329157fab2df64c25f183b59ad81e9d2699f8"

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