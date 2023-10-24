class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://ghproxy.com/https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "2746236e29659a0d35ab90d832f7c7987dd2537587a1a2f9237d9c98afcd5817"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "573a6d0cbca5c40f8ce9a57e0ac5aaf86b3bfd70a9c69bccaa004708d6f468a5"
    sha256 cellar: :any,                 arm64_ventura:  "6c96fe4d10286631208627a42893110b6ac0625c2a611d6975fba7b58631cb7d"
    sha256 cellar: :any,                 arm64_monterey: "7cf7239a265be6463301f5a0031628deb3c836e4e033184c4839c520ecc267f8"
    sha256 cellar: :any,                 sonoma:         "b7efaecc1001b92c3ff0768fb48b8071f2f6c4ed245ed72e79f75d3d0ff052cb"
    sha256 cellar: :any,                 ventura:        "31bc4013e41b1506944a93cf67c3e5f88ca7f5f4f610c511a27ad992d49bd620"
    sha256 cellar: :any,                 monterey:       "b85e22a004fb4649115cfd78231f974e02b2d4e01fc9afa8769ad2c2627e0b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdfb86cf952d7cfab08ce27dbe1dcd7b02f2b1947b5f8b694c1a8e4b99b4836c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  fails_with gcc: "5"

  resource "homebrew-test_file" do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    cmake_args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
      "-DUSE_NANOVDB=ON",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *cmake_args
      system "make", "install"
    end
  end

  test do
    resource("homebrew-test_file").stage testpath
    system bin/"vdb_print", "-m", "cube.vdb"
  end
end