class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3267",
      revision: "9ef07800622e4c371605f9419864d15667c3558f"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d414a1c333ab66394face3d02b258408d275fe059388d0b35fd062a8b954c75e"
    sha256 cellar: :any,                 arm64_ventura:  "75dd0b678f5ba8dcb2f86f2f63e84c0f01e44e6e62b3fd0733d2ec3f28b828b6"
    sha256 cellar: :any,                 arm64_monterey: "af97430f6e4c2473a02362f8f8277b50dd36083e9f3ab4a7caa6f772cc08028a"
    sha256 cellar: :any,                 sonoma:         "4d72429ac9b5d05265295fa0b3bb87640f586c9b8390c91723cbb0c532b949b5"
    sha256 cellar: :any,                 ventura:        "fe02baad5a5cdf4ea2c096afa342d5db69f4eda8ed2728aa118c82a427bc3cda"
    sha256 cellar: :any,                 monterey:       "e10bb95139451913cb9fad85c723e56ad64b14363130fe5ac4b08fa59505bf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c765bb67a6bd99b922fcb5fb0a4341b384a5d076fbdcbe8d977994f43338cc"
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
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end