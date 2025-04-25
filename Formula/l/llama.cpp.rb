class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5180",
      revision: "13b4548877326fdabee3e831b8cfd65d9844383c"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*0)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0eb98a6f93ba5eaec8c9f4e11a752d4f33a0d553060ce0471c7363939c2d14d9"
    sha256 cellar: :any,                 arm64_sonoma:  "3a428496e55944724b09fe885e0cdaf35908eb3b44353c05e076eca9f57ca99c"
    sha256 cellar: :any,                 arm64_ventura: "34cb85a5ff0f34e79962ef6c866e4bb27579770c883b9d1231f25f280ab07885"
    sha256 cellar: :any,                 sonoma:        "7a5e4d103f2c48b8b7509af965d21fd7487ebf9af0d75110177a2885518c5a5e"
    sha256 cellar: :any,                 ventura:       "4a118da1535c6e1cbc54171d89598e5b1121de27a6ea4f2908cea16f61ca0cb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeabe99b519465e19ed3e7e9f5bd6b01eadb4fe5327f85a75dd1cbb97ae4814f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cbea984980dd2c04daa53d05499c09bfb1d0772a56b2ba01e2ce12a601a5b78"
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