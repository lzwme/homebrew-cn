class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https:docs.cloud.oracle.comiaasContentAPIConceptscliconcepts.htm"
  url "https:files.pythonhosted.orgpackages7aab76302fe861aae42a1f57f3c3143947e79b56d241a65f0a65caa747a23c97oci-cli-3.37.6.tar.gz"
  sha256 "f21e63b8a0e68ea05e80158fb34579331bc7a065f25e43ad30595cc19b9576f6"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https:github.comoracleoci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1dea0e43958f58f32690807f1d2f017e43d684e929083577d59f7c763482728f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46153ed516360074cf94bddc2b87ad85c91cbc6929afa744e16c290c41a4c7cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab92f90ebc4ba371c257418a7a3d2c37a1fdd59a39b2b4d4a1e400caaef11ee9"
    sha256 cellar: :any_skip_relocation, sonoma:         "04d00d14db04fe8db62420f11859f687d5c0ce517219c58ade7ee032b9636c0e"
    sha256 cellar: :any_skip_relocation, ventura:        "04bfaacc7849b3aacc0df1b2ed7b20d08d258f71dd218275ea784fcbebc6fa42"
    sha256 cellar: :any_skip_relocation, monterey:       "95cccf249bf9715606c99081a5f5c39bda267b2c35bc6bc7153edbb6c64e6acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ea4ce9a052fbf5f7b66eb6adf4842dfa3f5cedcfaded9ae304e102ad9cee70"
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
    url "https:files.pythonhosted.orgpackages8e563dc8ff2a9af24b3a42ced473806e5515d920a1c83c458814dd1e686ed0a9oci-2.119.1.tar.gz"
    sha256 "992df963382f378b93634826956677f3c13407ca1b828c4eaf1cfd18f19fae33"
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