class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3606",
      revision: "90db8146d56d83a605f2c475eca39bcda29cf16d"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1cbeaf50b373191084d3d7dabdc4208a5e9677b2a0d32daa3d28962082396f86"
    sha256 cellar: :any,                 arm64_ventura:  "66249359ce7c7ddb9333c99f715841e3182329244bb0198fc852aff65f61e28f"
    sha256 cellar: :any,                 arm64_monterey: "d7382b5d8fcc33a90198f683943c4e541d2cfd0235cbc9c75f2b1fe17115f4af"
    sha256 cellar: :any,                 sonoma:         "d35ed3cde8b38cd4dde2da3806a17ea93fe8da859b701ca0cb982440c835f3a2"
    sha256 cellar: :any,                 ventura:        "bcbd82396df6fbe27bd60156feace0e91af00179a1251dfd8b008d575f09591e"
    sha256 cellar: :any,                 monterey:       "81b15cf521e118eb8e5bb9b0d8ce3695a53eae8c4742713c6e11573162680499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d192fa11cd2adf358d1d2e724252107cd5d7ee9ed14e24f8755caa465fb3a438"
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
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end