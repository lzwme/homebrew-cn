class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 19

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "16c7b5126233e18abbe398eb0d7b4c0f17f8ccd5f47d7f8441ed99bb30072c1b"
    sha256 cellar: :any, arm64_sequoia: "897d73dc0bce927a84649e2b82a78e009dda7e903620fc1a22ce13998a949155"
    sha256 cellar: :any, arm64_sonoma:  "c7d18ead1e75932be311942c45893270057f3d3e072b24941f0ced0f1ac65c23"
    sha256 cellar: :any, sonoma:        "05a73acafa27a7cba3dfb573ea071fc3ce30633d0d82ecfc7ff843feb8878004"
    sha256               arm64_linux:   "4ee5772592b857ccc678a5d6a14d8fdfa448dd9026be95c1c63c1a2d068014b0"
    sha256               x86_64_linux:  "0dcfb0722f2dd181195ae23a7a3195faae1c4d5035990c035bd9373aed9d75a3"
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