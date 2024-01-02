class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https:fna-xna.github.io"
  url "https:github.comFNA-XNAFAudioarchiverefstags24.01.tar.gz"
  sha256 "28839f2f962180e0f8e0d3cb10061758f3cab7ea7eb92a8ba62ae6d0077e9fb6"
  license "Zlib"
  head "https:github.comFNA-XNAFAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e908483ba1333b43d07d1d0774e0b6efbf96b45cdcc6e3b30ac2dabea406ea5e"
    sha256 cellar: :any,                 arm64_ventura:  "09c0b6c7cf8b495a3f01054c3ae38e5d575170369c424cffc5655cc78fca99c2"
    sha256 cellar: :any,                 arm64_monterey: "459d8e1faa466ce7f8432a03458e72b47825b9051000f8fe1f4d3d87de84fc1e"
    sha256 cellar: :any,                 sonoma:         "04836a8433d1daaf35d18f894b13b2d6e2ec6505e64edb0a64355d6ed837f364"
    sha256 cellar: :any,                 ventura:        "8d70ede21ce90096d3cbc21e8691f78c402ec495f8a7fecb0500939f1fd185d7"
    sha256 cellar: :any,                 monterey:       "baaa5375da30dbce38c023a14e473d754b9702167788362a4b13054ffdbf39e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01f953d9cd856a5bef7afc593ba7d0aa78dc5bbe3942b69b4a3806968c66d38"
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