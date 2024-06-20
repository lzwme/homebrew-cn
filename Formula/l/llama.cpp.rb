class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3184",
      revision: "9c77ec1d74874ee22bdef8f110e8e8d41389abf2"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "69c5d1b99c21ba9a75959ea9c17d600e065d177ea96122d92ab5112e4400a08d"
    sha256 cellar: :any,                 arm64_ventura:  "3f056fb4b906d0ef34fca2ef3df99117644112c9f08ee8b40210fabbd8a67249"
    sha256 cellar: :any,                 arm64_monterey: "5070cc6f293a7d4c570096a46206bf1d80b07e5fd59d663872618e4e881980e4"
    sha256 cellar: :any,                 sonoma:         "2c498d8df3cb4b2ee21e0c9ecfe0c05f79df9aae3ce4a660c2dbcc8f6b71552c"
    sha256 cellar: :any,                 ventura:        "dc5565be05ec8a895f61678f8773777e8ba418c0422a3079cca0a62ed38f527a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31bb6f0709f1a84191f67ecbc0ba395d1aeae654e009b32aaceac1ec27454980"
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