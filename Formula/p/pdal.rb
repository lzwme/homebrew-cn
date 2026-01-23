class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://ghfast.top/https://github.com/PDAL/PDAL/releases/download/2.9.3/PDAL-2.9.3-src.tar.bz2"
  sha256 "22e90c8b9653e2bd0eb24efbe071b6c281e972145b47c0ccfdc329d73c188d9c"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82e34542916a8ec7b2d6e89cfa8dda6b9c3507d1557a46c8b5473b8c1c753d7a"
    sha256 cellar: :any,                 arm64_sequoia: "9a214014b83e35ce8455f3eb1e0e48cfaec398e18114ab8dd984b4bcbeab8f65"
    sha256 cellar: :any,                 arm64_sonoma:  "7569c10afa2794cba6491c7a00646a293465ff02a0040d642e0b31baac29587c"
    sha256 cellar: :any,                 sonoma:        "d427142f2899e561661422e87a6506042ff3d4da51cd3467694907ebef8f0a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fadc82e1c7912e857a56bfd939d43cdc441df837fe20df2d72294c34bb4c7c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fce3e00b94382f4156d30101fdadd5afff795b3ff4811903ed0872b3f5665fee"
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