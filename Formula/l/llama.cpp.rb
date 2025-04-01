class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5010",
      revision: "a8a1f3356786cbf8bcc3422e3c8737fc33b453e7"
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
    sha256 cellar: :any,                 arm64_sequoia: "fe0227c9f25eae5b626bd2171643b9738d9d70a7dc75561d0ed41e2d472ba8c5"
    sha256 cellar: :any,                 arm64_sonoma:  "ae746c9f89a75784a3dd97ae83b9828edefc404fa1341c599250f25db2d2054b"
    sha256 cellar: :any,                 arm64_ventura: "da212a20c03cd1a1ff64feeb051441b2f79cd764cbc7b03a1ce7e35d49159e8b"
    sha256 cellar: :any,                 sonoma:        "5c07a3bfb16ad3c4f530eb763801ac3fda764dccaf3a6e0b3b16c9b67b5cfd3f"
    sha256 cellar: :any,                 ventura:       "7a83748a905d3704de5437ae0ead5f15595df93c61e9c75c077321e20bf077d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c6714ff36e56ff919c875b537f228f8257207ee3325a8629b9bb06470061d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a04bcdc44ec433db786e1a70848d74989effccee833e796644fafa2d250959"
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