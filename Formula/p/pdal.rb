class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https:www.pdal.io"
  url "https:github.comPDALPDALreleasesdownload2.8.2PDAL-2.8.2-src.tar.bz2"
  sha256 "da431616d8a3178fbc8b8e5c57e646a696f22e08cbae30d9ce96a349d8ad3bd9"
  license "BSD-3-Clause"
  head "https:github.comPDALPDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f482d565a0b14c1affebb536697c7c5e4aeb2756469cd5d6ee411b7d067c27ee"
    sha256 cellar: :any,                 arm64_sonoma:  "7e7246d8771c479674ced011d159050d17442f2012126be6d7bba87411342c76"
    sha256 cellar: :any,                 arm64_ventura: "782ba7008371600db9694d8bc21e9a4584f8499f6c2b27c2f2c2d51b758af047"
    sha256 cellar: :any,                 sonoma:        "90f29d117b3502d320baf892e137f46d9d27778f4835b3f41d00866d9dc90b60"
    sha256 cellar: :any,                 ventura:       "62bb7435d7de1013538365fcf7686025a4b4426c68e7149a55e43dd467f1de48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c1c8bc7e8a5de250f094451da0757911d0b16022f569b3ee448fea8f281b7c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libgeotiff"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  def install
    args = %w[
      -DWITH_LASZIP=TRUE
      -DBUILD_PLUGIN_GREYHOUND=ON
      -DBUILD_PLUGIN_ICEBRIDGE=ON
      -DBUILD_PLUGIN_PGPOINTCLOUD=ON
      -DBUILD_PLUGIN_PYTHON=ON
      -DBUILD_PLUGIN_SQLITE=ON
    ]
    if OS.linux?
      libunwind = Formula["libunwind"]
      ENV.append_to_cflags "-I#{libunwind.opt_include}"
      args += %W[
        -DLIBUNWIND_INCLUDE_DIR=#{libunwind.opt_include}
        -DLIBUNWIND_LIBRARY=#{libunwind.opt_libshared_library("libunwind")}
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm_r("testunit")
    doc.install "examples", "test"
  end

  test do
    system bin"pdal", "info", doc"testdatalasinteresting.las"
    assert_match "pdal #{version}", shell_output("#{bin}pdal --version")
  end
end