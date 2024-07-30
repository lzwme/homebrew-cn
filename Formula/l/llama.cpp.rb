class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3485",
      revision: "6eeaeba126ff701f3e8f79f246805b7023709972"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "719d2a0c1d7856dc883df7da01c982bc70990e9d609485d824c5049c84e5f550"
    sha256 cellar: :any,                 arm64_ventura:  "3f9c552bf1463fe539898b08240e5f188ec357b42589271cfa19bbc3b3a7da37"
    sha256 cellar: :any,                 arm64_monterey: "57ae5c10a61ceced35ba55e177136b223645edd4444513c03485c76585d69b4c"
    sha256 cellar: :any,                 sonoma:         "f310a0dbe3e0d671e855690aaf98fba4a301ec3284059eb08fe0fdc7a80e3f7c"
    sha256 cellar: :any,                 ventura:        "bd0ae601ab2f6133dd59f78d179df1de9a72430caa9a34bc4c2f044d5f28c4aa"
    sha256 cellar: :any,                 monterey:       "9efa8197934a430c829e3ded8ae91d73cd7224ddef142bff173c5b4552e80878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28639063d74b3d587c659d7e42904ce7bec952e09ba035c71ecaa171128b562b"
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