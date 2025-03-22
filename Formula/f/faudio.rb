class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https:fna-xna.github.io"
  url "https:github.comFNA-XNAFAudioarchiverefstags25.03.tar.gz"
  sha256 "1eeb1d2d6ed038a68e6b0a02614d4c7f859aa0a22c4a64e0bd49c26573823ae8"
  license "Zlib"
  head "https:github.comFNA-XNAFAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "06ff8f79bbe8aec1eac0e65f12d7e1dbd9100aeb0964ce2ba8ad31a496958556"
    sha256 cellar: :any,                 arm64_sonoma:  "a0820b7e3eb75072bd4a65a11ef9460bc0840610f6892579ab3d252f847c223c"
    sha256 cellar: :any,                 arm64_ventura: "b0bc5992afc998bbecc54008ea630f39c1cc021f1b1341ca57c24e3c8be665c0"
    sha256 cellar: :any,                 sonoma:        "00546912a32e5d1edb1765d45806e11c35926a6a0de8c04d760a02ef7ffc987e"
    sha256 cellar: :any,                 ventura:       "a45049fd6468b21b7bc015029926f7bc7afaf95a6a8fb5aed0a223537e2ac110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92cac5ed4120629ef46b4f472e24b6c50fa915d09bde8f17348855820443e5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29291583a772e335c12e610ba81156ce9f5132da0acfe5b4d59de571422d6f04"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

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