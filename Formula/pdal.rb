class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://ghproxy.com/https://github.com/PDAL/PDAL/releases/download/2.5.2/PDAL-2.5.2-src.tar.gz"
  sha256 "3966620cbe48c464d70fd5d43fff25596a16abe94abd27d3f48d079fa1ef1f39"
  license "BSD-3-Clause"
  revision 1
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
    sha256                               arm64_ventura:  "eea4e56ac430a4b1f1c5776013bc17fb28bdcf3cb8e56a92f4d76155fe93a34f"
    sha256                               arm64_monterey: "b795a08829372116218de7d8356936a29fcc3f9c5108a55be41c4e1026bb7211"
    sha256                               arm64_big_sur:  "376757c483e8904c32242bb1fac743eea4d23301cbc2fa4b69f124d2109e0f81"
    sha256                               ventura:        "a90e82fd7dc6f7abb19e31fdb9428ebc74ab4ab4ed3d661c0048b8ea5676379e"
    sha256                               monterey:       "160dc603c3d6764c856adf81d69239b866627dd504e7275f89cebc9896c63913"
    sha256                               big_sur:        "9a057bcdcc5ceb4e912f115dd78cfb9582b994006b407614687c7b659ea7688b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82acfd5f46dfe42bde8516e8bc057c648f7bb282bb6b2ed3ad84ebcb39b21229"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"

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