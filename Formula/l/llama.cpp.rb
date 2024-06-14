class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3145",
      revision: "172c8256840ffd882ab9992ecedbb587d9b21f15"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36de604a1b630eb531ef023c1918923a6d90615e169be006aa9e6b6d292633c5"
    sha256 cellar: :any,                 arm64_ventura:  "23d700c121094f6d3d5c16d3d52dbac83e5df24caa69511c798fa07093892525"
    sha256 cellar: :any,                 arm64_monterey: "f952cb5b25aba12dfc5bc68c7de474e77660e181e49e21617d399f852ee2506c"
    sha256 cellar: :any,                 sonoma:         "2fb1346d76a6df38524a13ed17dfffe0420851eb9aeb2b5404ace5091bdb841f"
    sha256 cellar: :any,                 ventura:        "c43bfe1c41f42d0abc38efd2a0e5f9ffcb90451a8f4dbd9f9430bb456a25d29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640fb0156177800302335ddb2d0b1ad9ac0ea65950fd0acfc9fb5993725d837f"
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