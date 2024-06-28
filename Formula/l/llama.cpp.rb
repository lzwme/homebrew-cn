class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3256",
      revision: "558f44bf83d78242d4e5c4ab98d0be9125cb9780"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97f33c531267c42919576fe75a0948a1356cb33e09675568d84529e1141eebc1"
    sha256 cellar: :any,                 arm64_ventura:  "d0001825a4f6093c5f3770dbd73bda771d279bf39e4f04eb033c8c422186d268"
    sha256 cellar: :any,                 arm64_monterey: "a9a0f192dd8c392c7dace3cfc2cf6c04efec9e8afeeeb2b4f378f0d8e98ce869"
    sha256 cellar: :any,                 sonoma:         "3fafb8011ab0c73e1dc23e6e7d5a7b581289acd5043c38b5a870a469cda23302"
    sha256 cellar: :any,                 ventura:        "a759100dd315369f9d5466102c6382afc9ac46fa74b221c3c26cb60f3b3a272d"
    sha256 cellar: :any,                 monterey:       "e3281aafb32666bf1547b35ac9ff9ddc5b76dfbd203299a3c69517414ddc03f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da561c4fde71b07528c36afe6e0f2fb80655d4976af04d7bfd07dbe2b6573a6"
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