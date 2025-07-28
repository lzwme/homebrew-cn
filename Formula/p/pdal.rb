class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://ghfast.top/https://github.com/PDAL/PDAL/releases/download/2.9.0/PDAL-2.9.0-src.tar.bz2"
  sha256 "f0be2f6575021d0c4751d5babd4c1096d4e5934f86f8461914e9f9c6dc63567d"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f633f676ee645772d3e537af008e22097b913bdf078f2bf307c4d7f276eb3daf"
    sha256 cellar: :any,                 arm64_sonoma:  "fec1430ce746325d44ca434eae08ddfc4d1dcaaad089fc53a001ef073013eee7"
    sha256 cellar: :any,                 arm64_ventura: "cb0ea9b7e3a83f9455d7204123b54fda9c2309587607735b1388ebb2135faa1a"
    sha256 cellar: :any,                 sonoma:        "960331dd9ba8505bc26c3e6833ddfd544de311f2bbb5e33a8c9be525d19eb550"
    sha256 cellar: :any,                 ventura:       "4dbcd46cc0528ebee4b0c4cd73f84d5b7496869f9cec9ffe58e863ae9861afe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a99fb356056c81a8fd9f802a59a76951e64204fae1c59b33ad28f7884bd9597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baefbdbb742d9f5873594f3540a29d4777e1143d83278a299daa6744289cf3a4"
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

  # Two patches below are related to apache-arrow 21.0.0 support
  # See https://github.com/PDAL/PDAL/pull/4773 and https://github.com/PDAL/PDAL/pull/4777
  patch do
    url "https://github.com/PDAL/PDAL/commit/8deb4e577ab6a73e74cd720256e1d574509ea3e9.patch?full_index=1"
    sha256 "93c4682fa8b1e5f62665967f7917ff97e1285ad4b9b4c227d3b27d0694ae9404"
  end

  patch do
    url "https://github.com/PDAL/PDAL/commit/ea822192f6054d6d0b1c68265a185fe4f292194f.patch?full_index=1"
    sha256 "02258e334a97fe95f4e5942a39734be9e574443e303105ee95aef864717a9dc3"
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