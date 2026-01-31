class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260129-git-e3a6b05.tar.gz"
  version "0.3a-20260129-git-e3a6b05"
  sha256 "9e06d7778727d48a2adcdfead9cb6e12c1309fba4012c630edff428d9b45ae7d"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b79b760979d0a91584ad90b6a8eca43e4360a63d0d0d6574ae282e70091c7478"
    sha256 cellar: :any,                 arm64_sequoia: "b35ec934ad6f6995fdbe2932076ec70c6eb44023c0b9a01ee0884a06a923b859"
    sha256 cellar: :any,                 arm64_sonoma:  "e5d91a278e8beb1399d008abd35d8a3deac719d5aad2bd31f5a321d761fa0e68"
    sha256 cellar: :any,                 sonoma:        "40b4ff8d9fbd49e93df86bc51e01ddd67a6c9f3fcae0ee555a0e139217550c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df7963833da24fc12528f63d30cf720fd117d815d8d9fe092aa80d244ad753f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a12646aa03668e161360430051e6bde1c62ea97631542dd8fb6f350a5c8bffc"
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