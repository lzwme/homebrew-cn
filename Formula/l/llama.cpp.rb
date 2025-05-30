class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5530",
      revision: "6385b843a8dc8e15b8362196039720c58dd79fa2"
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
    sha256 cellar: :any,                 arm64_sequoia: "91e013125193e5e5c88e3df6f2620a88b6d16bb600709ed4077bc0cd8fe2c9f1"
    sha256 cellar: :any,                 arm64_sonoma:  "5ec0c45e6992ebdf2a3133efe06b768fd5ca8829bd8f4d51706b54b6a86258fd"
    sha256 cellar: :any,                 arm64_ventura: "d5890e1d14fc74388ea6112ba8615fdef30531c4112851d9168b1309028b2a09"
    sha256 cellar: :any,                 sonoma:        "66b907fcb135f7267729264a59130df0308efa93965e3fd0403135ffb43f8590"
    sha256 cellar: :any,                 ventura:       "30c3235adf57524c66a3b4802d6136ce18cf75829ddf80da7f594dc5a641c422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de83abbdae5ea40ba9ae0cda5f6c186dd27ba2913a64a8264db3d2c7ad716e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d8a6d3972bc86ec5bdb53fc1bd11cc71aabfad68eb8c24fa9c8c6ccc4fbfc1"
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