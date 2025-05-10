class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5330",
      revision: "17512a94d636c4b6c1332370acb3e5af3ca70918"
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
    sha256 cellar: :any,                 arm64_sequoia: "7ab32ff555aedd9df502e8187ef4c12d8a8996a9f4d0564d3145d3b8d7abf066"
    sha256 cellar: :any,                 arm64_sonoma:  "323094cc4ee06cd29eb3d827aece056d80ce0e5f1c778101fcaf779c7179277f"
    sha256 cellar: :any,                 arm64_ventura: "ef80869f84da914b0772d925de9fa46c27bc6538adbb4790b8c09c54dea8b953"
    sha256 cellar: :any,                 sonoma:        "a97391572f5fd9e91f19a84a4e6a2999c4b5314802559cf892d33a1b40475f21"
    sha256 cellar: :any,                 ventura:       "64e0e9993e49d8d99d08d55ace66af248fa520f684b2a6a10b9ca2d599fbf0c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6bdbe5a3f9cba60cc5881f13e3545d7bec59b5ecdc1649af54d092e6b8d3d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "475279f8af86160ed5ccca31563481353b3b5c465c581c2334956aea21a96731"
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