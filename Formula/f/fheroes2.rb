class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https:ihhub.github.iofheroes2"
  url "https:github.comihhubfheroes2archiverefstags1.0.11.tar.gz"
  sha256 "2c8d0cae584fab65ba39e8b999e942d0d9220747a16e11af3dfb8427d3b85844"
  license "GPL-2.0-or-later"
  head "https:github.comihhubfheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "d303f4472384fad364eff6355be40310b732bc0bb34d01bca0e0d7ade9ab65a8"
    sha256 arm64_ventura:  "8770f1c8887d33d63c425189df07be08c197a06e97d6469ea39bfccc67034a44"
    sha256 arm64_monterey: "2f8612fad3b1a1b09525bb62b2c3aad25c5bb469d76e3ccb02c2315c1b1f0861"
    sha256 sonoma:         "cf72d47c7a41c86282f4539f590ba62698e62fba5a330bc381c041618f286b2f"
    sha256 ventura:        "9cda09b384dec18c22485077bb47ce50d0e357e57fdab15c2bc8369eac301781"
    sha256 monterey:       "57abde1b886c32ac141700768fcc6e9f9f0627b36fd54948d561af32d604b47b"
    sha256 x86_64_linux:   "72d0a5140ba4492d2faf9b4f3ad1b120f2f1bfb8f9e1c30f5de9f1fd97747001"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # Fixes Sonoma iconv issue `end-of-line within string`
  # Remove in next release
  patch do
    url "https:github.comihhubfheroes2commit18ab688b64bc3a978292602b27cf4542bcb07f7d.patch?full_index=1"
    sha256 "f1f1f716c4b2ef8ec99aa336fd9526e45f95b3ecfa002d398b1ec9cd955e8000"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "scriptdemodownload_demo_version.sh" => "fheroes2-install-demo"
    bin.install "scripthomm2extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  def caveats
    <<~EOS
      Documentation is available at:
      #{share}docfheroes2README.txt
    EOS
  end

  test do
    io = IO.popen("#{bin}fheroes2 2>&1")
    io.any? do |line|
      line.include?("fheroes2 engine, version:")
    end
  end
end