class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3131",
      revision: "148995e5e57b313cce2672f75610db58c6327a51"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5a7bbc0781a584335d3573fcfa27975a8c84163382186c47c44994025851f72"
    sha256 cellar: :any,                 arm64_ventura:  "cb16ed821bae2e10b35b02af83986cf74e4d54126944083d7cd6c90e93360857"
    sha256 cellar: :any,                 arm64_monterey: "64e2fceec5fe0234e6f0304ca4ee8cdf24222fa2c8d8bf6438a4d3a98470062e"
    sha256 cellar: :any,                 sonoma:         "3e0a232c72142bfb371c6600b348d03c5a68fb9eee54d1b542ab1062bf24dd06"
    sha256 cellar: :any,                 ventura:        "0887b56571ccd50605dcb841ee77f6cb58b8a8b08f2889c58c700916d373663d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54006eabb00d05d46865fef650523671c4823f38188185dddf3094bdb3b96c9b"
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