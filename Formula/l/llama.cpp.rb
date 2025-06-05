class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5590",
      revision: "0d3984424f2973c49c4bcabe4cc0153b4f90c601"
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
    sha256 cellar: :any,                 arm64_sequoia: "2e9ddcc93d393e8c350fc2b13a2602ef394ea919e488f4ff0869e13f200e122a"
    sha256 cellar: :any,                 arm64_sonoma:  "09d02edf1d4daa41894507f44619956e056f6604b4c92e410555b9feaa93616c"
    sha256 cellar: :any,                 arm64_ventura: "67a93e7b13fa7e896cdba7c15ac6238ee72154e0f1d231a61a617ccc5e03e303"
    sha256 cellar: :any,                 sonoma:        "6ea653737bee02ece4222cbee39a9c826b2ce0576f61e39f2da9c9704c7247fb"
    sha256 cellar: :any,                 ventura:       "538e13c3f9ae251e9c3733517b99cddc252ffc689526798ec4d4d4bc9bc1a09a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9758930379b20f296c241e19c294bb9a0fa8ce76c3308ee61f082f6677aab3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd718295c31a70f4fe5f61bb957985117401711da79d27c9e754d57e32c5e42e"
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