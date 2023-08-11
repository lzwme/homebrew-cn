class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://ghproxy.com/https://github.com/dstndstn/astrometry.net/releases/download/0.94/astrometry.net-0.94.tar.gz"
  sha256 "38c0d04171ecae42033ce5c9cd0757d8c5fc1418f2004d85e858f29aee383c5f"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a574a5c845ac38bec69c43c1797c70f54dd7f25bf148514c39dbaef29bea5f5"
    sha256 cellar: :any,                 arm64_monterey: "5050cdcb8005677bd98eafcda71396d4d3c55570e4e51be713e93766143d4a35"
    sha256 cellar: :any,                 arm64_big_sur:  "37cf4b463f85a3227e5c62f01ed9b2dcda9d3d1102ccd918788b1d14efc4e04a"
    sha256 cellar: :any,                 ventura:        "be5b9d25645f905f63ce3f48ccb6e2ba385a307b99b726b07ac9ada3af2258ef"
    sha256 cellar: :any,                 monterey:       "f00daa91016797ed2b7fb514552710203ba96052de0622d0d471c9bbbb1fa8fb"
    sha256 cellar: :any,                 big_sur:        "3fb6f1b21bfb89385ccb5119ff181c83e06ebd5cdf379de9112c0e0159d45a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b1fdd3386bafa3552310c8ed87288d667b89b0afaf3db77a76ffdac75cbcf7"
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

  # https://github.com/Homebrew/homebrew-core/issues/130484
  # Review for removal on next release
  patch do
    url "https://github.com/dstndstn/astrometry.net/commit/f85136190b6e39393049e9be1cf14ac32b89b538.patch?full_index=1"
    sha256 "82f8968805dacfd66961ea7cfea7e190be6faaaaa5367f2b86b0b5a62f160706"
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
                              "--continue", "--dir", "jpg"
    assert_predicate testpath/"jpg/apod4.solved", :exist?
    assert_predicate testpath/"jpg/apod4.wcs", :exist?
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.xyls",
                              "--continue", "--dir", "xyls"
    assert_predicate testpath/"xyls/apod4.solved", :exist?
    assert_predicate testpath/"xyls/apod4.wcs", :exist?
  end
end