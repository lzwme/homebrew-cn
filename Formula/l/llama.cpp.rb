class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3479",
      revision: "345c8c0c87a97c1595f9c8b14833d531c8c7d8df"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6eb0ea5a5cb75a808668f322c65e2a54a9a95210eec6bbcedd0e3d34630b50f5"
    sha256 cellar: :any,                 arm64_ventura:  "1d33c9920a4f7b4ae5a6373959963a0c745310fb7166342fe42cf6ce2d06ee18"
    sha256 cellar: :any,                 arm64_monterey: "930f2cd58c6243149de088693185dba338c5ef10643626aa9a7fac9928385f70"
    sha256 cellar: :any,                 sonoma:         "2b4cd609d093a340803673402e4fc26cde58c3a65955b6d606b3ecc853886b5a"
    sha256 cellar: :any,                 ventura:        "5cc862243b12b65fc5dd0950595de1b0625e83d20b34a0754cf2245bf51ea276"
    sha256 cellar: :any,                 monterey:       "e6f457b35ed5910bebe913218429e2ccfd626a860bb389d459e97bc0a53bcf7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d8e1e5b72a50bec7c09061fc88d0e1cb27813018a83ca6e01dac3926d1edb1"
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