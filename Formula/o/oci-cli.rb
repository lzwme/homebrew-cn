class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https:docs.cloud.oracle.comiaasContentAPIConceptscliconcepts.htm"
  url "https:files.pythonhosted.orgpackagese15330e3f0c197b6ecb93ec174fba27ae4840031f3621d0a5f06c20cc9cfa166oci-cli-3.37.7.tar.gz"
  sha256 "8d8987837ec8538d9bb14776625e0c24809c7e06b2f6450820d50f6194ee29d8"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https:github.comoracleoci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db4ee28a8d539770684ef60723ae198f059ee14d31e17ecdc0bd0f8f082cb1fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2d500788adcda45209d7e1e5e8517732bceb0957c356ae5d427cac69508b113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067ae3a9fc5f19f410ce171e52574b7b6dce69301a5b3f6271b30251400525bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a80fdceed44bbfaad69ffb40a8692e8dc5db1b3806aadcff9923b2f97b535d71"
    sha256 cellar: :any_skip_relocation, ventura:        "adf312d2fa710471dd3590918785b250607d968cb6860d1373b222da07731136"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1282c161183619c6447ae560f08d21f6ba127f1106179b3b72a2e5ad030b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "405d5aadc5fbce22781af845ff359f76033bceba70aa3d3f390f7e2d1ace1010"
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

  resource "circuitbreaker" do
    url "https:files.pythonhosted.orgpackages92ec7f1dd19e3878f5391afb508e6a2fd8d9e5b176ca2992b90b55926c7341d8circuitbreaker-1.4.0.tar.gz"
    sha256 "80b7bda803d9a20e568453eb26f3530cd9bf602d6414f6ff6a74c611603396d2"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages3c563f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "oci" do
    url "https:files.pythonhosted.orgpackages4d3c5d9b6626f50f988cd6dece2c3b1b6155acd52a3a71b2e36118bdaa2ca32boci-2.120.0.tar.gz"
    sha256 "e5ba9700db2e0572f13897d28aef8944b9bf38faffc1b68fcfa154bcaefc5af1"
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