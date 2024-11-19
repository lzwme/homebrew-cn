class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https:ihhub.github.iofheroes2"
  url "https:github.comihhubfheroes2archiverefstags1.1.3.tar.gz"
  sha256 "f91760f7e8a512fa4b2b5eb02d852d358106fca50faa13db942d8314926ca6d8"
  license "GPL-2.0-or-later"
  head "https:github.comihhubfheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "abd77f3c7b0748848798a86ced7e6db626a2d5e30a2a8d209d70ae7614b3699a"
    sha256 arm64_sonoma:  "73c1a13e93e0ebc14e5f8c50cdba23ccc54b4865e4d5ede1a1155e89946fd817"
    sha256 arm64_ventura: "929d227e53e7e290a1e65ea7571c97e0a0866e2338dc3d634474d92cced55603"
    sha256 sonoma:        "d73ad420578eee3093ac978ce6c3718f4b5baefb723c3b7a25517f0a3edaca7c"
    sha256 ventura:       "90909dd4ea8a865b40bcc9d5c388bae3e4cf5011c91bb9c018c0656dd03dc2fa"
    sha256 x86_64_linux:  "0831cfb9c4feb8703f716628d937685457164e33d88bb90ae2269ca28a9379f5"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "scriptdemodownload_demo_version.sh" => "fheroes2-install-demo"
    bin.install "scripthomm2extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  def caveats
    <<~EOS
      Run fheroes2-install-demo command to download and install all the necessary
      files from the demo version of the original Heroes of Might and Magic II game.

      Run fheroes2-extract-resources command to extract all the necessary resource
      files from a legally purchased copy of the original game.

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