class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3853",
      revision: "6f1d9d71f4c568778a7637ff6582e6f6ba5fb9d3"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d2916149df9609945722c478b8218f218f88393da1d7b5eb351591a1855a3d98"
    sha256 cellar: :any,                 arm64_sonoma:  "4c0d107c5d9b64f593a692dccc4051c1793daef3a674d1e9df6c518c2fbd46d3"
    sha256 cellar: :any,                 arm64_ventura: "3d6918dbfaaac8e7c7f5af166f689770e3edcaa23c7afe8569a7114a4d82b914"
    sha256 cellar: :any,                 sonoma:        "9a6e8718338adac8d1ab82f7c010ccda06951bd06af1597aa88286457ae04b07"
    sha256 cellar: :any,                 ventura:       "42def3ca3ead6c8876a51eea735c891192e01179146a0fd9caee9b02dcd20462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f5e51402fae06f00c21ff878ef64429cf6e1441cdffbdcc26a4b2d91ae2005f"
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
      -DGGML_METAL=#{OS.mac? ? "ON" : "OFF"}
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