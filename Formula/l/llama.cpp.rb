class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3083",
      revision: "adc9ff384121f4d550d28638a646b336d051bf42"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "957cd502f65b8d0c939647c9ccd37c3e595ccd20b22b31453958a6d80ebe0eae"
    sha256 cellar: :any,                 arm64_ventura:  "b89a986bba0851318c52243d11f1b1953543c69483f0feab2922396f9c285996"
    sha256 cellar: :any,                 arm64_monterey: "cdde8b28d79b74b72a10620d9ea5a9704e50fc3bd8ce1425306e8d9eb7bd78fb"
    sha256 cellar: :any,                 sonoma:         "97689f7daefd5aedb88dd0cf270fac9f6884697f31796060991342b3b6a86633"
    sha256 cellar: :any,                 ventura:        "9bc6198f4fea29d206ad85b7c3538148a2216e62af0a35559e4560f4e11bce65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f08c226fc9b6725dba242ff0977849a5a0ddd1d68ae55eb8aa6274aa80396e"
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