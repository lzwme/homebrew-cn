class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/8d/48/21c66c54142e9b5957f2787a9b8f8f4ce04f57b20cd5b8b66fcb54417a16/meta_package_manager-7.2.0.tar.gz"
  sha256 "54c361f4398d607616ae474f385df1a6a97bd6e7059f36beb5af44456b490c62"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/meta-package-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1fd8868f98d270cabae9df02b471abd7204942019b6a9dbe3e240f4e019ce7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1fd8868f98d270cabae9df02b471abd7204942019b6a9dbe3e240f4e019ce7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1fd8868f98d270cabae9df02b471abd7204942019b6a9dbe3e240f4e019ce7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "27892566e52382ad5fc9c0f8e0fa3dbc8112325312b1cab1b9d0e756c434f702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4d5e67b92021b32562157e8312e28af68c5710872d9c3a7d7697420be49bf45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d5e67b92021b32562157e8312e28af68c5710872d9c3a7d7697420be49bf45"
  end

  depends_on "rust" => :build

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/7a/1f/60df922ae497d838c58b48caa518251e2c8e228d7fe93792fee69a3858d6/boltons-26.0.0.tar.gz"
    sha256 "5566d6cfd5a1e873d8e8476496287a9f92979964611ad9a9cecb6b0ef29b1edd"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/d0/f5/4473ad9b48cd0420a2d762a3750fa0e078e23e060b1af72662e5987e5530/bracex-3.0.tar.gz"
    sha256 "b73f718d6bd98d8419e45df02426c86e9967c179949f779340d6c3a8c83b9111"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/a6/2c/114e90d1703ccfb25c14dc0f2a44f2296c3d924cb91948a36c92c1f77e11/click_extra-8.3.0.tar.gz"
    sha256 "f95cdec794dbb7f1f191f82a60be4ae3175e79c3f26ed4d3079f4b06d9542301"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/42/ca/cf02e965cfeb70d65c61fd3abb8022aaf5111a0de71b3c73a6ec2113aa25/cloup-3.1.0.tar.gz"
    sha256 "637c1e628fe98f3f20a5e44da591a72b42bf54d7d4527190bf39ed5f64af7585"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/2a/78/6e9e20106224083cfb817d2d3c26e80e72258d617b616721a169b87081e0/deepmerge-2.1.0.tar.gz"
    sha256 "07ca7a7b8935df596c512fa8161877c0487ac61f691c07766e7d71d2b23bdd2f"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/01/c5/e808dd8810c12a5bd6909db89a6e062641d4f9b3bb055bff652b43f53b98/extra_platforms-13.1.0.tar.gz"
    sha256 "8424f1644980b44f42fa2305d1da0e589541313451d952a35337c919c4bd234f"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/11/15/dc61746d8c0852f6d711ad09c774b63cf7c8211aa49e30871ac3d342b7e2/wcmatch-10.2.1.tar.gz"
    sha256 "ecac70a5c70e62ba854b78318d3a1408e8651f8f1c96e5837743b71aa6a4fb92"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    rewrite_shebang detected_python_shebang, "meta_package_manager/bar_plugin.py"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mpm", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpm --version")

    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match "brew,Homebrew Formulae,✓,✓",
      shell_output("#{bin}/mpm --table-format csv --all-managers managers")
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --table-format csv installed")
  end
end