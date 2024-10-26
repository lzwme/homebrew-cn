class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https:www.pdal.io"
  url "https:github.comPDALPDALreleasesdownload2.8.1PDAL-2.8.1-src.tar.bz2"
  sha256 "0e8d7deabe721f806b275dda6cf5630a8e43dc7210299b57c91f46fadcc34b31"
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
    sha256 cellar: :any,                 arm64_sequoia: "ce5799eddec979fe2765b90fbd99a1136a78fe6f10333bdd480e9c07e4862af9"
    sha256 cellar: :any,                 arm64_sonoma:  "04aa160e3d11fac4908f83ac146570d911ed9f9bbe2191101cb325df009ca3bd"
    sha256 cellar: :any,                 arm64_ventura: "d0cab2aa3ed05dcc5094685680c4f5ce313bcd3edf9be2f0e36e07530127f7c1"
    sha256 cellar: :any,                 sonoma:        "5c1281aeb4f1359ce3b9bb0f4badc759450fec87bb57616d3c931f0273769598"
    sha256 cellar: :any,                 ventura:       "d93613d6a2b99a9dc10755f04527fda45c49060f55537141d8883992044316c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e256bb9ef10a9c945863e420130e6d0dd36e7e36973946e69034de723f49585"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  fails_with gcc: "5" # gdal is compiled with GCC

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
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