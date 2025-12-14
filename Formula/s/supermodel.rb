class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20251213-git-9ef1f87.tar.gz"
  version "0.3a-20251213-git-9ef1f87"
  sha256 "2f4950c2d6543a28181c9761612ec280e7e68f14c76f56eafc2f3899ebf427f4"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc404ca6f80146112835e98a26937755291b8e9fc3b07ad6b5faa7d9f4d86244"
    sha256 cellar: :any,                 arm64_sequoia: "80d0bb0fca9f15c80da0e0e2838211136d13a7a3c32fc57443b328404f8b7c38"
    sha256 cellar: :any,                 arm64_sonoma:  "fbb292627c68b493c711a70c06139333827f1c8b5b51aafd964f645e583e7d6f"
    sha256 cellar: :any,                 sonoma:        "a4bc195df88b4b0a9b4075f8886559c0ed846b0b19c85593a9306ed26f152e75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d27e2f6ed65bf7873f5002cdbc9de0172621a3b898b129eef0a46688fb9a21e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24156db66f9c0eb15f1412f73587bd23417f8dcac27ac76684d3dcd24022773"
  end

  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    os = OS.mac? ? "OSX" : "UNIX"
    makefile_dir = "Makefiles/Makefile.#{os}"

    ENV.deparallelize
    # Set up SDL2 library correctly
    inreplace makefile_dir, "-framework SDL2", "`sdl2-config --libs`" if OS.mac?

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