class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v13.2.0.tar.gz"
  sha256 "505c11d4eb1488518bd4d9a3656b27d547ee1a8b12f601e82407f1ae7dab5d31"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cfade5759a23e26fcdb56fb06831aecdb296a5d1432a34c2ded11b0b7d8136e8"
    sha256 cellar: :any, arm64_tahoe:       "195e7adc1f59a4c3c0dfa37caca81c32412ada14f418ea1c31478e2a9409e974"
    sha256 cellar: :any, arm64_sequoia:     "c5031584b40f0e007a269fca58d316e382a9098831789af030fc630fd85737bf"
    sha256 cellar: :any, arm64_linux:       "c2cdd16e5650b2cf9dd203fa9dcb47c4859fb51bb784be6df680811b714511a0"
    sha256 cellar: :any, x86_64_linux:      "2dc29130fcef4a0afdf3394e93ba1221e557ea2bfe42a3f9971eb56334754f30"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-test_file", :test do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  allow_network_access! :test

  def install
    args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DUSE_NANOVDB=ON",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-test_file")
    system bin/"vdb_print", "-m", "cube.vdb"
  end
end