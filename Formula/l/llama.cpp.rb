class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3578",
      revision: "1f67436c5ee6f4c99e71a8518bdfc214c27ce934"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89053437221af9457478675528675539cd05c66c6dce646ededdf5fd57a005eb"
    sha256 cellar: :any,                 arm64_ventura:  "6a05c5f34650ab2c094f72359c04f351fb1ab1bf55a9bc6b1c31c44bb040837a"
    sha256 cellar: :any,                 arm64_monterey: "245df535bd424f741c423abfab7a7341d37d8e604053c4e22f39b808ddd19da0"
    sha256 cellar: :any,                 sonoma:         "21f52ad2fee373635faa5374286808f58f0ddd63e886f51ce93acade74c5bae2"
    sha256 cellar: :any,                 ventura:        "eb2071d56fc11d2610c55dae6febcabd8c7d5584b5decea151319144a263aa6a"
    sha256 cellar: :any,                 monterey:       "751015ec166fbb2e5147356c1552335eea7b18584d8c19501c2315d545dde21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e66e0604c15cf528697ed6c08ca12d7e44ee5d9436ae7725bac27e72c7eca26"
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