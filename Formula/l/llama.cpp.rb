class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b7210",
      revision: "2ba719519d950c5a62c00cdb8b119cc0914c1fa3"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4bdad8721dc18520f4c95c4e1605064b444b8ef590f172a7f312255428dcd36b"
    sha256 cellar: :any,                 arm64_sequoia: "51d7844835d442b0354e725bc5973836770ad2dd26d2ab7d33efdb51954225d3"
    sha256 cellar: :any,                 arm64_sonoma:  "1a00688f6fdd7f6e78028339ab3cc611a0b5b4f19290a000b8a49e52f27a7696"
    sha256 cellar: :any,                 sonoma:        "f2c82865744d3c9407e8c6917575ae6dfcfc9ddb15737081623bc38aac1e0370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9425f5c82e898188ae2e391e18db8b206416a94c38007250d530a39f31a541fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638e730becc7484c6d05d5daba8fe387eaac8d41e52d34442474968f7b3dda1b"
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