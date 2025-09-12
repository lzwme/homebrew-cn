class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6440",
      revision: "33daece86b65607451d0d4378d2d04ba6a20ad55"
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
    sha256 cellar: :any,                 arm64_tahoe:   "393e16565bf41c797f21773719669d8637752096549ccb3e1ebf5ef3e2adfca1"
    sha256 cellar: :any,                 arm64_sequoia: "9098e64d82b58b539cd4e87c69b5ecdb39835216b83401cff8a1062297f7709b"
    sha256 cellar: :any,                 arm64_sonoma:  "d56314f747bd384d9f2b68bc261fb99721ec6a2166b13d955184a79c765dcc82"
    sha256 cellar: :any,                 arm64_ventura: "267b671e4aeda8eeb29e423fd3bea8ee92e4f9f36e000d50853b1d8f6c574b7b"
    sha256 cellar: :any,                 sonoma:        "f08c2927f649cd89fa61d5285fa6ddb53465fed7c5e89124902687cf2804c2ed"
    sha256 cellar: :any,                 ventura:       "349efe9433ba3f6f27bc54d73e7e16ea2a50f2a19169ac18dd86b50d50f26cce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3f86e8b6baaf8b0ecc3c5910230e220a38bec46e3c59949cb8e577d4a4c5f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60190b5eefe58009c0368d373e6bd194bca9b19b16cb001c0c8278e737026196"
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