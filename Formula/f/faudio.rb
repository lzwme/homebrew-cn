class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https:fna-xna.github.io"
  url "https:github.comFNA-XNAFAudioarchiverefstags24.09.tar.gz"
  sha256 "696ef2a0fb4c6208f239f21803ff3f39041d92db1769cf19e390782be07430b6"
  license "Zlib"
  head "https:github.comFNA-XNAFAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b5429882fd12da1f178d9bcb8ddfbe56dc51b545a844645920dba4d4f22e7527"
    sha256 cellar: :any,                 arm64_sonoma:   "2610e0a6df98f7a1ba145c308f9dc427b504bcedbdbf5a4ce40b894e11163744"
    sha256 cellar: :any,                 arm64_ventura:  "87a5f90472e36a7c0a39d988e73e858f6a7783de56d190c1df2bf6730d0b565c"
    sha256 cellar: :any,                 arm64_monterey: "629f3e0e84195a346e00f4c11533e4250cbf6b0b993c39e9fda8df66a8fe74aa"
    sha256 cellar: :any,                 sonoma:         "26f0b456993313104a10ee2748d1f7f862ff7da59f8b681b1a4128ef00ef53e5"
    sha256 cellar: :any,                 ventura:        "68d06f85475f01e4e14ac2f8745012ed8de992f7d9e787c484d6595ef95467d8"
    sha256 cellar: :any,                 monterey:       "58b97cbd947995f4980770bbc451db37b0cdcdc8217d1106151d1cdce36f633e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2eeaf9fadcf29ce664273d7da3fed06e6875c9dca758fd38fcd401a823f1f3"
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