class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://ghfast.top/https://github.com/PDAL/PDAL/releases/download/2.9.3/PDAL-2.9.3-src.tar.bz2"
  sha256 "22e90c8b9653e2bd0eb24efbe071b6c281e972145b47c0ccfdc329d73c188d9c"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2589d834dbf2999203c57ff684371f8433549e7c38b63dddc09173a0e73b79c2"
    sha256 cellar: :any,                 arm64_sequoia: "372b317edf6a88514d3e5bc5610fdccf78fa9f825fec9bf298beb4d202b3df90"
    sha256 cellar: :any,                 arm64_sonoma:  "dccea42d9aa84543532dcfb497d586b736cd322520b52e148a3c2f435444aca4"
    sha256 cellar: :any,                 sonoma:        "08fa14e335be49c4487ceccb61d949d2b70f6ae73665b3c77a2d699cc1744ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72e457777d497619f976a965b8c98d443072c157863373172296ed7ca611fc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74b58226d2c7e3dc8ec6cf0b431b076a94a1e84f831802edb952cc8bba9b3fe"
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
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "tiledb"
  depends_on "xerces-c"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
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