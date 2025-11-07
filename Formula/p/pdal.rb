class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://ghfast.top/https://github.com/PDAL/PDAL/releases/download/2.9.2/PDAL-2.9.2-src.tar.bz2"
  sha256 "a74bbc7f4e4f709ed589dbbb851926a63c391c974e3fc40a4c3ff34f7923021b"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8c2f2a75f666a3d3e2acd5b4bff8743aab88d95b9fb5906efe5d780878da10e"
    sha256 cellar: :any,                 arm64_sequoia: "35a1af101ac7c9f141775b6b0c6b0dad22b02d714d3de40f48d185b350c1d4bf"
    sha256 cellar: :any,                 arm64_sonoma:  "e45e6972f4c7bf9bfa83d24ccd0fd822cf1a509bc1de5250fe5e53872df067fc"
    sha256 cellar: :any,                 sonoma:        "873114667cfb6d69e76ae13701090d242daddc05153a3db3f6a2770396455a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51db39e5ecdbc2822618fd5128828913b98105e55c5ff84fb33b5ea43aaaeb31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f97b25e9c778f75503935ac2b89475963e54d9c18a0bb0c98a76c966ac966f7d"
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