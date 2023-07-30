class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.12",
       revision: "849e92fa94dc7cf65eb756ecf3824f0fe9dbb797"
  license "MPL-2.0"
  revision 5
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbca372fd5d4c886b635ec37fc9eadf411707a52127da818b67db2398ef6c46e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebe8500b072b2d2db44f165126ee538fc66a006e8d8780ab7ac2e517302fb240"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6223a8453c7b65e9a32133bf0dea927eef7af85105dfbf7c07c88387e01f163"
    sha256 cellar: :any_skip_relocation, ventura:        "66972a3e940b43d550da78dc48ec513a0113d7d2349c63e4998a648df651fb35"
    sha256 cellar: :any_skip_relocation, monterey:       "803a1af44b3235b1338ed5ecb5575c09dcf73723d3f28127617d05a5750af08e"
    sha256 cellar: :any_skip_relocation, big_sur:        "08855a4cb551c8b4df952d96923831cdfc0abe4692a87d388fc9d253645026eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09354fb3e97fab366d197e9dd0ef3daa0d07452a208d840cc70a21331589150f"
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "libspatialite"
  depends_on "libzip"
  depends_on "pdal"

  # Build patch for xcode 14.3
  patch do
    url "https://github.com/DroneDB/DroneDB/commit/28aa869dee5920c2d948e1b623f2f9d518bdcb1e.patch?full_index=1"
    sha256 "50e581aad0fd3226fe5999cc91f9a61fdcbc42c5ba2394d9def89b70183f9c96"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/ddb", "--version"
    system "#{bin}/ddb", "info", "."
    system "#{bin}/ddb", "init"
    assert_predicate testpath/".ddb/dbase.sqlite", :exist?
  end
end