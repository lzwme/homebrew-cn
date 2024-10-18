class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3933",
      revision: "f010b77a372ffcfaf4338c670d6d3ecd89aa4eb6"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30552d81e1905409f971b981dd5fe52a3eeef9505ede78b39d4a73546aa6f00e"
    sha256 cellar: :any,                 arm64_sonoma:  "41b4e4061675cfe9653c6abfbf51b373f77fc3d09d48d67abe69871e05d45c32"
    sha256 cellar: :any,                 arm64_ventura: "1ab51b529f3194bccd8755b1e9cd17bba5c86cba7ab918220b8500f1e2f71df4"
    sha256 cellar: :any,                 sonoma:        "4a0893ea0df35eef52e4426ad56c24af2d5bd70edee1eeb6923dab9a35aef78f"
    sha256 cellar: :any,                 ventura:       "e0b1cd04362648d16f5f0002a546ff0eacb92ba05517d256dfd779b532fcde8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430523e4522c9da2bfeafce483e27e681ddbe4010629f93fcc5b580cc70a5080"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end