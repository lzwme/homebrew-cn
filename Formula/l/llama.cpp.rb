class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3039",
      revision: "975ec63ff26cdf96156d1126d86f75a395fdc43a"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "580a8d876e31b056325784836c795659caef6575fd65d1f0e708e245da80707c"
    sha256 cellar: :any,                 arm64_ventura:  "7339b56e0b5a1d91601c0e1f29c50ada182873a284a05b2603e3df872b34d830"
    sha256 cellar: :any,                 arm64_monterey: "74d965faa87a3e256179c7191af3b7007e6dea78441cda16453246e913cafaa1"
    sha256 cellar: :any,                 sonoma:         "542118ee00445bc115b55cc3fd88c18284c821606239f3ac633c48f8666de55f"
    sha256 cellar: :any,                 ventura:        "803065cf095e9e077754f0fc80ae7890efbb25192310e9800464e5c85df03fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d57cb4a3b7ab9c4c20a45730df5b0a1bb79eaf47fa37c3479dc350e4a21aea0"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
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
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin"llama", "--hf-repo", "ggml-orgtiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end