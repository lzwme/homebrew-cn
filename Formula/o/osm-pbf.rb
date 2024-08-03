class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https:wiki.openstreetmap.orgwikiPBF_Format"
  url "https:github.comopenstreetmapOSM-binaryarchiverefstagsv1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c52a4cba8352a2f9a6bf211995451988d0856ff1b2679e8d13bc38c4fdedb24"
    sha256 cellar: :any,                 arm64_ventura:  "4d007458fd90dd2c08c69e3e5c0f5b1b1e16b73db491831aec863f78bc003e2d"
    sha256 cellar: :any,                 arm64_monterey: "f2516952057ddba353b9ed425b8c06f8b6a21085e05d0b369291ceec3306d942"
    sha256 cellar: :any,                 sonoma:         "a49349e8d145ddb76fa0c86d5e91cda6e7c85214903f209105f554dedf67864c"
    sha256 cellar: :any,                 ventura:        "529542e766816f1ae77a6d8df2d9f8aec86dd3fe437d8df11b88216d919b7608"
    sha256 cellar: :any,                 monterey:       "2761c2d118502d0a2be7e249c205dc549c3f692702d2068e34a1901e264b91f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e6474ad7991ec6a292a9920328cf2df4e1b9a576ca38611b5849718651e56c"
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