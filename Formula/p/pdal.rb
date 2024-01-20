class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https:www.pdal.io"
  url "https:github.comPDALPDALreleasesdownload2.6.2PDAL-2.6.2-src.tar.bz2"
  sha256 "4ec3d128af4d15924ddac91ddac56335cf32897c743349460cfa41d51f0f9e4e"
  license "BSD-3-Clause"
  head "https:github.comPDALPDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # majorminor version (`1.2`) and then uses majorminorpatch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https:pdal.ioenlatestdownload.html"
    regex(href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.ti)
  end

  bottle do
    sha256                               arm64_sonoma:   "774cbf6e8652b95ff981e98e2d3e86279b077493f0c29698b81c25f38f365861"
    sha256                               arm64_ventura:  "ab090acc74e147d5e0a5d4c05ea7abc0dae7593dce8d987d627600c02195bbed"
    sha256                               arm64_monterey: "ed99bc2a74f6167d119b4d8070899595b535d17cd186c2bad4d0a8eebf9ce96b"
    sha256                               sonoma:         "0a2c2c22af42a0c43f99051e8f32b62dc3f6f1e96b63b00074ae140f07f793b2"
    sha256                               ventura:        "0f54a519c686f76680ebd253452dc368f59c321c1a4e87ce847494cfb8e14970"
    sha256                               monterey:       "c95dbc7aaf2325fce3f18b219e757cb05defecf2e4d3c58f97ba03b104ffffec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872084063a98d3027fdb800174b609e6f9df3949a47dc47c60c474627cfaf82c"
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
    rm_rf "testunit"
    doc.install "examples", "test"
  end

  test do
    system bin"pdal", "info", doc"testdatalasinteresting.las"
  end
end