class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https:fna-xna.github.io"
  url "https:github.comFNA-XNAFAudioarchiverefstags24.12.tar.gz"
  sha256 "82feeb58301c4b7316ff6ee2201310073d8c9698ceb3f6f2cf5cc533dee0a415"
  license "Zlib"
  head "https:github.comFNA-XNAFAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f8d0559dbc099b8dde9096dbf0fc9bc1b97c604ebd41371b851722e9c2e31d6"
    sha256 cellar: :any,                 arm64_sonoma:  "c5b712302abe761b78ece64375f549e475845199ac434f421db74985d64c4dd1"
    sha256 cellar: :any,                 arm64_ventura: "c8a7d413dc7763916221ba6705f85c5ae1e2adfd671fca5109d0a4b3f66abab3"
    sha256 cellar: :any,                 sonoma:        "355c9d759827d99e9027bf7196d0379af3f3578621eef7e4af278e3fdcd28e99"
    sha256 cellar: :any,                 ventura:       "6ffe7881bb97c5896a1a073134cdce09c4feda150998123fbc4bec1f7fc547cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc1275b7cb5b506ea1700c1666f314ef71d56cc5874ebe0fb84bdcf6119c6950"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system ".test"
  end
end