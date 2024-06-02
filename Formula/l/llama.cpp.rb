class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3065",
      revision: "2e666832e6ac78194edf030bd1c295e21bdb022c"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "949d07e10b07515e8110df7a70762795e2721f7503066b57e81e8a5e7329cdfc"
    sha256 cellar: :any,                 arm64_ventura:  "58ad7a69c45bcc9cc959ef557ddeb7fc92257c0124f396574e5e7606f60abb1e"
    sha256 cellar: :any,                 arm64_monterey: "157e07eb7f99f1bc287a9ba6bb6f67e3271f7636cce0dad594b14ea1bb6d794d"
    sha256 cellar: :any,                 sonoma:         "14859f13531f5b31baeb3d2decfc3ef1f1bcf033a3a566481cc96c1c31dd0eb9"
    sha256 cellar: :any,                 ventura:        "e8c6c5642e9fd96b1e5209f9d47f45168dfe3b6a540cadf6c8760769e1ff454d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5028af3af3e3874ee9298fa24499a0e23defb5d9b025caa1812f0acf47ac648"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
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
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin"llama", "--hf-repo", "ggml-orgtiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end