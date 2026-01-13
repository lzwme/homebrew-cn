class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "54e0f234ace310a4256dc7d4fc707837f532a509cc3ef2940dacbdc4ebd9ce15"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "18d78acd3fa531508abf3f8a75b086a134a7688ce511482def2fa9ec17cf9a5f"
    sha256 cellar: :any, arm64_sequoia: "97d87aa4e111239db6d7be0b410b5521208d8d21ff68acd080a54de3ab54f472"
    sha256 cellar: :any, arm64_sonoma:  "dab1383b20a1af361da08449a865179bd512474fdade134e01e7176201f7dd3e"
    sha256 cellar: :any, sonoma:        "f41f25507da2d689ffc20be5f1fb272a237a6a546ed08b916d5a4a39c8976143"
    sha256               arm64_linux:   "f4dd12e7482ebd2a5e6fbc94c69aa0022b912014fdea8ef213f6589b8dc32de0"
    sha256               x86_64_linux:  "a1e4bc5d0b949936d3001a424e94374ba8fcd0d2c2011318ef0e5e59bc43e007"
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