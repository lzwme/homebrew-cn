class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4273",
      revision: "c9c6e01daedac542b174c235872569fce5385982"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40630bc1d03d13f2500f5936efaededd76a2f5ef3525c301a5b35fce85c5cfbc"
    sha256 cellar: :any,                 arm64_sonoma:  "72df07bfa3c61f45b21741a07e2c16ffc89015a051bfc229b839baa27ec73b68"
    sha256 cellar: :any,                 arm64_ventura: "a12614612f18b23b68c166ef972941eef227a227ff5fc699a99be17392ea664c"
    sha256 cellar: :any,                 sonoma:        "35b1240aed18a802f7c4e010d2159d88d0de0c685f6799cbf6b961e4e619ed17"
    sha256 cellar: :any,                 ventura:       "d6342c795ceca89702da009529724e4e61e0e96743d4151643d466351a3c725f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "599b5a3736c2c4aeae9d64a761606c06baa8dd4219bc6a01efb9a524acf13b72"
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