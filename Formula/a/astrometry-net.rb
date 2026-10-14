class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://ghfast.top/https://github.com/dstndstn/astrometry.net/releases/download/0.97/astrometry.net-0.97.tar.gz"
  sha256 "e4eef1b658ba5ad462282b661c0ca3a5c538ba1716e853f7970b7b9fa4a33459"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "6aced9489f6f1264309e9f0bb71fe0e2c853daa3187c925300a116f38d0b1d5d"
    sha256 cellar: :any, arm64_tahoe:       "4324f3f4a32d45adc7775f6ab3214fa7e4b3289dadb45de3dc3c92cb92046506"
    sha256 cellar: :any, arm64_sequoia:     "585abe378d00f393fa4891b28f4f4a0fbe27ea7df4fb7e765267bebe2eb1c8f1"
    sha256 cellar: :any, arm64_linux:       "103b3e0c6e58f9fda5d3777f88c75d78212f7b7f72d66e087e43d74f5e7c4727"
    sha256 cellar: :any, x86_64_linux:      "41a088b52c44eee234a365260555725f67a59f86591b44eb8090812516f9ce8b"
  end

  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "wcslib"

  pypi_packages exclude_packages: "numpy",
                extra_packages:   "fitsio"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/3b/fd/53bfe8986f7b242fb5b66ddc9344fe67614102f44438415b0a8b32cf7f0a/fitsio-1.4.2.tar.gz"
    sha256 "92a02f0e63d539d85ca5a185ae0cc8d40029270858275964ee2539ee0136f0c3"
  end

  def install
    # astrometry-net doesn't support parallel build
    # See https://github.com/dstndstn/astrometry.net/issues/178#issuecomment-592741428
    ENV.deparallelize

    ENV["FITSIO_USE_SYSTEM_FITSIO"] = "1"
    ENV["NETPBM_INC"] = "-I#{formula_opt_include("netpbm")}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{formula_opt_lib("netpbm")} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = python3

    venv = virtualenv_create(libexec, python3)
    venv.pip_install(resources, build_isolation: false)

    ENV["INSTALL_DIR"] = prefix
    ENV["PY_BASE_INSTALL_DIR"] = venv.site_packages/"astrometry"
    ENV["PY_BASE_LINK_DIR"] = venv.site_packages/"astrometry"
    ENV["PYTHON_SCRIPT"] = venv.root/"bin/python"

    system "make"
    system "make", "py"
    system "make", "install"

    rm prefix/"doc/report.txt"
  end

  test do
    system bin/"image2pnm", "-h"
    system bin/"build-astrometry-index", "-d", "3", "-o", "index-9918.fits",
                                            "-P", "18", "-S", "mag", "-B", "0.1",
                                            "-s", "0", "-r", "1", "-I", "9918", "-M",
                                            "-i", prefix/"examples/tycho2-mag6.fits"
    (testpath/"99.cfg").write <<~EOS
      add_path .
      inparallel
      index index-9918.fits
    EOS
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.jpg",
                              "--continue", "--dir", "jpg"
    assert_path_exists testpath/"jpg/apod4.solved"
    assert_path_exists testpath/"jpg/apod4.wcs"
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.xyls",
                              "--continue", "--dir", "xyls"
    assert_path_exists testpath/"xyls/apod4.solved"
    assert_path_exists testpath/"xyls/apod4.wcs"
  end
end