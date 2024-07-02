class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https:fna-xna.github.io"
  url "https:github.comFNA-XNAFAudioarchiverefstags24.07.tar.gz"
  sha256 "f7cd15ed111133fbc1ac387fa3e715b3a67d5e4cf59d8e290ac85d856d92367b"
  license "Zlib"
  head "https:github.comFNA-XNAFAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93b38e0d432d0483a878fe3364730f1d4cc586b6e2beb007016aca552186c984"
    sha256 cellar: :any,                 arm64_ventura:  "dec7e98e44be44d8b2035d6623176749e6fdee72d04e1007cf526168522950b3"
    sha256 cellar: :any,                 arm64_monterey: "40555c329a69eaf627d0bde4245788075185fbecb6fc37969e4f80ce85482eb4"
    sha256 cellar: :any,                 sonoma:         "f2f60f070358527b795341461821c542dd6579de25640662bde307421ab2fad0"
    sha256 cellar: :any,                 ventura:        "bbebad65af54f5905b52a9a0fb607602d0ac8e68215e8c9782d8c3b9fcc86b47"
    sha256 cellar: :any,                 monterey:       "88747ddd5a152321110e2aee904d0465aa6ccfa8bedf292dde39392d371590e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8c010662f09a18de1ba34058cc5c8895a5094615f9c8fb97f05393743a1345"
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