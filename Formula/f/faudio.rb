class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https:fna-xna.github.io"
  url "https:github.comFNA-XNAFAudioarchiverefstags23.12.tar.gz"
  sha256 "15c9d2f34109fc981a86e1fab9a72afd591374f75559ad90c6447501aa02db89"
  license "Zlib"
  head "https:github.comFNA-XNAFAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53a6aa3142acb476dc9b337bd7814180f96b83c92a547952b46309f9a30e3f21"
    sha256 cellar: :any,                 arm64_ventura:  "269b3144ee5e616b432fe2d5d2fe6619e10bb6bfa6754001678abd05fcfcae69"
    sha256 cellar: :any,                 arm64_monterey: "f126a7c8895e7b1ad9f4ecf5b8286efe3735b68c25a26deb8450d198f66a39c5"
    sha256 cellar: :any,                 sonoma:         "9ad2bb8823741351bcccd5203421753864746ef963eaa7e1e640360a4d77d4cc"
    sha256 cellar: :any,                 ventura:        "9c4ab2a3c3fb22b16dcb9da0af021133b63190afaa7fe119921c97bd4a23d00f"
    sha256 cellar: :any,                 monterey:       "979bda6170fbfc9428038c92b26f871f44fcc95ad47bbe79a7b4474847793d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db159aa9ea20b7bfea61748dcc5a93491ffc98c3fd88d48e0e392822b09e30d6"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system ".test"
  end
end