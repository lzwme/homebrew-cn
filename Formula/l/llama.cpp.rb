class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5260",
      revision: "626083faf73faa54440f934bb1741bf443be91b1"
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
    sha256 cellar: :any,                 arm64_sequoia: "70d0449ed238e58aab8243bf5d63b82efcbc73708de13269cd016df08db431ab"
    sha256 cellar: :any,                 arm64_sonoma:  "64287221b838c3ce7330cca813d8dd440e2d22acd3b13a5d2c95537f457f6c42"
    sha256 cellar: :any,                 arm64_ventura: "ddbd9b009991b5c706487d64dd3a517e6b667e7e4335b937929269681740c581"
    sha256 cellar: :any,                 sonoma:        "352cf6ce9be17b5a62b725bedefe160e5a0d7258c71b1daae24b6aa6a580baee"
    sha256 cellar: :any,                 ventura:       "c8a281757b6eeba94c6211d8936227bd17fb3cc3fc96dbcf158c2e32204e2de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fa09ba7f4c41e59c022c895dc43a3269392cb32b26597cf2fc83912f48259d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c00a4ee59d157b8bbaac267cf8b6b018a0b7aedc5e6aaabbdd9d508ce9c49a26"
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