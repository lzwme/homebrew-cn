class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https:wiki.openstreetmap.orgwikiPBF_Format"
  url "https:github.comopenstreetmapOSM-binaryarchiverefstagsv1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b0ee4dcfdba76ed9223073be36b38058b689d019ae0ae32f542aeefdb75146c"
    sha256 cellar: :any,                 arm64_sonoma:  "11c51c71361def57522cb058ef38c6cf7ce56bd8b61784a77be4e71980e350da"
    sha256 cellar: :any,                 arm64_ventura: "33ba8feae6f2195a0792532bd223f28a8c5f89eef87caecd2063810ccf404622"
    sha256 cellar: :any,                 sonoma:        "df661a0d4d9d2af997f348c18814386c6dbf752e144b11afa200a92b909488b4"
    sha256 cellar: :any,                 ventura:       "16b8ba92476269351c4e160c1443ec54ee689e00accd9ac567c2f7518bbd253b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f6f91252cda29ef4fa6cc3a81b6af6ea1c3defebbcd0e3d3ded16c201dda79f"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resourcessample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}osmpbf-outline #{pkgshare}sample.pbf")
  end
end