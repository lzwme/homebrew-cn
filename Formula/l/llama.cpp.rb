class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6620",
      revision: "b887d2f3413ac231e3cb5925260c39902af4a70c"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9304f6e3c98f823d6d4d8311a23cd5f9bffb3d97c5b39a7cec865b727c94321c"
    sha256 cellar: :any,                 arm64_sequoia: "84aaecb32c30bac482647f84a6582f839fa0dad78ee3f78a09665a2e0c56f155"
    sha256 cellar: :any,                 arm64_sonoma:  "6c181e4aea17d43ae0e6f73cd1585f72675899f61a284fc00fdf37997726fa2a"
    sha256 cellar: :any,                 sonoma:        "e41254ec0694977e96efbc3cce68526ba018707f35063b5288aabd17e8f5a575"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6dcce8413d100e44849eb80329dfe13ee900bd411f74518161a8785d4a110c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a6138476551337e01c871607062421447dbea4cf87e46ac7e2b6c00458e2d42"
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
      -DGGML_ACCELERATE=#{OS.mac? ? "ON" : "OFF"}
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