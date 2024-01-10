class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https:docs.cloud.oracle.comiaasContentAPIConceptscliconcepts.htm"
  url "https:files.pythonhosted.orgpackages1a9d4245eef1e3d70273f5edde262f03bfe4373001711d405335f398d0e27c8foci-cli-3.37.2.tar.gz"
  sha256 "a7d5ba33c0036b405db23093e25e93e6f11a300e99298f94b9a8dfca2e21bfe2"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https:github.comoracleoci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf2a78113f78aa9a94df56f8b816a7d36ac5d88e3438905cff6153b985eebebb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e4b7dda09e0228b58f74fabb4fff1dc35f1622ad88d5306a10ee8ba7dd2a4a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f748fafcab32b4f973898b0ee1aaa52a7510e48ec32751f30ac40fb525fa9a6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b4f6decd4554a006b2012071dc54ec26189931562e1f8c80785bf91e9f8fa79"
    sha256 cellar: :any_skip_relocation, ventura:        "b09a8dd6bbd84dd55b372a2112ebb7760de606a2f5beb78406913768638b28ac"
    sha256 cellar: :any_skip_relocation, monterey:       "d0e1d785f05cb26a8e7306c86dc947f743934dc37b1871634e1da30b408bb3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba95ab27f228852edad9205d120bb35084d59af23034a03c3cd0f784ca2f2943"
  end

  depends_on "cffi"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "asn1crypto" do
    url "https:files.pythonhosted.orgpackagesdecfd547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6eeasn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "cached-property" do
    url "https:files.pythonhosted.orgpackages612cd21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "circuitbreaker" do
    url "https:files.pythonhosted.orgpackages92ec7f1dd19e3878f5391afb508e6a2fd8d9e5b176ca2992b90b55926c7341d8circuitbreaker-1.4.0.tar.gz"
    sha256 "80b7bda803d9a20e568453eb26f3530cd9bf602d6414f6ff6a74c611603396d2"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages3c563f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "oci" do
    url "https:files.pythonhosted.orgpackagesa6808d7319c7caaaecf12009b3788e4c59cf1fad3d0d9b7ed7e4432735eb3f19oci-2.118.1.tar.gz"
    sha256 "ab77b235a397b720411b796f1377db6a572467f3f2a1fe696665de1234c6ad9b"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages59684d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackagesbfa0e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610epyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-pkcs11" do
    url "https:files.pythonhosted.orgpackages3e249d55a78b3501201d2dfeb035ce1b139f8846505b3ddb9cadb4c2254259d0python-pkcs11-0.7.0.tar.gz"
    sha256 "9737e0c24cabb8bc9d48bf8c57c3df2a70f8cdd96b70c50290803286f9e46bf7"
  end

  resource "terminaltables" do
    url "https:files.pythonhosted.orgpackages9bc44a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bffterminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages9b472a9e51ae8cf48cea0089ff6d9d13fff60701f8c9bf72adaee0c4e5dc88f9types-python-dateutil-2.8.19.20240106.tar.gz"
    sha256 "1f8db221c3b98e6ca02ea83a58371b22c374f42ae5bbdf186db9c9a76581459f"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    version_out = shell_output("#{bin}oci --version")
    assert_match version.to_s, version_out

    assert_match "Usage: oci [OPTIONS] COMMAND [ARGS]", shell_output("#{bin}oci --help")
    assert_match "", shell_output("#{bin}oci session validate", 1)
  end
end