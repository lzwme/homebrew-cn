class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://ghfast.top/https://github.com/PDAL/PDAL/releases/download/2.9.2/PDAL-2.9.2-src.tar.bz2"
  sha256 "a74bbc7f4e4f709ed589dbbb851926a63c391c974e3fc40a4c3ff34f7923021b"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "efe4e59e04ec377eb74e210e675645c7f3a6ec5eb148f86be6c5a45a4a5ef496"
    sha256 cellar: :any,                 arm64_sequoia: "d61ae9de030ee050a8ab3fa2844524a7f96cee658a6e6a9b24ee4d11b1ea3c06"
    sha256 cellar: :any,                 arm64_sonoma:  "e7e0fd784fd2fa932a90f1b23296f89e627a3d6563d3ba7ffb8e31045292d0b0"
    sha256 cellar: :any,                 sonoma:        "422c80b3758bedcec9b368173d99aa2a77c5da6b07d76249f0cdac47b5d56680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10aed5836f89cad47e46f885e96aee49ba091e5bd11690df1bf335ef9857c094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d68c2a499d9656e717b0da01c1369a0696d0e95b2197e8aefe918bf59603b69"
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