class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3639",
      revision: "20f1789dfb4e535d64ba2f523c64929e7891f428"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80448d75984392735856733cdb4d2ea0fe29446ac45715b2ba827996523fc972"
    sha256 cellar: :any,                 arm64_ventura:  "fb3215ecb81cb87476f2957e7952b3a7a1fdd886730e91e9b0ede39b33ebeb9e"
    sha256 cellar: :any,                 arm64_monterey: "8cc58a9065ea219586f683d186f1ca5597787e6c06dbc607986df1ecc36dcfb6"
    sha256 cellar: :any,                 sonoma:         "77abe0774cc383a1ef1478ad5fe026ee456ba5f4b07b039c3ed9819302b775e9"
    sha256 cellar: :any,                 ventura:        "cae7e7cb82489d470f2fb08a1034d141f088f02697222e1f3d186682ae812208"
    sha256 cellar: :any,                 monterey:       "f1910579eadfd8f533f50de23a9c9eea9916f5b4deeddcf2e5e7e24490e283d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96bfae6ec529ee4bd38d16cfc6f176df35619faae8bc74483d0812a7b22639fc"
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