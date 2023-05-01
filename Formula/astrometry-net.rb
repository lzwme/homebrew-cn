class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://ghproxy.com/https://github.com/dstndstn/astrometry.net/releases/download/0.93/astrometry.net-0.93.tar.gz"
  sha256 "9a4854c87210422e113b8f6855912a38f0b187526171364ee2a889d36c674d70"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12fc7d54b0c9425a70c226bc9b729a03b2451f0cd7005d32f9e9be56af2927af"
    sha256 cellar: :any,                 arm64_monterey: "3dfc93849a54328dea1fe62653a198921b2fd892467d28ffb50ef6efd0fa3698"
    sha256 cellar: :any,                 arm64_big_sur:  "23b1e06344912a5d848c5c9e0ebe20ead0d8639a992ef314c0ae8bd869749a6d"
    sha256 cellar: :any,                 ventura:        "bad87fd252b1b308072b2712e0ec99f4a869205b08395a35b8a967188354502f"
    sha256 cellar: :any,                 monterey:       "8c74b5aeb9dc91712fab3b9640da6e4a8688515520e556775bd278c5cce5dd33"
    sha256 cellar: :any,                 big_sur:        "d3a9cb78bcc8cde1b4f7c2f76989e707c76b6d4e89c172d30cb86df7d3f0a782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c12d0a3b25a7c9adee49bbaff25a3703cc082bd9d6914b20ca485204855353"
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/1f/0e/b312ff3f6b588c13fc2256a5df4c4d63c527a07e176012d0593136af53ee/fitsio-1.1.8.tar.gz"
    sha256 "61f569b2682a0cadce52c9653f0c9b81f951d000522cef645ce1cb49f78300f9"
  end

  def install
    # astrometry-net doesn't support parallel build
    # See https://github.com/dstndstn/astrometry.net/issues/178#issuecomment-592741428
    ENV.deparallelize

    python = which("python3.11")
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = python

    venv = virtualenv_create(libexec, python)
    venv.pip_install resources

    ENV["INSTALL_DIR"] = prefix
    site_packages = Language::Python.site_packages(python)
    ENV["PY_BASE_INSTALL_DIR"] = libexec/site_packages/"astrometry"
    ENV["PY_BASE_LINK_DIR"] = libexec/site_packages/"astrometry"
    ENV["PYTHON_SCRIPT"] = libexec/"bin/python"

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
                              "--continue", "--dir", "."
    assert_predicate testpath/"apod4.solved", :exist?
    assert_predicate testpath/"apod4.wcs", :exist?
  end
end