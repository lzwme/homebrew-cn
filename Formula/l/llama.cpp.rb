class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3580",
      revision: "828d6ff7d796f48b2c345f6be2805a3c531a089c"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e443dbcef6c7ac2c05f36605ed22a40428160d37b86a7c555cefeeb5ba59648"
    sha256 cellar: :any,                 arm64_ventura:  "cab2bbf8e4a79f1ce2c5b4f7a59b5a01968ba2207c9a5e4f3b4daae4e16c8a0f"
    sha256 cellar: :any,                 arm64_monterey: "9ca7c5b156c22dbb6237ff6da312d14b32750cfec57883054c988093e1a3219e"
    sha256 cellar: :any,                 sonoma:         "a292662d9fe45db0f87d6f2dbffc8fdaabf027f0fc433110fdf1408855ac514c"
    sha256 cellar: :any,                 ventura:        "eb4cc47aa7ca57536d1f33e0e84887d92cfab48f0914d99421a9d72c340f277c"
    sha256 cellar: :any,                 monterey:       "91f3a923f0577aa2b439c4360a5a3f0b7d05f09a975a006e63bd941b86613f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbfafe91452928b004c8356b9741d79cb14adff20c39b01bdc55c21f4dccb21b"
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