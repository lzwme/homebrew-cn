class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3495",
      revision: "44d28ddd5caaa5e9de573bdaaa5b5b2448a29ace"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40e704dc0fc5d5fd7f15acdc32ecc9e99e3c1a350ed89ba57e35e01e189162e4"
    sha256 cellar: :any,                 arm64_ventura:  "496cc13dbba9353d5216b28f47ee72665942aecb58bd7469356773e0ef5cad7d"
    sha256 cellar: :any,                 arm64_monterey: "40e6a5ef81c4017bf1c08f3e1f04e341987060596dfb40379bcc05cb90ae2188"
    sha256 cellar: :any,                 sonoma:         "b98625ca41e9a907572050269ee31fb9f7b60a3fa1800e83ed20c31c99a9fd46"
    sha256 cellar: :any,                 ventura:        "0eb824fe427cf3c19bbafea23a6e7e8f7ad2e2c8056e6a8ad8259ec68a718963"
    sha256 cellar: :any,                 monterey:       "9648efdd584dd9c1e2ae3900eecfd79df9b809d8d88b055ba97f2a937915812c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d60af2d3f3d53429aa0829834c65d2d839aaaeda818c2cbd110f22c7a31ad93"
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