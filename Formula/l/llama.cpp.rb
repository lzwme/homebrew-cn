class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3012",
      revision: "10b1e4587670feba2c7730a645accf8234873113"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a66b162245067396a5321efac84fbfa62ecd1e1f6954bdcd364d95e1b5d3c095"
    sha256 cellar: :any,                 arm64_ventura:  "a88f0d3573c3a81036a1d689900e346e080986e2dbb74f1788207546cb0d94ec"
    sha256 cellar: :any,                 arm64_monterey: "87b563283cdabe5804ab796cdba9aef0e7a7e149615ee2926bad10fc390d5ef2"
    sha256 cellar: :any,                 sonoma:         "bb30e4857acec669e757c4663396699a7e67dbca3170ddb2097a107072cc13bd"
    sha256 cellar: :any,                 ventura:        "608ba3fa03d65026045fee316362a62a2a470ca291fd00b36ea4bb06a6a5f866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "450e0c1b64f6a2836ff75141838de0fad60c60746f3c545806d8ac60b793366d"
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
                        "-m", "stories15M-q4_0.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end