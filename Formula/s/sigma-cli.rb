class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https:github.comSigmaHQsigma-cli"
  url "https:files.pythonhosted.orgpackages23c1cab449bf8cd1541ad32617061accd4f4150ef2e906f0fe7cac9054dd91cdsigma_cli-0.7.11.tar.gz"
  sha256 "9337ec46b46cfdbea262a439e90df58a83319df33f4339c965cb6b7b318cd5b8"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comSigmaHQsigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41cc3d99f8503a86d129c22817455c7f97f44fa5518d2ae9e1fc7d715d9008ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2efa2269ddeaef759b7a3db84567c8229710f4b5416cccb8aed3f83da061ca6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b483deb23c5565f5c7c85f68868931b1e9143cb24ff7e7663321b42d09dc66aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "391faaab181d9d372a0c72a0636d46b6725cbbc330fd4ca819fb2a078d3cd5e0"
    sha256 cellar: :any_skip_relocation, ventura:        "5d185cf83c4480f75bb719a8f22b907f55542644ef94b512e106f3a9e834071f"
    sha256 cellar: :any_skip_relocation, monterey:       "d20bbe142ff5ad823cd2d6fcc41d91a055e6d4829dbf321ab97b8e34bbc6bc4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "023d9b386aba513305980a66c800980e070617d65961d2156283260c6f177fd9"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages6bf7c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackagese1c05e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386bprettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "pysigma" do
    url "https:files.pythonhosted.orgpackagesae94967c1bba7f905ae2e9e3a530ad5c27e5382d7cc6329fac2d42044b709d1bpysigma-0.10.10.tar.gz"
    sha256 "4b26d21472ea11b5f036d7e544c66b1567f0736e935e75c98483dbe545370b33"
  end

  resource "pysigma-backend-sqlite" do
    url "https:files.pythonhosted.orgpackages8d792b8c9061a4a140894d20d49ae6dbf32b2155041a950f41b0b5d6842e9f0bpysigma_backend_sqlite-0.1.1.tar.gz"
    sha256 "a96067e215077a7cb39ebb46a09db1abf7824ed7a624a3ee6d9d1e493d2d7f12"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sigma version")

    output = shell_output("#{bin}sigma plugin install sqlite")
    assert_match "Successfully installed plugin 'sqlite'", output
  end
end