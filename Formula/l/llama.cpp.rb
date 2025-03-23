class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4940",
      revision: "fac63a3d786b2a0f97876c30add02cb525a9648e"
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
    sha256 cellar: :any,                 arm64_sequoia: "3152ca0f67db3d9bd4dd3e324328f2a1a09e413a5e32fa60d868dfc90f149bdf"
    sha256 cellar: :any,                 arm64_sonoma:  "c89bd860a937f33381d177b515090c6fc37e1efd1b38d040274e37a95f9f87d5"
    sha256 cellar: :any,                 arm64_ventura: "7501c0be2526c1d732304d789edc1ae0ee6f9cc679188a0a73549406e682fbee"
    sha256 cellar: :any,                 sonoma:        "3db99d5dbd75715e61e6c797b31bcc77ba00de1d2a71c7e94b7a90fb8f9658ec"
    sha256 cellar: :any,                 ventura:       "0c3138a09b272934287f287d509dcbfe155e5a67e40ad9037e71b3d537360650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "888e39abe3051b68df9901c493043d5154d53317f7368a960c9642bc2e19f543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1db2d9f0c6d736676eafc0c77c242a844be762c1ca56139065b3ce85ec98d3d4"
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