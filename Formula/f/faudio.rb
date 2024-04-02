class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https:fna-xna.github.io"
  url "https:github.comFNA-XNAFAudioarchiverefstags24.04.tar.gz"
  sha256 "a132b6c6162a5e110210c678ac0524dc3f0b0da9e845e64e68edd1a9a5da88e3"
  license "Zlib"
  head "https:github.comFNA-XNAFAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ea51f95566d363feefefd8d3915e81a2c3414bd214452d1b78eb657b591b23e"
    sha256 cellar: :any,                 arm64_ventura:  "a10f4fd1bc35bc653590fc52232e9c4fc3a14a0a8acd4c1203a48fcb7378c00e"
    sha256 cellar: :any,                 arm64_monterey: "6d22416c62bfcaeed47cf136b0239a97ad3253eac63df897bf8ea31b26410ab9"
    sha256 cellar: :any,                 sonoma:         "15a2f031b3b0f3b20b2f2a72d0a1dfb60cab67ec1258c7059fda60b0197e0c13"
    sha256 cellar: :any,                 ventura:        "e445b8fd84e750f34628912a46f7758e1731bf194b89d42fa30241570362ca0a"
    sha256 cellar: :any,                 monterey:       "77a2cf9fab229eaad9430eee6ea84d741d8a0fce848fa30f941dc05867c5a973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6320418966dfb07f3d3f6f6108892ed5a3404c8a3b9aa5efe04b654b7f967138"
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