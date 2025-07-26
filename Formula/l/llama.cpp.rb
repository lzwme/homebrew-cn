class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5990",
      revision: "e2b7621e7c265a6739225125cf9c534f471b3472"
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
    sha256 cellar: :any,                 arm64_sequoia: "d916dea4790896da9a32a5d96bcc0c14be4ee5c00dd7fb2a1c2ea34b40b7b0e9"
    sha256 cellar: :any,                 arm64_sonoma:  "d6a9880da9369c9430506a29afcb96e3b5d36b5ebcd9690c0a4b800e7daf984b"
    sha256 cellar: :any,                 arm64_ventura: "3280ff33af73196932ece7c5e063635b90fe94475d3a3b83d9e9aae174dfc633"
    sha256 cellar: :any,                 sonoma:        "00296e178e75e8344a3061a7aba9ea6a1e8ae8813e8a442c1dd8dd3271baf224"
    sha256 cellar: :any,                 ventura:       "99b119497746dd0f4a0797188f46a62b5eaadc25d2ed53eceec6ca3a60466a60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b02232fc3b70a652c15040a1e23d3b8aec313c0415a4d895c6b08df9b225d852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0077cba7212eb1393070c30dab5bc40953924ab17b4b553f0c4f2c47f6efc2c"
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