class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3613",
      revision: "fc54ef0d1c138133a01933296d50a36a1ab64735"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94343506eecb16ebede1a98e06a533ba2baff9aa52fc1eacc5dcbaf5be0d401e"
    sha256 cellar: :any,                 arm64_ventura:  "1f02a011d82242d1989dc0ecb1e6ca868e8e6c7165de49dec9e9e752da04692a"
    sha256 cellar: :any,                 arm64_monterey: "67f70ed053840bb150f9e9d680190882282f2083923dff67e5d7ec866729e242"
    sha256 cellar: :any,                 sonoma:         "61f5c10cab3da8a6c892f706ed62a93156d78a0b71d75800084fa2aee05a74f8"
    sha256 cellar: :any,                 ventura:        "05c20e3bc2650886d3a52e6239f2ce16fcd39829dec534ad32e63b75f28d220e"
    sha256 cellar: :any,                 monterey:       "e74f805c3d77ef6ae498fb11d73ae00dd3cf41a535b2587538dcfc889c89f64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3344b2a720fb62ac56d4e47a5c77e1d41f9bfbbe01ba78f562434f26e4a40d"
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