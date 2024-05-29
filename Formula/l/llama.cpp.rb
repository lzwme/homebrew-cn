class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3023",
      revision: "ee3dff6b8e39bb8c1cdea1782a7b95ef0118f970"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87021b5b6e1d22a0380d9133e2cf2c0a0e3ba21522e1d3d50d15fda2547e9322"
    sha256 cellar: :any,                 arm64_ventura:  "203e4e5a9bbca968f06fbb9cb808dd5f70b5e5ea93e8f4ac056c0400ab42d7ec"
    sha256 cellar: :any,                 arm64_monterey: "6ed01dad6f038a06fc6e2ff344bec9a67273fb424659d3ddf1db659f06a05011"
    sha256 cellar: :any,                 sonoma:         "461f11a889c8fd15c16196259c7f367d4f283cd7427b0ecfe61845095a8c4913"
    sha256 cellar: :any,                 ventura:        "908038fbc2550de6ffecf326abe6af97c87d2cd8887851da792c36e55a3b60de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72f48658cec31bb91f47f372e711e61a32c21fa15ddc0e779e8717eb10448b3d"
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