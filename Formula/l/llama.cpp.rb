class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3837",
      revision: "1b2f992cd2cff0b69e5abe78bb8888d51ed19d67"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "085ce62a793869ac0a1bd1549663433916d6ffcf1d5370d021b22a111ff8e623"
    sha256 cellar: :any,                 arm64_sonoma:  "f0c955ebbd2ef41f6154c95d48771c7d7d9f20bdec7872180bbd692be5db50ae"
    sha256 cellar: :any,                 arm64_ventura: "a78d8511978b7beb468b4395697e393212667145a573e4d503e576b747065d0f"
    sha256 cellar: :any,                 sonoma:        "e570b87015646ff8f2e2dd88f6ac588152155eb25bec5091d3714f887a8b1a8d"
    sha256 cellar: :any,                 ventura:       "5850eaa6c7bf5416e99e365a139895e7e1967d27f3bc4f9af5197bd5616ba7bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086bf73f4ca0dfcdbb40c638e72fee796f7850352c1bd4698ce6d0ab0d5d336c"
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
      -DGGML_METAL=#{OS.mac? ? "ON" : "OFF"}
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