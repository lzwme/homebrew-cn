class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https:openal-soft.org"
  url "https:openal-soft.orgopenal-releasesopenal-soft-1.24.0.tar.bz2"
  sha256 "46cedbf46213d5f5ea255b7489a8b1a234c07c5d77bfb8e70f1c64ce09c8b765"
  license "LGPL-2.0-or-later"
  head "https:github.comkcatopenal-soft.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "886d796a0322bb7047d1197159552d0a71eb397d366f7e22726d87b02346c05a"
    sha256 cellar: :any,                 arm64_sonoma:  "0f58eeeca3a0cb4c1e91bfde22413242cb4728d2326efc0faa6c9a4bb5735a0e"
    sha256 cellar: :any,                 arm64_ventura: "4ddb71dda2bd8aec513ecf2bd4b822ff8fc45e385fce1f1f475bd3a9ecb5bb01"
    sha256 cellar: :any,                 sonoma:        "3db01360b2e0d0f31243527ecde405aceceaee7963d8aa444ed4972eae11f3f0"
    sha256 cellar: :any,                 ventura:       "1059c5a7a772d65b1edbc706ccd04b00205e7c8cb8b655828628b1b0433420ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc1601f3c6b79ff73d33bd6de9aa9f75da5f9201dfd029e6910ea94813ca5f0"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    # Please don't re-enable example building. See:
    # https:github.comHomebrewhomebrewissues38274
    args = %w[
      -DALSOFT_BACKEND_PORTAUDIO=OFF
      -DALSOFT_BACKEND_PULSEAUDIO=OFF
      -DALSOFT_EXAMPLES=OFF
      -DALSOFT_MIDI_FLUIDSYNTH=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}"

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