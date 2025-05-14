class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5370",
      revision: "71bdbdb58757d508557e6d8b387f666cdfb25c5e"
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
    sha256 cellar: :any,                 arm64_sequoia: "b2a1cb851d13cbd526d7156f0f2f6a39a8168a8e83f12c69bfb9305a9e5cc561"
    sha256 cellar: :any,                 arm64_sonoma:  "2a78fb962ea04d7828a1dd452fd96a50598c53d2cd35fa4f7d10a1991636826c"
    sha256 cellar: :any,                 arm64_ventura: "2a346d0c409ec9c2d14c6b693f7730e4abf33d489806b956b89e79edecce540a"
    sha256 cellar: :any,                 sonoma:        "02f46b4f4049acd09b7b9ce42a8d3bb428c023ef682661c719ff1aded97d8205"
    sha256 cellar: :any,                 ventura:       "18d5ec72959ad1d1376314c69c46b28fb65727d1f1f08d7fcb39f92e7818629c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9be67fff1b16b9fefe28b287e03b9086dd9084a5b2afbf81311e15d46b877808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f622a221251660039b420d71c52beaa42280f20206df73c0b0900ac1cf477a59"
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