class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3166",
      revision: "21be9cab94e0b5b53cb6edeeebf8c8c799baad03"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "38cf1a690ab074580acf0c86faf10d6f18bc66a8dfce7178d99fbaf77ffe0e3e"
    sha256 cellar: :any,                 arm64_ventura:  "849ad9fb208fc107098beb488841ce1caf31bed77c8bcae6c6d260db8e3e839c"
    sha256 cellar: :any,                 arm64_monterey: "49037e515b40366cb1ea871c2ba399cf76c4bba524eb8a44ff99bf8e87b09ffc"
    sha256 cellar: :any,                 sonoma:         "904157b12d237a34007ab05bd1fc8baf234912fb60409857f5e72f9b9c052cc5"
    sha256 cellar: :any,                 ventura:        "e18d8438d849a69912f2113bd80c90fb7dbc3763c43045e98b0cf0582d9ab605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b878f4f4c89d3e4858302566828d2e46e162a8e5c59c6e33966708b2401d089e"
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