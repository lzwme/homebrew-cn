class Libsoundio < Formula
  desc "Cross-platform audio input and output"
  homepage "http:libsound.io"
  url "https:github.comandrewrklibsoundioarchiverefstags2.0.1-5.tar.gz"
  sha256 "6454dcdabfea428443cf88402ca0c8b37187d710b12c2758ae55b2f2a416081e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b478f5ab4ffbc5fa9abdbc31e76cc588728d73a645a4dbca7eda90d296d79537"
    sha256 cellar: :any,                 arm64_ventura:  "25ebcbaca3974335cd9530056a1cd1c2305d1ffbe618295844399cb82c34f852"
    sha256 cellar: :any,                 arm64_monterey: "ddedc1df3c487a6a73dfff4142c8f82f56c15929bbebf94df92577acf7ad08f9"
    sha256 cellar: :any,                 sonoma:         "b2e0388dc3a26ccfc94a2c682e23f39d0c7b800c81754f49d97da4255027acbd"
    sha256 cellar: :any,                 ventura:        "581aba45d3632432e4b4aa4db7becbc3abec37b32f3e0bca7e86e6ab8cba74eb"
    sha256 cellar: :any,                 monterey:       "3588ff7ac7a12f0c0fd1c7cf77727102261520b6fb2517b1ef4a53f4852d3327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93f53af40fe36e4584d615a325739a5b48406f2f0778f5ff056cc6374818daa8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <soundiosoundio.h>

      int main() {
        struct SoundIo *soundio = soundio_create();

        if (!soundio) { return 1; }
        if (soundio_connect(soundio)) return 1;

        soundio_flush_events(soundio);
        soundio_destroy(soundio);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lsoundio", "-o", "test"
    system ".test"
  end
end