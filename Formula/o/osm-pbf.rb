class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https:wiki.openstreetmap.orgwikiPBF_Format"
  url "https:github.comopenstreetmapOSM-binaryarchiverefstagsv1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a2c8f54a76f4cb766c99f7453a457f5e31a7a7441cf754ebfee76481b436773b"
    sha256 cellar: :any,                 arm64_ventura:  "5d667fd775b91bc97926227f1a910a520321ddb3938a2cdc14818dfc55aab68e"
    sha256 cellar: :any,                 arm64_monterey: "7684205a6b63789fd06d842b39bd1512be2df200238cf0a193265a627c66c7cc"
    sha256 cellar: :any,                 sonoma:         "38a8b1c6a1d145fa72c5218557d2bc1ad93ea7e01e80fc1d707ec40f38d74764"
    sha256 cellar: :any,                 ventura:        "7c5a738094dcfa6ae7fcc1607fb4f23990e971b8f86c8efe7cb2c6ba713cfa5c"
    sha256 cellar: :any,                 monterey:       "974d6019b963caaddbbe6cec0e7df8191e4683efa85eaae9d3eef4bb5eb84261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc2b196a7104bfa17d78f5b0355b56ac944756b92714e4bc25cc2066568dccb"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    # Work around build failure with Protobuf 22+ which needs C++14C++17
    # Issue ref: https:github.comopenstreetmapOSM-binaryissues76
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 11)", "set(CMAKE_CXX_STANDARD 17)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resourcessample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}osmpbf-outline #{pkgshare}sample.pbf")
  end
end