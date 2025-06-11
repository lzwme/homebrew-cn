class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5620",
      revision: "b8e2194efc529378be45ab9b27d6648a5b81458a"
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
    sha256 cellar: :any,                 arm64_sequoia: "d11af61ec678d667b880a59eb4e8750465220590176e548fb057151f3aa44c7a"
    sha256 cellar: :any,                 arm64_sonoma:  "cf210db16efe1a821b473de843f7d03f6bf6f74df873dc215f6a059b256c13af"
    sha256 cellar: :any,                 arm64_ventura: "be509d1dc51c26c62ce9fafdb16fb7a6a681d7cd8369ae1d1aaffdedaa6f42c9"
    sha256 cellar: :any,                 sonoma:        "e383fa7b4ef00f9610fc3a1563f4389bca2d5f142badf882b9a0b124dff05b37"
    sha256 cellar: :any,                 ventura:       "697ac8d5c64d59c1b964fdea598506f66b9cfbb9477d1c8afec6f7c3789014ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2adc33ec1d23b9aa3565c784bfbcda0453d8fefbb70880c53f530dc3c65d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "246842060311be024266698d3cde5dec4f3c89dd9db15466d992fb526bee5a98"
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