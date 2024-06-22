class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https:github.comdstndstnastrometry.net"
  url "https:github.comdstndstnastrometry.netreleasesdownload0.95astrometry.net-0.95.tar.gz"
  sha256 "b8239e39b44d6877b0427edeffd95efc258520044ff5afdd0fb1a89ff8f1afc0"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5f15d618c8756197d1970f72a761afcb4b875a1fbce0c4daff180dc3bbd5e054"
    sha256 cellar: :any,                 arm64_ventura:  "92c976e4604da5686a8ad5aa315ec80f8057b7494d9ddabbd51a592418390580"
    sha256 cellar: :any,                 arm64_monterey: "8ac2b1a0ffa382b0cbe797697de36644bb195cdd5e69cf6566f4d7741284721f"
    sha256 cellar: :any,                 sonoma:         "5261231e0b211468b2e2946cba198b6284876e8892376ca199a105c521942bb0"
    sha256 cellar: :any,                 ventura:        "eac7171945f2b770d1bc5157099aca26d0bd80f2ef7408793dab356696507415"
    sha256 cellar: :any,                 monterey:       "10069a20a7084298abe218a891610d6b9bb389b635c943f678222395962d9f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6fec941da11af47992550f463aa96e59c589893655aa7c7b40c809ae335e887"
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

  # Support numpy 2.0
  patch do
    url "https:github.comdstndstnastrometry.netcommit5640e60401ac6961449d64ec0256c326b1d26216.patch?full_index=1"
    sha256 "7486d9dac6bf7261f2cd459af028426dfb29c0b3c23c840889ef9ba083c42be3"
  end
  patch do
    url "https:github.comdstndstnastrometry.netcommit7991b0d20280e8fc6a9b17d5669312eee69e4c43.patch?full_index=1"
    sha256 "4fa0feec1bd4159749789c5f115dd0e99e6a92e6032b90da273560a9064419d5"
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