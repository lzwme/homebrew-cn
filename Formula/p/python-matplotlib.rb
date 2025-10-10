class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/ae/e2/d2d5295be2f44c678ebaf3544ba32d20c1f9ef08c49fe47f496180e1db15/matplotlib-3.10.7.tar.gz"
  sha256 "a06ba7e2a2ef9131c79c49e63dad355d2d878413a0376c1727c8b9335ff731c7"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0375cdd64145c1f5e9b19c518662ca8d15dfdb51ce886c567ef03035671702c4"
    sha256 cellar: :any,                 arm64_sequoia: "80928044bea6d5049973e2bb17db5a845596b1192fab7230e85aafefc96fd078"
    sha256 cellar: :any,                 arm64_sonoma:  "b5f8a4cb9b6b7814b4dff4e3d44e825f139edf5baeb6e0aa264baf2e55a27298"
    sha256 cellar: :any,                 sonoma:        "ea54e189a222420e185499b492818478f993583628e5c1dc5dda2bb91ba2d5c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a055b05289843ac19054a86db254a6210613edc66ebefcb3abba73d12fca0080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b534740911e2d14a73ec80079ae5cbabe7410589873a0b4780576b0f20b3898f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "qhull"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/58/01/1253e6698a07380cd31a736d248a3f2a50a7c88779a1813da27503cadc2a/contourpy-1.3.3.tar.gz"
    sha256 "083e12155b210502d0bca491432bb04d56dc3432f95a979b429f2848c3dbe880"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/4b/42/97a13e47a1e51a5a7142475bbcf5107fe3a68fc34aef331c897d5fb98ad0/fonttools-4.60.1.tar.gz"
    sha256 "ef00af0439ebfee806b25f24c8f92109157ff3fac5731dc7867957812e87b8d9"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/5c/3c/85844f1b0feb11ee581ac23fe5fce65cd049a200c1446708cc1b7f922875/kiwisolver-1.4.9.tar.gz"
    sha256 "c3b22c26c6fd6811b0ae8363b95ca8ce4ea3c202d3d0975b2914310ceb1bcc4d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def python3
    which("python3.13")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    system python3, "-m", "pip", "--python=#{venv.root}", "install",
                                 "--config-settings=setup-args=-Dsystem-freetype=true",
                                 "--config-settings=setup-args=-Dsystem-qhull=true",
                                 *std_pip_args(prefix: false, build_isolation: true), "."

    (prefix/Language::Python.site_packages(python3)/"homebrew-matplotlib.pth").write venv.site_packages
  end

  test do
    backend = shell_output("#{python3} -c 'import matplotlib; print(matplotlib.get_backend())'").chomp
    assert_equal OS.mac? ? "macosx" : "agg", backend
  end
end