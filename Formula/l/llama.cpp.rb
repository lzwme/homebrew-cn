class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggml-orgllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggml-orgllama.cpp.git",
      tag:      "b5770",
      revision: "b25e92774e2fa4ee3820e458d5cf43f40190f8d2"
  license "MIT"
  head "https:github.comggml-orgllama.cpp.git", branch: "master"

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
    sha256 cellar: :any,                 arm64_sequoia: "1ef4f0eb42f8b842290e30c435279e2ceb44c912b8dc3b3a73c26993772ee780"
    sha256 cellar: :any,                 arm64_sonoma:  "73d8e5fd933bb2a58d1bce4424afe01dbb1a173eb6cff9a3030c30346fcabc98"
    sha256 cellar: :any,                 arm64_ventura: "cc607bbb14e2a60266d4b6204e86def9ad0c9089b3aadc593552e9051ece2727"
    sha256 cellar: :any,                 sonoma:        "72e222ec4f9e5ebb15526d23de3c675621757a534fd751ac2b1715095a371de3"
    sha256 cellar: :any,                 ventura:       "324ff23cbfc56595ba108a3c89b9ac888f4e2a2eacfa8242ee3beba16a9a0049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d416fecc1563dd46c2d58c6fb5b7d59b5af1be9e4c7f6d999ab5f8383bdbdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b4e2a3529106ad7a83f2b2ede45b03c71c9c5a61f29f946eee101f4bc07651"
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