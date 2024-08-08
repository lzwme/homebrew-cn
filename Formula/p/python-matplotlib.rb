class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https:matplotlib.org"
  url "https:files.pythonhosted.orgpackages27c3b4dbf9ed2a024a5514fa8a2606867a3716c9adfd457d138865145a940a65matplotlib-3.9.1.post1.tar.gz"
  sha256 "c91e585c65092c975a44dc9d4239ba8c594ba3c193d7c478b6d178c4ef61f406"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6db5f3fd3c2afa66e3b1d90768d80030df6c0ec4f7a0b2f4b88e645721b68752"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e6e2d16a3257c899324c62315df0acd04123bd1a58a583aa6f9507544a3ca57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38656d76ce85b0362799ec9f06aaeffd3914a51263982dea940d0678f2b1114b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1ec5829b4179958c03bbaca1daf0a370387e69b06dc5150e16d48724dd231d2"
    sha256 cellar: :any_skip_relocation, ventura:        "3201357e0319426ca8476e2ec96afda641da3739cef81dd092abdf699729daeb"
    sha256 cellar: :any_skip_relocation, monterey:       "7ba4a7ce5fbf5fc893e01b7ec3b96bb78f0fb87962d3dc5e62d6fda3dd2e3417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab2309b862838bf708111a91777931773ad11c33bd79a5da555ccfbadba5f95"
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
    url "https:files.pythonhosted.orgpackagesc6cbcd80a0da995adde8ade6044a8744aee0da5efea01301cadf770f7fbe7dccfonttools-4.53.1.tar.gz"
    sha256 "e128778a8e9bc11159ce5447f76766cefbd876f44bd79aff030287254e4752c4"
  end

  resource "kiwisolver" do
    url "https:files.pythonhosted.orgpackagesb92d226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85eakiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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