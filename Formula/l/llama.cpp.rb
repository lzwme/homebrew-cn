class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4215",
      revision: "dc22344088a7ee81a1e4f096459b03a72f24ccdc"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6f2a3cdc9a784cb8c43831a3a90dc4a6c7d692c6e1a64b5da6560d1fca9cc61e"
    sha256 cellar: :any,                 arm64_sonoma:  "e17f25f6ebae7934beb68f2d8a1981c8bae5fded14eee2389cf637186889f16d"
    sha256 cellar: :any,                 arm64_ventura: "30eef5329009e132f4da22d40eebfa0ba532a034ab0c4ef5227471464064904a"
    sha256 cellar: :any,                 sonoma:        "a52603b596093fab385c7018bb2180f280a247cf069d0206148c406eaf0fba12"
    sha256 cellar: :any,                 ventura:       "ee83429b2f0ac5213e9c30d3d619c02ae8d3c0262868349a265d665118e2e28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3940433ab6332cb62a53b61635971586891afaf5bc5ed9666db10ff77edc910"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
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