class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3398",
      revision: "8fac431b0692e88cdc55250f29f8d4386be82c5d"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca7623c69d3d330ed115acedd984ea8e92e26acfe2c5fb6e9ce6a950a42ef657"
    sha256 cellar: :any,                 arm64_ventura:  "b6991a978d9d53d1d9a5f18e42429f5f4a2ef53dde05f2a3e23dab563a740b7a"
    sha256 cellar: :any,                 arm64_monterey: "c853f5cebc69f4c4f1c674bed5921968440e8397e8c042d357cfbe4a0ab7167d"
    sha256 cellar: :any,                 sonoma:         "f68cc6e6e9e5c5eee3639ad11d8ed815263b45f3a7f04474a705bd54701b41fa"
    sha256 cellar: :any,                 ventura:        "4f05ccfd4b7435dfee0a1877611159121e690c6279110a18b70d0093a3aa766b"
    sha256 cellar: :any,                 monterey:       "c074af7680d5b63457757626efaefdaab588dcd28b60d3370a51293f392f520e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48fddeeb52cf6780262c9e554e35fea0664710d9d1138335980e0c346d9f3eec"
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