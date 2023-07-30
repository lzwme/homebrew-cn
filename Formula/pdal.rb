class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://ghproxy.com/https://github.com/PDAL/PDAL/releases/download/2.5.5/PDAL-2.5.5-src.tar.bz2"
  sha256 "b32b16475619a6bdfaee5a07a9b859206e18de5acff2a4447502fd0a9c6538d6"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https://pdal.io/en/latest/download.html"
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "48afc00971d9b72829406fa2d5ed28cc36f4b453531d30dc6f894abab6982df5"
    sha256                               arm64_monterey: "ae867cbfcb9dc3e8392b741de59037c6ea828c863fa11144805772d314c0a8f1"
    sha256                               arm64_big_sur:  "b8e42461e0b41a0ace6cf6ac7b1713f6fc5aff81baf6ea0cf7eb87abdc98e793"
    sha256                               ventura:        "065fe354793c615ca42ee391e2079eb205010b169e762340b6f05edebc8029c1"
    sha256                               monterey:       "2db1a7879387eaac5d8e23b9f561d7374e5d8a020b18a5cde167d19117f3e78b"
    sha256                               big_sur:        "8799b5be8cba98681b202f72463462c7064ef83e43268cafeb8fd3f0090f890a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5cd6d374597ec37ab8497ee85857c9e8e76d081ed30c289651e32eb34b024b6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"
  depends_on "openssl@3"

  fails_with gcc: "5" # gdal is compiled with GCC

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
                         "-DBUILD_PLUGIN_PGPOINTCLOUD=ON",
                         "-DBUILD_PLUGIN_PYTHON=ON",
                         "-DBUILD_PLUGIN_SQLITE=ON"

    system "make", "install"
    rm_rf "test/unit"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end