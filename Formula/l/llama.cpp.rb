class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3747",
      revision: "e6b7801bd189d102d901d3e72035611a25456ef1"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3015706657f8a58160fb77a9e95cd9bd75e643056f57b9cb2db3fdfb8436f97d"
    sha256 cellar: :any,                 arm64_sonoma:   "6e5372b43b9ad80ede36dd198d5a43d38bd7a585a3b73ec111cb3b30b58a7b53"
    sha256 cellar: :any,                 arm64_ventura:  "2c174f94fe5c87ecbcf9a42a5bf405ba7dd8a302818e9d7da7e166da90efbac7"
    sha256 cellar: :any,                 arm64_monterey: "05459eb1dcee60276debd7d46b59f16a9b2500f6ac27458601944a1753efedcc"
    sha256 cellar: :any,                 sonoma:         "bfece278cb0a3466ee0e06e54a692ebb855bfc53e8e0ab29dfc344eac839b5ee"
    sha256 cellar: :any,                 ventura:        "f16adb6a47993090c054bab2ee2f5fd88bc546c31be96153dd60d0a77bd9e2ee"
    sha256 cellar: :any,                 monterey:       "51620488ec42ffae3da1849cd3365f20ff18e440a232528047f36f458c54a87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d38eb3a8e400f7b653376593b7efd98b3942b8605da175376af5817addc8b897"
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
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end