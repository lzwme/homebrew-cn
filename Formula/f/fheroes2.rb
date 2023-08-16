class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://ghproxy.com/https://github.com/ihhub/fheroes2/archive/1.0.6.tar.gz"
  sha256 "c97835650a356d9e96a4157255930afe07b6e2472b605d0dbe1b902ece59d8de"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "4e542412db987f54eb39e8f5bf2105fbb97505c3c53c2aef1747f030f89a547d"
    sha256 arm64_monterey: "dd5b9f8301f312b879db8b3c0148f2b0bbbebb4e642f08bc30aa008a0b9913b4"
    sha256 arm64_big_sur:  "10bb9499eaf3a6e953efe4493e7c93d3569aeef41d722670567ef3c118193bd2"
    sha256 ventura:        "04d0cdccc7855222e006b4b23fe871f24ddee267ba54742f39215d1e1add4900"
    sha256 monterey:       "cf7394ebdc47a9653e713118b03adaf5c5e0656a383b134f523036cd8a5f781a"
    sha256 big_sur:        "8233d5b58c154873d0b51221f7a7c71593c8ac57fbb1f97bcbf74622d7121061"
    sha256 x86_64_linux:   "fffe15f2a012b70d8da6aa7653dba02a1cd468efdc2f535bd27262d1766b8d94"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
    bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  def caveats
    <<~EOS
      Documentation is available at:
      #{share}/doc/fheroes2/README.txt
    EOS
  end

  test do
    io = IO.popen("#{bin}/fheroes2 2>&1")
    io.any? do |line|
      line.include?("fheroes2 engine, version:")
    end
  end
end