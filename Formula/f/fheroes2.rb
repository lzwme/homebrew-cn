class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https:ihhub.github.iofheroes2"
  url "https:github.comihhubfheroes2archiverefstags1.1.6.tar.gz"
  sha256 "2c4465806c308c8e3992a67a925aad70acdb9d0f4b5d2171969814682b8aad0b"
  license "GPL-2.0-or-later"
  head "https:github.comihhubfheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "6241afabd172b4bcc4266b9b95340fb4b265b6b6cafbfeb3b9b196d2408864d5"
    sha256 arm64_sonoma:  "19c8372a5558e1a6f76c9a45996f0b5bbf9d394d1ab57bc0f20e85697e989c60"
    sha256 arm64_ventura: "5b509e78cc795c03649812bb124e5c0df5f52668b534d0265706a7d1319767bd"
    sha256 sonoma:        "5bdb504ccda37443ed7ba2bfc1c603ca610d6d5fdc1794f77804e01cde7080e4"
    sha256 ventura:       "3f0a65c7cd34df289f08ecce2034e48cd6f0d99bd9a46f4256da32343c55d35e"
    sha256 x86_64_linux:  "764b5282e3addeb1007e414630aaeff3f5f5a456b866fe17886b1f45f8e0f3b1"
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