class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5640",
      revision: "2e89f76b7af2c0b827be785e445f2e2b3e52e1ca"
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
    sha256 cellar: :any,                 arm64_sequoia: "79e8b9e04f5babd0b84296391619e4daf13e527b07a1355de7576fc3aeb6cd86"
    sha256 cellar: :any,                 arm64_sonoma:  "b79657efc87fd159696c161c762909d7fd2e32882ac7176ab1caf1ccc1bad914"
    sha256 cellar: :any,                 arm64_ventura: "850e4c535bb3fb1c7511351432bf45f0acc3bf62f41d9999a3e2012bb0b5029d"
    sha256 cellar: :any,                 sonoma:        "c41c79f67027f2a807f8bcb94163c0015d2afac15d0f993a3cdd992e58e2a6e7"
    sha256 cellar: :any,                 ventura:       "9d2f3815651969a7b851ee31267f15c137daea7c79be746dd3a2d9726c07e331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83916832bcd33ea8776fe08c53d45b97b8fa8b5d9376da65cfb064a102b990db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cffa08428ba071dd836ef1f16bfe92c703182c5f9e4a7beca27286fd37c1b339"
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