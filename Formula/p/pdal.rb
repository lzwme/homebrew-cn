class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://ghfast.top/https://github.com/PDAL/PDAL/releases/download/2.9.1/PDAL-2.9.1-src.tar.bz2"
  sha256 "a5508e30b5d2e5154fd5e686a444ae3f835607807b5d22f26d97d184ff4b74d8"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bcd1909353380061d33f10c42c6d147545d95fde5ae7a514819aa6a37b15691f"
    sha256 cellar: :any,                 arm64_sonoma:  "fe614d7f2c31bdd24969a70c721538afd48789b0590a6a983cadd3263ac2db13"
    sha256 cellar: :any,                 arm64_ventura: "163dd4b47b60d16c44e8cd87082812393365a9d2bf252521fc5bf51291ac35bc"
    sha256 cellar: :any,                 sonoma:        "14b31cf37dfa115e5d630d9eda8d2a2db41cd2430eb960677fb4de118abe585d"
    sha256 cellar: :any,                 ventura:       "46c6753f35cda87b999ea89602b178a29f85dbf0d7c4e024718d624694709dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bae797d995d7203ef8335dd7e02cda2c396e0ef79b7ccfafdcc894666019f7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3b8735aa21e22088baf73a882ef27b51fc6c362a5d15c3c52e7e7d868e4d12"
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