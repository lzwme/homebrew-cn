class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https:matplotlib.org"
  url "https:files.pythonhosted.orgpackagesdf171747b4154034befd0ed33b52538f5eb7752d05bb51c5e2a31470c3bc7d52matplotlib-3.9.4.tar.gz"
  sha256 "1e00e8be7393cbdc6fedfa8a6fba02cf3e83814b285db1c60b906a023ba41bc3"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8db36601680fd83e726724a74e3a1f0b5a01de9f0e3c11e9d83d787409f480a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cef861eb27bb8280dea4bcd756be4620baff377af725c6020a0731f76ccf0e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb4b23b73a9474944178d9988cf977dcd742a7ec6863ddaba59e0f038baaca0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f40e3f77c4514d4ff75b6d745459fd550a420fb2c55129bab3ac1c89caf90a7d"
    sha256 cellar: :any_skip_relocation, ventura:       "feccc202ee1980a3e2a13df44f0155cdd48d327c56c31bb3a750433881adccb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39683b2d46782c7be7997b261980638accbfdd1e3a55b94d762af87d6675030a"
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
    url "https:files.pythonhosted.orgpackages7661a300d1574dc381393424047c0396a0e213db212e28361123af9830d71a8dfonttools-4.55.3.tar.gz"
    sha256 "3983313c2a04d6cc1fe9251f8fc647754cf49a61dac6cb1e7249ae67afaafc45"
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
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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