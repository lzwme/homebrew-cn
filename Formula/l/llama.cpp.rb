class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8040",
      revision: "0ccbfdef3e0a635530aec490f863d83edc22cbc4"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13136973875295cd44f1f2d8b90220c30e662b92a371ea5118028bf54f83d3c0"
    sha256 cellar: :any,                 arm64_sequoia: "267dde8ec803d2d69cef49dda5ea2bf34f72404309049bda38babd010eac417d"
    sha256 cellar: :any,                 arm64_sonoma:  "68cb47403bc0f64b1ca01403e05221aaef005a6b1f08853dab5431b998fd7404"
    sha256 cellar: :any,                 sonoma:        "838d4759d3831c59364c7249129319cf61730dfb246eded964cb05499963edab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a33ea525382b93c42c74c7a5bf73cc60d625d3edabd9e3f84821a872721db818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc1a8a646c2b204a8ad7facc36cbb634af01432d5b96e4c66b1fe4aff28cb7d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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
      -DLLAMA_OPENSSL=ON
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

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end