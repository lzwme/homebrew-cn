class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 16

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "66e4e5e852478749adde4b6c2a8754a771b7caebe774cd4a99f70b3c839d78f0"
    sha256 cellar: :any, arm64_sonoma:  "c50cc6b617ed4e0b9a62f1d8986ed1945fc74dfaefaa94615ec543db1923b0f4"
    sha256 cellar: :any, arm64_ventura: "115c1e86bf0ee190544cffa51f55a542a60e8ecf12a35a53e3bec3ee90de3f91"
    sha256 cellar: :any, sonoma:        "ec74acbd342fe243f9ab15ee79afa5037961066105758dfe9c8a3f20c392421d"
    sha256 cellar: :any, ventura:       "7b505bd01d761c89c169ace24489ab5ed3d4f4db0b15d6751e868af793a08b1a"
    sha256               arm64_linux:   "336c52d91b86f8f7dc63ce1772a7507e11a2b3ce3534d82269beba8187e74194"
    sha256               x86_64_linux:  "d4edcde02996d0c087843181a13ead8f21a51e75e2cf1b98d9dd95710095716c"
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