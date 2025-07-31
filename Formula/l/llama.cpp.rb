class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6030",
      revision: "1e15bfd42c3938506e0da5939bf7f42780965f01"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d1d0ca716e8b90bec9e54ec253dc3db3d4a6069e9d8bed57990b327cb8b4c0e"
    sha256 cellar: :any,                 arm64_sonoma:  "3de6444a8a96c8032dc16d5e91ac2b262c72b112946b55b99cb1fceacbc3dc60"
    sha256 cellar: :any,                 arm64_ventura: "c01a3a1f656d8453bcf4bd6a359f8ee90fa454fffcf92b3e136d90a5e5f20367"
    sha256 cellar: :any,                 sonoma:        "005d23e5cc557ad4923d555725661edccde99f9868e0140f2fa2b498e071005a"
    sha256 cellar: :any,                 ventura:       "b50757018e3d0c4ce6cd8044848df7fe4d32effc32d21cc065a547dcc7a0a71d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0623dd02e8d345e7144d79711068313442c5e576ae1570689967067fbdb6adc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038882f8597dd9d2ae824e481df05c55d7ce67a24ab950e0526c9e8628b409d6"
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