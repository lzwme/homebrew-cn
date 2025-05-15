class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5380",
      revision: "053174436f3b3cbb01077f26ff17809537b832c7"
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
    sha256 cellar: :any,                 arm64_sequoia: "a62203b9ee788647c004a089defb0598bdab1a523d511d17e18ed179b99eacf3"
    sha256 cellar: :any,                 arm64_sonoma:  "6336a4c8526f82030d7614e9bd4aa192e5d3a7771e43f824c29787aab47997f4"
    sha256 cellar: :any,                 arm64_ventura: "aea70cc21800463b5c1a344b9c43a0e0f6ef79c9506ee00872ba58d48959bbe6"
    sha256 cellar: :any,                 sonoma:        "31a50ac857e3e6397091d16ff26661318843bc48044a3630bef7ae58824e39fd"
    sha256 cellar: :any,                 ventura:       "3ab8ec1b8d57e73c727f486bf1cb5ecac4eeeb06007a4330100d0e76f508faeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "915d3972ba538350637f7f4e2d5de91fed6e9089754803823d911969e7131301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e7c7806b84ea26253bb693a116f414b9cfda3cc71e40296fc7836941025995"
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