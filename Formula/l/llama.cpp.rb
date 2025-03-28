class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4970",
      revision: "c7b43ab60855f752ae79937fb93d561bc30b69a4"
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
    sha256 cellar: :any,                 arm64_sequoia: "48c0fbfcd2619f4bd8123e7c8bb8f1b6c7c03ca6af7b3ca7bcf9f6cd8de0c71c"
    sha256 cellar: :any,                 arm64_sonoma:  "e8d94ad55b0c66e450bc9d5c84cbc62cbf82630de5f11fdfd9a5e4eb1efc6b82"
    sha256 cellar: :any,                 arm64_ventura: "de9ef7ac1bea2308bfa1342310d226b0292d8d244f794c26e40f7ad46348a970"
    sha256 cellar: :any,                 sonoma:        "37e282b51a50b31020579067a84a89084cd833e52702ddb8e48caa5cf0b7f09c"
    sha256 cellar: :any,                 ventura:       "3c0fd12b5a6cb1c7c88665eecdafe77532d84e4ce29b914f57004748832ec099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41255341557468fd7a60aa2af049efe1c8d9f033d3bca7803c40be237422a33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "304aff65972694dc19d3726c479c5e914c4d3eb9ace4c079157433bc5320b677"
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