class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https:wiki.openstreetmap.orgwikiPBF_Format"
  url "https:github.comopenstreetmapOSM-binaryarchiverefstagsv1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bfde9dd610f68bb504ba322e89002ba6748159ec68f4d2f75d5121baf1489df1"
    sha256 cellar: :any,                 arm64_sonoma:  "f403ec60f7f48d8849c4ea8f4ab400739da4566ce6ea6614a833f2f46b3116b4"
    sha256 cellar: :any,                 arm64_ventura: "9032b996eec7fe4e2e7c1e8c0e81ac203369799adce9d1818277af79ee941720"
    sha256 cellar: :any,                 sonoma:        "c9ee683aef6e830405922df5e6897511d250c6ee1c0bb6513b34d897dae90848"
    sha256 cellar: :any,                 ventura:       "5024e2d88a9e8b758fccf3ec680311c924fb3a6a7c32757a6dfc7a273c39e153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f09a7a0663396d52376578dbaf11cbd6a712a8265458c4a84cb71112e9ad94"
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