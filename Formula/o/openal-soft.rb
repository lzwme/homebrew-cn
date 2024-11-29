class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https:openal-soft.org"
  url "https:openal-soft.orgopenal-releasesopenal-soft-1.24.1.tar.bz2"
  sha256 "0b9883d2e372d4ce66d37b142ab10b606a8a0ed3e873d1e070b1c878b695425a"
  license "LGPL-2.0-or-later"
  head "https:github.comkcatopenal-soft.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f554886b0ec6439d9bce62e1c9366e3b9e6701684623d32cb5e22722af81cf42"
    sha256 cellar: :any,                 arm64_sonoma:  "4eeedcb744c19227effd117238aa8fa562d6237c87738072454af9e22e49e307"
    sha256 cellar: :any,                 arm64_ventura: "dc85440affb0731e8311d4e7358bdd4936b774bb3120f94f571c8a56192f4bea"
    sha256 cellar: :any,                 sonoma:        "7e9684ee6b8e773e7744d14360c20ffc89e5ed68c24079d82bb6de606dd63568"
    sha256 cellar: :any,                 ventura:       "a8a83d2bb5faf2ae57dc972dfff9f5cdc835dd006109a678037878f61bdea152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4263b4c8c10b5cfcc8085e7980a850f298dd4869a5d64e6f642fa23df3493b7"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    # Please don't re-enable example building. See:
    # https:github.comHomebrewhomebrewissues38274
    args = %W[
      -DALSOFT_BACKEND_PORTAUDIO=OFF
      -DALSOFT_BACKEND_PULSEAUDIO=OFF
      -DALSOFT_EXAMPLES=OFF
      -DALSOFT_MIDI_FLUIDSYNTH=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include "ALal.h"
      #include "ALalc.h"
      int main() {
        ALCdevice *device;
        device = alcOpenDevice(0);
        alcCloseDevice(device);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenal"
  end
end