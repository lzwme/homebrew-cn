class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https:wiki.openstreetmap.orgwikiPBF_Format"
  url "https:github.comopenstreetmapOSM-binaryarchiverefstagsv1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0-or-later"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "17d198ccf1e7853b52d271673f4c6cb915829baa7e815f241334b616098acc88"
    sha256 cellar: :any,                 arm64_ventura:  "00a33c62396b1f2ab92a4e31a31e04ca46726a9690a188d97b34d947bfc3c85e"
    sha256 cellar: :any,                 arm64_monterey: "fdefbdbb3d47f82d1b9ff3884d70a1710897258c6017fdb7a848a435449810cc"
    sha256 cellar: :any,                 sonoma:         "db3ef1e8759bb598c780e34a85fac51383f578ffa41f33bc4f6d62d02f238427"
    sha256 cellar: :any,                 ventura:        "2826291aa7c0bb921f135018a8bbf2f219da9fe0c5eed560e15a4fc2ddf1b272"
    sha256 cellar: :any,                 monterey:       "70dce24b4b8444a8301f3c9827808f4aabdc66d10c16c87fa0b1324fecb07a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd734c94a03dcdac4645e6016356c1622258cc40b2f663dee68fe4549d99d225"
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