class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 17

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "289c9fe1c963357ed19bca491fee0b8bfd5b78f0bd5549bdd41e61d7cd99f2a8"
    sha256 cellar: :any, arm64_sonoma:  "b82ecaa1adb427d3f3dec198406e58894454f74db816715e9d70a98dae416a40"
    sha256 cellar: :any, arm64_ventura: "3c2dd65cbe46d4c00339604db7f54835fb5c5312229ce1ec32d05f8587488d0d"
    sha256 cellar: :any, sonoma:        "4079cb2d686ddaafa7578f30108e92b61320ee8ca17caaf993a41d94cc53581c"
    sha256 cellar: :any, ventura:       "39a7793160aeeab283cd679f66b713544c85163d27158cc4559eaad808fb0a12"
    sha256               arm64_linux:   "857e5bfbd1af69d7cf7bdcad60290025b0c9cc9090640ce26d0d9493e8f0ac5e"
    sha256               x86_64_linux:  "d3de1727959fb9bc677817fb6bb696782c693817be512a225eebd780ced272e0"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}/osmpbf-outline #{pkgshare}/sample.pbf")
  end
end