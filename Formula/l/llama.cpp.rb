class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5200",
      revision: "c0a97b762e5ec767dc414f0dc4979befd4c09a52"
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
    sha256 cellar: :any,                 arm64_sequoia: "4a582cbd2910e858f196287c89251e028853a2d8f4af84aa35d5019f452e9896"
    sha256 cellar: :any,                 arm64_sonoma:  "94e3fb377866697268608523ead518439afa62e991632d55b71914047982f699"
    sha256 cellar: :any,                 arm64_ventura: "ce8c062f2297fd6111307297521e2003aa16530aa08de59c176181c05f291ee1"
    sha256 cellar: :any,                 sonoma:        "775c9e83ec7e9c2cbc2c0111b4a5ce373ccf25eaff2002cd2a4938975a6e8011"
    sha256 cellar: :any,                 ventura:       "2cdda3c322c9ae115d307d56f00643df385030260ef01b98158dd638c50dc5da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3fd5a7002fdae2af9d54985ff0e35f4ab97a96b23360adcd53b98f598ed691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff1e54c9425b6ca0f771aa18f08780b6b4b19b94e84508a76060a1237c451290"
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