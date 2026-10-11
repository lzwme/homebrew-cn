class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://ghfast.top/https://github.com/PDAL/PDAL/releases/download/2.10.2/PDAL-2.10.2-src.tar.bz2"
  sha256 "882b97aa3ae5db682c3b2dc8edef4e29bcc7ecea51c70592e71bc1f34112ad00"
  license "BSD-3-Clause"
  revision 3
  compatibility_version 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7ebdb611e1030b880a1b010756a2044b594dd99912f05195a56df6d4350cd6fc"
    sha256 cellar: :any, arm64_tahoe:       "8fb6679f4772ef1ec02c673955881ad31736b2c7177e3e437fff8ec6f651c2d9"
    sha256 cellar: :any, arm64_sequoia:     "b38c4fecb72eed066aeb20bc5198e42e91760398ca53295849cb9ae0c2ddbd48"
    sha256 cellar: :any, arm64_linux:       "3bce625b62b623b892f08fa4c7e84dc86ca32b9754efca36cda3b316f27eda73"
    sha256 cellar: :any, x86_64_linux:      "64ddb25edfcccc3c8f41ed0eaaa8af99001a94b9c81145e7baa058b1446eec27"
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

  # Arrow 26 API from PDAL 2.10-maintenance: PDAL/PDAL#5078, PDAL/PDAL#5098, PDAL/PDAL#5100
  patch do
    file "Patches/pdal/arrow-26.diff"
    type :backport
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
      ENV.append_to_cflags "-I#{libunwind.opt_include}"
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