class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5300",
      revision: "4773d7a02ffdb05ba9e673ff21ce95351836e33a"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*0)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7368c4e8b52d3270f47e8fc17888867f00b048dc827f8e09bfaa53283fed0328"
    sha256 cellar: :any,                 arm64_sonoma:  "20417d6945cf4c888666534e705a6faa1f31c703c45ed23423142b43425808b1"
    sha256 cellar: :any,                 arm64_ventura: "b65b9e0bae0b7e07648cb87a609340fa391f4e62605858f953570ed6a73829ca"
    sha256 cellar: :any,                 sonoma:        "4db897edb1dc97f82eabc2beddcb230a5cc829f78a3077846a19c9ef242f7d90"
    sha256 cellar: :any,                 ventura:       "0f4560406a2e15bb81352257ef9702051a8c45ac0812cea619fc9d59a21e44c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfee5f43a6e51fcf5543462560b7e29d8606260e09247a1ebef369ebec4ad7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16ae4d5c6499e0b1e0a2cf6098aa01c92a2a7bfa27cc0b7684c0419b18468ad5"
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