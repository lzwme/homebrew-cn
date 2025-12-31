class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b7580",
      revision: "2d6c00a9b8bb4d72f4f43c6521ff1061088e2c2c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ee84a1c050d24eb4e5a2d14135da03f624babf74673cae9d2480a94880a9ff2b"
    sha256 cellar: :any,                 arm64_sequoia: "f58a652b1e373d19687b3ee742ee13b606f96cb4a41b157898f0b260076be126"
    sha256 cellar: :any,                 arm64_sonoma:  "8eef6c80b99351642ab015ab638a9e8f8f97be1fd1018cfcb00e17ca7f439fd6"
    sha256 cellar: :any,                 sonoma:        "6b588d83ed5f49634456d03da344ac7d83121eb1bb386d2e2061e45fc8e99e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa68732726628b8a6125e9ae8e2fc335a1e11b5b54e24f603e533ee3fb8b20df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8aab3cc03d8c3f431cae4ecd51e2ff24e6e98e8abc0dceaa2562d746873ec6"
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

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end