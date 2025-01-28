class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4568",
      revision: "a4417ddda98fd0558fb4d802253e68a933704b59"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8154a79c69e11c76094e7b9c3992103a74103e9a5b3a5f0cac6fbe78d2e6d5c2"
    sha256 cellar: :any,                 arm64_sonoma:  "064e545f7cb4cd6e1e7412be22964ea2d8a417c5fd6bebcdc64325aa5186a52a"
    sha256 cellar: :any,                 arm64_ventura: "1b9507ef729b4ecf2f6b8222832e5e87305738efa52dce5db10c6d7c8d5fd255"
    sha256 cellar: :any,                 sonoma:        "a2d46a2ddbc6903d846bff212e9fc47914ce0092eeb7776e6c8a247d874f2574"
    sha256 cellar: :any,                 ventura:       "9b47eaa78b39719ebfaa714cbbda091f1ce8873f28ae08733ce5cb8cc7fe7f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3742fb238d585231fbaf7c0b4e01a4547096c2603fd9aac5ec419c876075f022"
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