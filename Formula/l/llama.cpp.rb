class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3274",
      revision: "49122a873f54615626d1b49a2a39013ed4be98d5"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b89e48b2d00e6b0fbedc5486f408083465cd07adcf2ef23811ff7badae4f99f0"
    sha256 cellar: :any,                 arm64_ventura:  "6640608ba6c11fee278204f56ab13e550fb9d3fc1af943002492fcab5cb758b5"
    sha256 cellar: :any,                 arm64_monterey: "be127f71cfe0bfba8e386b5312111cd91587d45dcfe898850c88ba57a7a60335"
    sha256 cellar: :any,                 sonoma:         "6a644cb23ddf9050ca8f4208ce30695ca8238179a57d7298db894e126427310c"
    sha256 cellar: :any,                 ventura:        "27c2bd6f310b2e1715de46ae1eddf52728537f2f262f182f3e3cef97f2e22992"
    sha256 cellar: :any,                 monterey:       "0f1f232b1da600d9a95dcffd136bd844df8d35ac54a744caa2f38e6c51be6222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54664f87d696dfe33574658235172e39a03de1634f33cd8fe16bfc55b0f6786f"
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