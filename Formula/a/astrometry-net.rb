class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https:github.comdstndstnastrometry.net"
  url "https:github.comdstndstnastrometry.netreleasesdownload0.96astrometry.net-0.96.tar.gz"
  sha256 "fb3f2ec09cbe155d9ff461b9a60336f8493f5cb7804199e1782664e9034c9aac"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cfac83085eb5d98dc36ba7ab7bca138c66b1e816943cbd7e5168e070fe4fc98a"
    sha256 cellar: :any,                 arm64_sonoma:  "9afab005678388dbad503a220150c8daccc990e9bd2dd448fc569dcb541aabc1"
    sha256 cellar: :any,                 arm64_ventura: "65d1e63b676575ff4d39c40f5ed98c18e13d27a22e25638de23034978274a9c6"
    sha256 cellar: :any,                 sonoma:        "947ec849258784a4e6768e5bba5efd30bbb13916acd309087674186908dcb00a"
    sha256 cellar: :any,                 ventura:       "73e3ad7d458ab962544735126e5c498436f2e847209293b25147080153972fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8602a196aa54fc2edb9e6b3be983811e1ce7558e03f2ca47dfba3785adbd6157"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "wcslib"

  resource "fitsio" do
    url "https:files.pythonhosted.orgpackages6a94edcf29d321985d565f8365e3349aa2283431d45913b909d69d648645f931fitsio-1.2.4.tar.gz"
    sha256 "d57fe347c7657dc1f78c7969a55ecb4fddb717ae1c66d9d22046c171203ff678"
  end

  def install
    # astrometry-net doesn't support parallel build
    # See https:github.comdstndstnastrometry.netissues178#issuecomment-592741428
    ENV.deparallelize

    ENV["FITSIO_USE_SYSTEM_FITSIO"] = "1"
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = python3 = which("python3.12")

    venv = virtualenv_create(libexec, python3)
    venv.pip_install(resources, build_isolation: false)

    ENV["INSTALL_DIR"] = prefix
    ENV["PY_BASE_INSTALL_DIR"] = venv.site_packages"astrometry"
    ENV["PY_BASE_LINK_DIR"] = venv.site_packages"astrometry"
    ENV["PYTHON_SCRIPT"] = venv.root"binpython"

    system "make"
    system "make", "py"
    system "make", "install"

    rm prefix"docreport.txt"
  end

  test do
    system bin"image2pnm", "-h"
    system bin"build-astrometry-index", "-d", "3", "-o", "index-9918.fits",
                                            "-P", "18", "-S", "mag", "-B", "0.1",
                                            "-s", "0", "-r", "1", "-I", "9918", "-M",
                                            "-i", prefix"examplestycho2-mag6.fits"
    (testpath"99.cfg").write <<~EOS
      add_path .
      inparallel
      index index-9918.fits
    EOS
    system bin"solve-field", "--config", "99.cfg", prefix"examplesapod4.jpg",
                              "--continue", "--dir", "jpg"
    assert_predicate testpath"jpgapod4.solved", :exist?
    assert_predicate testpath"jpgapod4.wcs", :exist?
    system bin"solve-field", "--config", "99.cfg", prefix"examplesapod4.xyls",
                              "--continue", "--dir", "xyls"
    assert_predicate testpath"xylsapod4.solved", :exist?
    assert_predicate testpath"xylsapod4.wcs", :exist?
  end
end