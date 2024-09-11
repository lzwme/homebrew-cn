class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3721",
      revision: "49006c67b4c6cc2e7c75a875b4d6e161ebae287c"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "937e9a1b0debf536bef793d85d03793a1436dd5a89bcc032c3b3d8e6941666ab"
    sha256 cellar: :any,                 arm64_ventura:  "9177fb99e8948801ca64c9e1d65eed23962586269009136791a286e39c56273b"
    sha256 cellar: :any,                 arm64_monterey: "f54757423fbd2d6b11eaf622a99b2f9e23b29a31f6ec7ad601496f6c568024df"
    sha256 cellar: :any,                 sonoma:         "b7cead710bf95fa731e83b097550ea47588248036a4ddccad1fd7ae738073718"
    sha256 cellar: :any,                 ventura:        "e2c5739426a5b899a3be3d6193a8b8770bb14bf8aed2d9c174fc180170d42445"
    sha256 cellar: :any,                 monterey:       "59b9e2f1491c2a6b0c8560021340dc1260149e0239682bb505dc7f9d1924b4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26d48b1f3d36d78bd984ffaa64c58a64f6c04b71c5052c1387b8585ba931d27f"
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
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end