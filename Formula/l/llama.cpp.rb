class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3684",
      revision: "e536426ded3fb4a8cd13626e53508cd92928d6c2"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f32772bcd053025eae7185f6bb0b1c996fc55ccf8abafd8ffe6994bffc10bac9"
    sha256 cellar: :any,                 arm64_ventura:  "8220ced0fc1d1de3e26664d6d6e18b2fa3b44757e068eda94c26e156104a49e3"
    sha256 cellar: :any,                 arm64_monterey: "f48be9425376c4d033a5c5bf83997bc8fca4b0537bc75212b89bed334720cfc3"
    sha256 cellar: :any,                 sonoma:         "02cd07ec378cad229578f701a05161a5e5e299cd7c97da70601b1b9b618d08d0"
    sha256 cellar: :any,                 ventura:        "ef94deca58f1143fdc56bc64f475fd25b35b70d81231eb847f980dc04f9a3400"
    sha256 cellar: :any,                 monterey:       "fa29070b109ab790a80f986c7787fa214dedb411f2af9ba82ef40367aefa6074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84771441e65dc3d7debb219128b3d21d6e34f9e88fc049773f2cc129ad4909dc"
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