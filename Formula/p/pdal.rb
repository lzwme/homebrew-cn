class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https:www.pdal.io"
  url "https:github.comPDALPDALreleasesdownload2.6.3PDAL-2.6.3-src.tar.bz2"
  sha256 "e4d90a3ce4c9681cd3522ca29e73a88ff3b3c713f918693ad03932a6b7680460"
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
    rebuild 1
    sha256                               arm64_sonoma:   "c6acd2cecd72c34d858943ec9a33988a013cc297ff96947181aa07e26687a84b"
    sha256                               arm64_ventura:  "fa887a586439631b23db98c6515aa027e77f03b5c23b7cfd3f7d6dd5c581572a"
    sha256                               arm64_monterey: "68abdace8b745f64bf7a2181c5441eceae4e080b4e4900b0ac2856cd880915c7"
    sha256                               sonoma:         "722b1ba33b3de73e1dac7bcc3f639089d7799eeafbab01cbc38f54f70619999b"
    sha256                               ventura:        "6e679ed6eed161bfe1ae74164a9696d8a41af7c79e07744f3edbf8e110c09c6e"
    sha256                               monterey:       "fe3e5b93efd05bedccbafeed1a545ace62a2e53cee674e8f53f052da0f0c8e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c0950cae711852379acebab17f96752eaf8f948135e01abbb497ef563b7bc5"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

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
    assert_match "pdal #{version}", shell_output("#{bin}pdal --version")
  end
end