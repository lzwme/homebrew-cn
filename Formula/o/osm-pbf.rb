class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https:wiki.openstreetmap.orgwikiPBF_Format"
  url "https:github.comopenstreetmapOSM-binaryarchiverefstagsv1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f86b0e680557df6ece854d02457c6c266f18927b92dc9f28ed43b899597cfc2"
    sha256 cellar: :any,                 arm64_sonoma:  "24adf83b2fe7fc6010b6f333f612980909f1820ddea8e59ee89357d542ff6c1d"
    sha256 cellar: :any,                 arm64_ventura: "89884562f91649f5bfe93e95ef69c4613874bf10a182aeda7681ff3148b2520e"
    sha256 cellar: :any,                 sonoma:        "84b3d4fd512f521eb2d8cfccdf181af851f45f95bd0e0881ab22feddce8dcb69"
    sha256 cellar: :any,                 ventura:       "022ee2ecd13c79af92a0b4b6a99a12f672b55044c789da5e035d3b4d5746e25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "927c6cda348c6c730ddc0aaaac5a414613784ae214444765c70543f8cffb676d"
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