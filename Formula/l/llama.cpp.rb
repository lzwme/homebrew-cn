class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3058",
      revision: "30e238b246f8002cc6eb7cb79afe242243f1f66d"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d9c754b915a47910cb5bfa4ac08e00e754403ff5cf40564964d72e6c78614f3"
    sha256 cellar: :any,                 arm64_ventura:  "623479635ad2a47ed640ffcaff21733d4415a26fc773a79efa672b5a6256f88b"
    sha256 cellar: :any,                 arm64_monterey: "6f01f8d30b1dcbf10e86e74b69d0f564805bc02047ad5b2c88ad4e581884503e"
    sha256 cellar: :any,                 sonoma:         "c48018ae0b4721d8b171d346a012bdd7f9572b13db992b09296ffeb23bf4063d"
    sha256 cellar: :any,                 ventura:        "cddf9abc090b23f6b411432f86befc0e099e90a183fba23554671b5d34962e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dde82f646e5fcbe40672f308e624e70f76b5f9a964bc2527f1b5282468ac70e"
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