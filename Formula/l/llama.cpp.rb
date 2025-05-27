class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5490",
      revision: "fef693dc6b959a8e8ba11558fbeaad0b264dd457"
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
    sha256 cellar: :any,                 arm64_sequoia: "e5d348b70f8d0995aefc1468a9b02311e07a55708a9da78a83899654a29185be"
    sha256 cellar: :any,                 arm64_sonoma:  "c25a682c826f84d391f5553a73e1bda6510801c38f6da098d3f06d0c54940a3d"
    sha256 cellar: :any,                 arm64_ventura: "2bcbf4bf21bf6e82ad5a20d44d4d990b4e90373c5e8f27a57a739d340c82eb98"
    sha256 cellar: :any,                 sonoma:        "151edfbcd2c4a51c8e3ea4e8f82226de630394efb9156723bbeba8cf8f7820be"
    sha256 cellar: :any,                 ventura:       "1bf6fff7132ce4ffb1e832970ff2f43ce3478b1597bba7f1c8977293788c0ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9db7be68f3fa4a5a935b4a6a14d1b9dc72a4d91ab7731447c6813683c82bcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c48540959e46a713b968ab9b9cf2de8ca5cab1a8fee71d9d356833b36b1e9f11"
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