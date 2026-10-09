class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://ghfast.top/https://github.com/PDAL/PDAL/releases/download/2.10.2/PDAL-2.10.2-src.tar.bz2"
  sha256 "882b97aa3ae5db682c3b2dc8edef4e29bcc7ecea51c70592e71bc1f34112ad00"
  license "BSD-3-Clause"
  revision 2
  compatibility_version 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f205b89ad8bde08b14ddbe4de6968ebd09340fb63835731d7ab9934ff4eed268"
    sha256 cellar: :any, arm64_tahoe:       "0987b5bedd3a321f0cfad87c7c32a55f462229e739b6f9362f9420cbdb1f237f"
    sha256 cellar: :any, arm64_sequoia:     "8c328cdf95b5a4c0e2b46f64d95f8d12ae335a2d620c7873b442303e5422fbe7"
    sha256 cellar: :any, arm64_linux:       "b51d155b5aa60c84cf334160b4ec80b498d2e490acabd91f3d145c38bde3184c"
    sha256 cellar: :any, x86_64_linux:      "7ddf998cab349680389d8d092fd01be40163f232b740032dc4fba9c5e4744030"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build

  depends_on "apache-arrow"
  depends_on "curl"
  depends_on "draco"
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "libgeotiff"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openssl@4"
  depends_on "proj"
  depends_on "tiledb"
  depends_on "xerces-c"
  depends_on "zstd"

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DWITH_TESTS=OFF
      -DENABLE_CTEST=OFF
      -DBUILD_PLUGIN_ARROW=ON
      -DBUILD_PLUGIN_TILEDB=ON
      -DBUILD_PLUGIN_ICEBRIDGE=ON
      -DBUILD_PLUGIN_HDF=ON
      -DBUILD_PLUGIN_PGPOINTCLOUD=ON
      -DBUILD_PLUGIN_E57=ON
      -DBUILD_PLUGIN_DRACO=ON
      -DBUILD_PGPOINTCLOUD_TESTS=OFF
      -DWITH_ZSTD=ON
      -DWITH_ZLIB=ON
    ]
    if OS.linux?
      libunwind = Formula["libunwind"]
      # TODO: restore once apache-arrow drops keg-only llvm@22, whose libunwind.h shadows this -I in superenv
      # ENV.append_to_cflags "-I#{libunwind.opt_include}"
      ENV.prepend_path "HOMEBREW_INCLUDE_PATHS", libunwind.opt_include
      args += %W[
        -DLIBUNWIND_INCLUDE_DIR=#{libunwind.opt_include}
        -DLIBUNWIND_LIBRARY=#{libunwind.opt_lib/shared_library("libunwind")}
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm_r("test/unit")
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
    assert_match "pdal #{version}", shell_output("#{bin}/pdal --version")
  end
end