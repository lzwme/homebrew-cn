class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260527-git-167c561.tar.gz"
  version "0.3a-20260527-git-167c561"
  sha256 "4d35f7a8e3b8bad97422a10c676f276df00cc67e3d4779df7a9573e7effa0843"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8bf3758f811b7d1a3200ab35bb98c3d95446d3c8ec71ff2ecc8c724acfd29e7c"
    sha256 cellar: :any,                 arm64_sequoia: "cdd4794324fe5f2581dac9eac7c692d1b129e3eb02cbf08762ffd55ade527396"
    sha256 cellar: :any,                 arm64_sonoma:  "424c6f5c5346000773210869b3f360d2bea11711843ecdabcf40f078959bd725"
    sha256 cellar: :any,                 sonoma:        "391f5fd4cda680229b8fecb424328718da05e60ca550f2a109ec9c1ae2122f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cd2d7c00715bbda7655763f48a4058b8308ec1debb0bbd135b0ee5cb9c0c657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c25848aad9e219085a38fae8d4040166a52252c907e4272729dfc6585aaed8f"
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