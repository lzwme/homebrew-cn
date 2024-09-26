class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3825",
      revision: "1e436302188a704ac9ea044af03193648806f19c"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7734ca12e5b005fcf66f9d83fff4f3664a1f89c4e90bc268fcabc5537f48c200"
    sha256 cellar: :any,                 arm64_sonoma:  "b9129b2f54408cbf14fd966d1aee30ab6b2ccafeb54d04473b582d29bdc003fd"
    sha256 cellar: :any,                 arm64_ventura: "3d78a351e3ce7d3692a4b157d41cf4eba622e96fde3d9fce5b479ef153c41c74"
    sha256 cellar: :any,                 sonoma:        "1e7e1ba079162bbf963cb8ae2f99a6c88c7c456eb5283f75c22cb52a752b9d3f"
    sha256 cellar: :any,                 ventura:       "2b3a81d69965d10a97bad87925c76d86e0a7acd0b0a0ec7bffed7290957a849f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fabb145eacd6ea0e3bbae228da77a35fed4b0ed937ff9c3c55d35e49e9d6c934"
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