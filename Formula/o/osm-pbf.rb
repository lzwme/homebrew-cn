class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 15

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5a253013c51cca37582a69ff6769a6c1277306fc2c25175512b4a7cc7b5ad37"
    sha256 cellar: :any,                 arm64_sonoma:  "beed6f4877987417ee88694e487f3111030c12d81c99b8b6e859f8fd8690309c"
    sha256 cellar: :any,                 arm64_ventura: "53785fbb81a02016a4a624033e7d8dab7178b248597cb7454189fbec1b2e01ed"
    sha256 cellar: :any,                 sonoma:        "d2dede7317be34cd4508e38ebd0cc968f6a88e98b37eb4f163838afd55377138"
    sha256 cellar: :any,                 ventura:       "ba12a27badb48c1492613bb1b1c33fbb6b2d8d0de9f850eaede25922845a18db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b4c928a358fb86a6c11f559b227cdf58efe165dd0d958d8cb802071efa205a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9b4aef7a1e91cc65127b639f8852e99164d224fb4930e109c55c3daa78fc5c"
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