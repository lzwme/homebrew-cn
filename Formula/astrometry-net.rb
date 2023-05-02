class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://ghproxy.com/https://github.com/dstndstn/astrometry.net/releases/download/0.94/astrometry.net-0.94.tar.gz"
  sha256 "38c0d04171ecae42033ce5c9cd0757d8c5fc1418f2004d85e858f29aee383c5f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08c8f0b1dd36fb4cb76a54018a7e815f2ae47f7c9c3130cb4082f717fc0c678f"
    sha256 cellar: :any,                 arm64_monterey: "7d54a8b1b7829e05bc47a8526b452cceef2c2a320488b1ecaf2190e0dd26fb62"
    sha256 cellar: :any,                 arm64_big_sur:  "305e68b923b72c22667e849c081c75ac6b086ef150aac843d0a6f6fd1430cd79"
    sha256 cellar: :any,                 ventura:        "d8d8d929a55325a6395625c06ba0140598bc8a732129a5ccc609556c9c43b969"
    sha256 cellar: :any,                 monterey:       "f6ccef7ffdfeec25d4eb0bd2f4389e67956399d29e1741c385d5d0defb3a400b"
    sha256 cellar: :any,                 big_sur:        "e4a5e887cdcff3f1bfb16bb0814a9e9ecdc5ad926211825fece76b5862d09e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c1b699a8930839af7cbb20f6fe2241151fbe382048ce2548900846d653425dd"
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