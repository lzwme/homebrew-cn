class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4735",
      revision: "73e2ed3ce3492d3ed70193dd09ae8aa44779651d"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e7a9d25a087b4511760dc2aeb645c12f0bb1eebb76c7e57cc275cc43c745e0a"
    sha256 cellar: :any,                 arm64_sonoma:  "9fa21b4deba9e5f408cf4c0d26f3600460f3b086cbd42a42aecd1a2bf61c77bc"
    sha256 cellar: :any,                 arm64_ventura: "8e78d75b57b7093c40697043f3a3923e2aad32c64cef19325cf0216a4bbe5d29"
    sha256 cellar: :any,                 sonoma:        "6db78ef54f57ff7826ba5250d08d8a43de39b6c7cef34066e7454746b8ca6cdf"
    sha256 cellar: :any,                 ventura:       "55c2cae4fc9f6baca2bd4056fb14f03de0ca2c676344b847ea476ff782488d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6aa84f34ad99613ac2799999ea5edfc9f477b07cb0c04b3076e0f9d98c81c49"
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