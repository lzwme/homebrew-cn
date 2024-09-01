class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3649",
      revision: "ea5d7478b1edcfc83f8ea8f9f0934585cc0b92e3"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5cecde3e87afa28b4caba14087bc855555c1d68d84716c4bd1db67d377f257a7"
    sha256 cellar: :any,                 arm64_ventura:  "713f7ab49452b8f7f22e3dfd273d7ea959ccabe0492e97ffb542455b6d9d628c"
    sha256 cellar: :any,                 arm64_monterey: "7f6332e7876e938e2847c0c21dc9c0a26f9fe12abfe0f7ac6df9b4dbd110149b"
    sha256 cellar: :any,                 sonoma:         "f01835c39030a40061219bdac4b179e5ef66afe8a988f08e9e1cf5fc4697ed77"
    sha256 cellar: :any,                 ventura:        "3647b2fb97aebc2309416c5b7cd8c0ecf0b7e37f7e36b6b18e6c67ac41e86f7b"
    sha256 cellar: :any,                 monterey:       "17c2ee644e06df53047f8d533914dc8ba469473852896e427e3b42fbc3fb8029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e651463f4bb1e1ff2e6e23a692c3ce50ef5660633d1dce523c8ab66f24444a8"
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