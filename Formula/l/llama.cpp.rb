class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4658",
      revision: "855cd0734aca26c86cc23d94aefd34f934464ac9"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25a18ac697c2261d068f37dd3f2b4d0ba919e8a670ef7f28b67dda94d42bb7c2"
    sha256 cellar: :any,                 arm64_sonoma:  "5bae2f1239304e54dd190e26867d2b1287ec5efbed61ad5f034cd7138a586311"
    sha256 cellar: :any,                 arm64_ventura: "b7ede0b884301fd2a5b7b454ffa85794a54cea6832a0979c8e0c8cbb96a5117c"
    sha256 cellar: :any,                 sonoma:        "632bc5bff65d30c0f0c3bcc9bbb70031cef0e9c0210f3c75df14bc591b25cb0d"
    sha256 cellar: :any,                 ventura:       "5bcbf0a1716f9c436d0fe0f98d77f8d6b8eed1296f4a9f4b5735f918560e7ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0783d76fe44e59d61ace499c15ca5dacf7edd661b013b23a26058b82d7e53df"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
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