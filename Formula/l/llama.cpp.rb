class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4139",
      revision: "3952a221af54b8a6549bc2bd4a7363ef7ad3081e"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c60ff393e1666b818eff27631711760fc8cd74e2cac6ab3bc4e007552cf1c836"
    sha256 cellar: :any,                 arm64_sonoma:  "dcc07c6d6c3a3f90f6e6c4572590257c8f17666f1dd4870d6e8c61a65cd899e4"
    sha256 cellar: :any,                 arm64_ventura: "f55ae0a558c68051f671b28a7b4a9bb27bf1290fa4c69212d85a4e982aed63c6"
    sha256 cellar: :any,                 sonoma:        "b45b2dc7c3b3a893eb7dfbfc603cf8ca08e4c999987030299b65f670b9f6cf34"
    sha256 cellar: :any,                 ventura:       "3c9e4071e19edee0f493e7bb14eb154cfd9baf0133ec479fbfcc7a5c563770a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88690bb041fca5163cb83a69e3c8c4b6224d1ae014ea263b63ddf0d52f49d23b"
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