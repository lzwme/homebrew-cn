class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260528-git-77d28ee.tar.gz"
  version "0.3a-20260528-git-77d28ee"
  sha256 "80085bbcb1451ae0f921e434c953639f9884e6acedf526fa7c8384e7f69995e1"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2929b217c1e92dc9d2ff73fe83e5915da3ac2ea7559c9ce97f86d503edfff2ec"
    sha256 cellar: :any,                 arm64_sequoia: "4d8c6d8178feb8162a33aaf3908f742e0fd187d452c4ad57f8d51e7d7a877512"
    sha256 cellar: :any,                 arm64_sonoma:  "b3273de0cef1922f10cea4e1f3e4f2e25f582f916e0576e3149a37bb40395fa5"
    sha256 cellar: :any,                 sonoma:        "e73a99db9b6df4feb68cdcdcce8db6eafde93c2f9a7646d140c8582aea88f7a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f482a9624c7a6b1b35c5736c84ae5f0645a1e54e01d91f410627b520defc30b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7d7be1a064af499046617848425a7330470b493655021b84aef7ead1b5ad845"
  end

  depends_on "sdl2"
  depends_on "sdl2_net"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def install
    os = OS.mac? ? "OSX" : "UNIX"
    makefile_dir = "Makefiles/Makefile.#{os}"

    ENV.deparallelize
    # Set up SDL2 library correctly
    inreplace makefile_dir, "-framework SDL2", "`sdl2-config --libs`" if OS.mac?
    inreplace "Src/OSD/SDL/SDLIncludes.h", "SDL_net.h", "SDL2/SDL_net.h" if OS.linux?

    system "make", "-f", makefile_dir
    bin.install "bin/supermodel"

    (var/"supermodel/Saves").mkpath
    (var/"supermodel/NVRAM").mkpath
    (var/"supermodel/Logs").mkpath
  end

  def caveats
    <<~EOS
      Config, Saves, and NVRAM are located in the following directory:
        #{var}/supermodel/
    EOS
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end