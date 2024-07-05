class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https:matplotlib.org"
  url "https:files.pythonhosted.orgpackages22069e8ba6ec8b716a215404a5d1938b61f5a28001be493cf35344dda9a4072amatplotlib-3.9.1.tar.gz"
  sha256 "de06b19b8db95dd33d0dc17c926c7c9ebed9f572074b6fac4f65068a6814d010"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a485c33d5f93775e023e392537d1a68a8ef02b45207a0a111c0051d0419f02a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc3a51b99af7ac0fb55b80aad2484d211e268be2d7bfcb9b170d2a607377608b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a0f20d8044dff4b47b696ebd461d4235384f7c931e1d5137e04b7823ad6cb9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4100352ff913a5a96826df3fe70c909b8badf3d8aabc7759e7ab154c2501d07f"
    sha256 cellar: :any_skip_relocation, ventura:        "9a5613a0de1b555162812db934519183c69ed8932e238b2bc9d4ee4e8da0a752"
    sha256 cellar: :any_skip_relocation, monterey:       "6e7819054cca66567c4e1e35bcd4fb22686e02fd581c982671a0253c5e36f3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39167af6f592d04d32619d930e125e2e88d24f4d92bb2cc55fb568ece28b0bce"
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
    url "https:files.pythonhosted.orgpackagesa46e681d39b71d5f0d6a1b1dc87d7333331f9961b5ab6a2ad6372d6cf3f8b04cfonttools-4.53.0.tar.gz"
    sha256 "c93ed66d32de1559b6fc348838c7572d5c0ac1e4a258e76763a5caddd8944002"
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