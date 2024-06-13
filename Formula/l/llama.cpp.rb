class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3140",
      revision: "a9cae48003dfc4fe95b8f5c81682fc6e63425235"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bbbdca54877ec7c89009526a5055c822e5d7753f5c7b53c512e385edbe63fe7"
    sha256 cellar: :any,                 arm64_ventura:  "0c47fc12ffed2a81847c38fc21bb0ac2cff3eb6877eada5272669ea8aced0cf9"
    sha256 cellar: :any,                 arm64_monterey: "e5aa1330376f86d6c1d1fb406bb5c6157ac7318b62b920c0e5941f590d41356e"
    sha256 cellar: :any,                 sonoma:         "af813bebe9bf4f96771788c100c8aa5e15d9c9f6727bf4d237ea4e6b14e52aac"
    sha256 cellar: :any,                 ventura:        "6a29942d9ab3aad49562f794af3479f882f04f2f428e57510ecde33442f2ece7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db28cf1407f010e0c4e747e47600f8276f8d7cdebcdda929546fe71236aae1dc"
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