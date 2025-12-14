class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 21

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "07866ea0990e17c8091207542c8f645cc7f4a3852c82c96877946ea0b0afb207"
    sha256 cellar: :any, arm64_sequoia: "6e47305a9c40e4a8e07ac5df386b56f3183caa3dbb18bd77298b84f46bde2f6f"
    sha256 cellar: :any, arm64_sonoma:  "f44bbbe8b44a999ae647325b0316d8b5924f23a32d57ddb147500e49161e4031"
    sha256 cellar: :any, sonoma:        "631339f728e75402ec3046d53b8f35f3c938d9c8380b2f363a126c8981e7fcd7"
    sha256               arm64_linux:   "c14d79227bfc9addbb0d1390e5454cfff11d18b112b128063a4d346c64ad32ef"
    sha256               x86_64_linux:  "570c006b0477b1842274262d5d1f52eccac8cf5050853f4e8ad4e17a0a102928"
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