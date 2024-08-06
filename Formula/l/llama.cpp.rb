class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3524",
      revision: "bc0f887e159c0d78c28121e2c8b5c58094170875"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d475ac96a3dcc32659212ad23e9531bcb60ba412af75a3817a811a79d45cae7"
    sha256 cellar: :any,                 arm64_ventura:  "2c6521b5e16df7b133d8b9fe44ae378f9dfc16294be3fdd48670cd02d94a09e0"
    sha256 cellar: :any,                 arm64_monterey: "8e8abed46332e43c5b8635e3c3e805c01c5076bf1c5a1141a18380bef658f23a"
    sha256 cellar: :any,                 sonoma:         "a44e56864726225b60027b4561ea4e064731de9017d6a06bceda7f43adb66fb1"
    sha256 cellar: :any,                 ventura:        "2a1e39149fb9ffd7eb85369d0f7761bc26db45293b7ff9e82d52ad2191dcf35b"
    sha256 cellar: :any,                 monterey:       "432557185c09e22f3a815a57d601f7c0065a4bb9a545e8af6203527d02be115d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644af471628c3fe7476e069dd3e45b936fba99d5a3bd7acb2dcc7bd9f10db6db"
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