class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3051",
      revision: "5921b8f089d3b7bda86aac5a66825df6a6c10603"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6bdaf3a6d504c4ca804a6e06f244487fa5756e092cf0b9885778a995e6be2110"
    sha256 cellar: :any,                 arm64_ventura:  "0b026a6b55800e58de6bbfdbbb8c44e86345d154a616aea143fb03dda7b39953"
    sha256 cellar: :any,                 arm64_monterey: "207eb87c417bf837d98bf3f144b418dc1cba9ca0aad041f0626bcc769540fdbb"
    sha256 cellar: :any,                 sonoma:         "7ae4189e66925773a924e9fcefc3524cd96cbd5ab501d567a579394921dbebeb"
    sha256 cellar: :any,                 ventura:        "f5c814a4cf20582a19a3a84a40190dd11acd01ba7a10f713496beaca122ca285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff02a43971277e2c6764d67baf4eb0596d8e63498dc6e785919d2dba1472b38f"
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