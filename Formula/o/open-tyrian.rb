class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://github.com/opentyrian/opentyrian"
  url "https://ghfast.top/https://github.com/opentyrian/opentyrian/archive/refs/tags/v2.1.20260912.tar.gz"
  sha256 "2d4df6182a728bd769b7779db9ae8e8ad78f0f5cac49dcddd4cf63add5d34d93"
  license "GPL-2.0-or-later"
  head "https://github.com/opentyrian/opentyrian.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "cd8a4de6acd0f0bf69ef4f242816a4fc42bf358e880592304e7b7fde7e058a6d"
    sha256 arm64_tahoe:       "77519dcbb29c59f0f228f0893f6e60df670347c014ceb1562b7087a6d043e027"
    sha256 arm64_sequoia:     "c5af0ea2a937a564417aec2cc1cf61c86c6989af58d8865ff1f8a807436f8ab1"
    sha256 arm64_linux:       "80893be946d65076b3021696aa923d1f8f3e79993dc8a5d07ec47b440efbbdfb"
    sha256 x86_64_linux:      "aba2ef182229cfefe39f136ad3d21bdffe04db954df182508371c2342f6475c7"
  end

  depends_on "pkgconf" => :build
  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  resource "homebrew-test-data" do
    url "https://www.camanis.net/tyrian/tyrian21.zip"
    sha256 "7790d09a2a3addcd33c66ef063d5900eb81cc9c342f4807eb8356364dd1d9277"
  end

  def install
    datadir = pkgshare/"data"
    datadir.install resource("homebrew-test-data")
    system "make", "TYRIAN_DIR=#{datadir}"
    bin.install "opentyrian"
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end

  test do
    system bin/"opentyrian", "--help"
  end
end