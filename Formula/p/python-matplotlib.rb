class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https:matplotlib.org"
  url "https:files.pythonhosted.orgpackages759f562ed484b11ac9f4bb4f9d2d7546954ec106a8c0f06cc755d6f63e519274matplotlib-3.9.3.tar.gz"
  sha256 "cd5dbbc8e25cad5f706845c4d100e2c8b34691b412b93717ce38d8ae803bcfa5"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78339723212add8a888ffc56e6a0ee2c79d18d5877ee257ae65f605ceadc08ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4755830349f704ec69274b415add272c1b9760eddc5ed520564eeacae2592dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48784f76ccd746b24eb37a0df52df2458a36245196104215cc22fce47feccf88"
    sha256 cellar: :any_skip_relocation, sonoma:        "597070b0d48efdfce607068aba7a5c8ea5fcf2d36885b531cd75cfa959e2e9c2"
    sha256 cellar: :any_skip_relocation, ventura:       "7579b5dc43ce8e7f4380e263c0d0882c62b8d82bec6648c47526938895030b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577769c2d31c2b1fb814b4a7c7b0deb47aef3fa7de17ff20818b6bd2d2e581fd"
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
    url "https:files.pythonhosted.orgpackages25c2fc7193cc5383637ff390a712e88e4ded0452c9fbcf84abe3de5ea3df1866contourpy-1.3.1.tar.gz"
    sha256 "dfd97abd83335045a913e3bcc4a09c0ceadbe66580cf573fe961f4a825efa699"
  end

  resource "cycler" do
    url "https:files.pythonhosted.orgpackagesa995a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https:files.pythonhosted.orgpackagesd74e053fe1b5c0ce346c0a9d0557492c654362bafb14f026eae0d3ee98009152fonttools-4.55.0.tar.gz"
    sha256 "7636acc6ab733572d5e7eec922b254ead611f1cdad17be3f0be7418e8bfaca71"
  end

  resource "kiwisolver" do
    url "https:files.pythonhosted.orgpackages854d2255e1c76304cbd60b48cee302b66d1dde4468dc5b1160e4b7cb43778f2akiwisolver-1.4.7.tar.gz"
    sha256 "9893ff81bd7107f7b685d3017cc6583daadb4fc26e4a888350df530e41980a60"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8cd5e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
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
    which("python3.13")
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