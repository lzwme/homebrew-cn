class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3173",
      revision: "a94e6ff8774b7c9f950d9545baf0ce35e8d1ed2f"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c3efaeb97ec1dcd029354c179fce1fed7b042d83808b20983fa9e1b1c82ca544"
    sha256 cellar: :any,                 arm64_ventura:  "69ec94dc3c342b8674c6b5136bd8c3e30ef10489a5e7c58dffb05ebc310b1224"
    sha256 cellar: :any,                 arm64_monterey: "93a078708685fabecb3648246610c02ab3a4ab7e24276ebc32d3ec1a50de5b46"
    sha256 cellar: :any,                 sonoma:         "d5d02d142142af6e2138381cf47ae5653e875bfd38e46ce858f70cbb4996d7e6"
    sha256 cellar: :any,                 ventura:        "8dbe908e45d74bab3ecfe8a9827e015b876152630ba12b448092122ef6fda9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f498852f022da445563e86f8af235fb005c0bec4370a9572d65cd632a8a511ae"
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