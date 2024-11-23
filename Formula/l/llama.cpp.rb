class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4153",
      revision: "6dfcfef0787e9902df29f510b63621f60a09a50b"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "348d6a3e07e487eae5d4143f276ed220f3196dfc9ccb8065ecfb50c829f61dde"
    sha256 cellar: :any,                 arm64_sonoma:  "df6b2c61dcdcbbfc5c1b74e961d134f1952688455e55f82503fcb52f385c93d8"
    sha256 cellar: :any,                 arm64_ventura: "fd1a3285cea1885c9f9fedd64f691f0e157dad818ff13902c1b2b975a2bdcf06"
    sha256 cellar: :any,                 sonoma:        "7a1f0dabe011ea0ec1cf4a784649ff470f1e07a928d69991905ebc47bbecae41"
    sha256 cellar: :any,                 ventura:       "cf1b93eb50c965ec0dcd35f236c0719bff2beda20f407e6bfe32b6c4e828c21b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddd5f94fc5be18c988b16e3c9eab8ddbcd3ae60c5f01bb383d14ea15d0eed7de"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
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