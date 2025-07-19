class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5930",
      revision: "f9a31eea06a859e34cecb88b4d020c7f03d86cc4"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bcf06a7332f13975295cc168cbbe72e6309a136be93524c4829561d9953216e8"
    sha256 cellar: :any,                 arm64_sonoma:  "2755148da860653b86edad1ef3b60530f5c166e1b35ce2bf094c3ec8f5b3251b"
    sha256 cellar: :any,                 arm64_ventura: "85577b8eb8777ed53463c46c9c9a10061a8c6074bf02da089cb5301c916ecdeb"
    sha256 cellar: :any,                 sonoma:        "a5eae1b021a96eeeb5536814438284ac6d76abfd43ef07b4c246d458e770b72e"
    sha256 cellar: :any,                 ventura:       "5a2623cf41ff64571a2ef54b1d53cd5020225db6e59a48009db5704071efeb99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e17ac6dd17988e5ecd02906e06eeb7bef864cecf47117e51b217a143826fe902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a7e585245b1f4194a4bbdb5bbcde1219ed6c9d2c1da4e9898b873efaf4783dd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "curl"

  on_linux do
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end