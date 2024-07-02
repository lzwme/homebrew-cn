class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https:matplotlib.org"
  url "https:files.pythonhosted.orgpackagesc5a4a7236bf8b0137deff48737c6ccf2154ef4486e57c6a5b7c309bf515992bdmatplotlib-3.9.0.tar.gz"
  sha256 "e6d29ea6c19e34b30fb7d88b7081f869a03014f66fe06d62cc77d5a6ea88ed7a"
  license "PSF-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c57c7887ed6ffd8cae0e386808c86cbd28e427806d8d4d6ed4c2c3f7bc32dce5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8d1b138a14050e75c1f5cd8e0c617b66ecbad6e874f005d72a25ef09562585"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e039098b7cab4fc3294446d92a0ed424c62e4cc0f1881d1eea834b24fd67bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "df0ebde32356732ad3174bd9a3c28d23e38ec0e69218d59bd8c2e5d4058f7668"
    sha256 cellar: :any_skip_relocation, ventura:        "dff86a610aedb981fedae9367b489b2fb42e707f852d70458f596bf98a36a165"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc55a5a6624949b4118a8ae3b1b0aa4f5295e0764c17fb6283351612aef2a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13a91c0ba3fbb28eb5627010da1a08215c60d0eeb0d7a5f44b30e8818e0ef0d2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "qhull"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :gcc do
    version "6"
    cause "Requires C++17 compiler"
  end

  resource "contourpy" do
    url "https:files.pythonhosted.orgpackages8d9ee4786569b319847ffd98a8326802d5cf8a5500860dbfc2df1f0f4883ed99contourpy-1.2.1.tar.gz"
    sha256 "4d8908b3bee1c889e547867ca4cdc54e5ab6be6d3e078556814a22457f49423c"
  end

  resource "cycler" do
    url "https:files.pythonhosted.orgpackagesa995a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https:files.pythonhosted.orgpackages73e45f31f97c859e2223d59ce3da03c67908eb8f8f90d96f2537b73b68aa2a5afonttools-4.51.0.tar.gz"
    sha256 "dc0673361331566d7a663d7ce0f6fdcbfbdc1f59c6e3ed1165ad7202ca183c68"
  end

  resource "kiwisolver" do
    url "https:files.pythonhosted.orgpackagesb92d226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85eakiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def python3
    which("python3.12")
  end

  def install
    # `matplotlib` needs extra inputs to use system libraries.
    # Ref: https:github.commatplotlibmatplotlibblobv3.8.3docusersinstallingdependencies.rst#use-system-libraries
    # TODO: Update build to use `--config-settings=setup-args=...` when `matplotlib` switches to `meson-python`.
    ENV["MPLSETUPCFG"] = buildpath"mplsetup.cfg"
    (buildpath"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    venv = virtualenv_install_with_resources
    (prefixLanguage::Python.site_packages(python3)"homebrew-matplotlib.pth").write venv.site_packages
  end

  test do
    backend = shell_output("#{python3} -c 'import matplotlib; print(matplotlib.get_backend())'").chomp
    assert_equal OS.mac? ? "macosx" : "agg", backend
  end
end