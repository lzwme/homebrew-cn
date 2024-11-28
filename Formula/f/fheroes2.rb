class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https:ihhub.github.iofheroes2"
  url "https:github.comihhubfheroes2archiverefstags1.1.4.tar.gz"
  sha256 "48ba1d8b6d246a7aac36d87c9e3826d47dc435ad0b35f2a160174c154998b0dd"
  license "GPL-2.0-or-later"
  head "https:github.comihhubfheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "909ef265ff8e9edc6359369564a09a6b4b1d637737e3541c833d542b685ce58b"
    sha256 arm64_sonoma:  "75649d254ac369cefd51233e1125e8b42a41d4fd5bf25e4f6a79ef5744f1c3c9"
    sha256 arm64_ventura: "9c74f8780bedb1f3ceefc7d7edf2e2daf0e3ab02c4bde6575f1376eb31224082"
    sha256 sonoma:        "46901809659dc48e6d5c2222a3125d8f7765b65929cab1a0ad1aff8f168cbfd9"
    sha256 ventura:       "fbf0b1c9c535a4de8e39e266220488135e85162453fcf765314d83ed0055113e"
    sha256 x86_64_linux:  "3b85f1f4f529f11c015b4272ed2126e9dd6683d820a7980d32384e9ff59c5a3e"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

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