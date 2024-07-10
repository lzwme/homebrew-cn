class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3356",
      revision: "e500d6135ac42c4a23baf6a9a1a934dc023e5c7d"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f46fe4a02875880a3cf04e58595bcb377c31d0e7888a4b6dd6dbb1359572e7a"
    sha256 cellar: :any,                 arm64_ventura:  "81474baa866b2b93d9f26a076cfd2ca2134eccce83cdbc0ecd48a624f2f8e97b"
    sha256 cellar: :any,                 arm64_monterey: "48c7f468294e732f30046fa81ce4ac20690347a3111fd660c046711d1e6c095c"
    sha256 cellar: :any,                 sonoma:         "464b9560d7cbc3d7c92f46a25dc66c0d519555cd1facde5a90de9e63ef77e71d"
    sha256 cellar: :any,                 ventura:        "4b934de309ea2ce25b84406966cace4508337fa75bf70c8622e853d3ac5dec64"
    sha256 cellar: :any,                 monterey:       "2d7eb679d03f82a5492e53fd226abb29c8166ac2dc03e6f814a74a32b8333c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f181f46407fae14fca35200d2d3dd22538525b5c6d72c5a4ca21bfe1619eec"
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