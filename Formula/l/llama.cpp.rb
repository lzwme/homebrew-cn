class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3772",
      revision: "23e0d70bacaaca1429d365a44aa9e7434f17823b"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20f06b9d1b2583f0daa854ab7608ad96f71ebefe9bc09dca53deaf612231cdad"
    sha256 cellar: :any,                 arm64_sonoma:  "4e1c7a00bb61b6446b9a8b04545cb16f86cca389aacc3805ca7ce2de0851f744"
    sha256 cellar: :any,                 arm64_ventura: "1783bfe52255d941abb26e7387f33c350775e0294377515aba88c4204e5a651b"
    sha256 cellar: :any,                 sonoma:        "664288a1a2fd1fb2e048e6267fbb5fdd031c4f7feaa59f89ab872179873ac601"
    sha256 cellar: :any,                 ventura:       "d3abc02123a12b01c18e76fd1b54bd178c81d6e6b2e66f3a27e82242926229f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a56bb6a3a83edb18afb3fd400cfa85f3415ecff0fd89ddb7d930dcf3b90a36db"
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