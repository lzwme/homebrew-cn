class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4080",
      revision: "ae8de6d50a09d49545e0afab2e50cc4acfb280e2"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78b139ad52457d986c4cbe269322f66e7d6879b53d17a7691bce8a3984a56158"
    sha256 cellar: :any,                 arm64_sonoma:  "ed93b13f30fb2e70dd4d1f779ce1cc2dc88f1d7f153e267c3ccc7ba8a341aaa6"
    sha256 cellar: :any,                 arm64_ventura: "8f9cd62ad0f9aa8fae299fba7767febeaa3d1f8f5e75ed845597f7b2cec209a2"
    sha256 cellar: :any,                 sonoma:        "1ebf41d5c8a539981c52fe7b333d05ea8a041329c2895cd011e44d9fda2adb75"
    sha256 cellar: :any,                 ventura:       "1508722a01d0d6fd9264baeb4fea751548c45696af3f1fd044ee89eb0a2464e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9abddcc031d5a86f735b5c6276b4f703a4940ac73ee490b8d3e5e1e0d12ab2"
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