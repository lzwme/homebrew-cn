class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3153",
      revision: "0c7b3595b9e5ad2355818e259f06b0dc3f0065b3"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0a57b25ed5efd2c9ecfe88c322b143ef38874169015e57eb860f09d8f194add"
    sha256 cellar: :any,                 arm64_ventura:  "aac0ea45d87f0d3b6ef261e1bc2f6411ef8e8889000ec992a631f8129839cd95"
    sha256 cellar: :any,                 arm64_monterey: "b84b5bddb5e55c63792cf2db15145724155121af2f663ff996c12217e898cb34"
    sha256 cellar: :any,                 sonoma:         "e0e46f449d949f37e57b212060193201d861fcbc6e6db2a652023734c98aa44c"
    sha256 cellar: :any,                 ventura:        "6846c723b6990466067897422ba2a4b267ab3baa5f34365b3d4cdf487a591aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866d498f0c92b1e7a33f5bd3e997efd1193b2cf120550a167608deb53a0cae31"
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