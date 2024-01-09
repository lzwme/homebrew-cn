class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https:awsu.me"
  url "https:files.pythonhosted.orgpackagesd708264d5c0b1a2618c95f3a391e038830c18bcccce5f202b293acdb14b7ac63awsume-4.5.4.tar.gz"
  sha256 "4c1f6336e1f9e36b2144761345967f50f43128363892cc62325577201e133b1b"
  license "MIT"
  head "https:github.comtrek10incawsume.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0baab1cd576a8746670b27b527c33ece0d92c7b6710f425e848eb9c23c26a729"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "073ea726d720fcd52c18eddd8b42573dee7000aa813e90680ca1dbedd6b243d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6dabc02c6053c1e1e18b2e85cfc8c59052bb118a583e6f7917b00d5a2674ed5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2de589c76b7ceaf0700ebb168b9909a1698cc00587acd3b45109757299e54029"
    sha256 cellar: :any_skip_relocation, ventura:        "f2325f84c18bab11f3e7fc389a6beba8bf9f54e573a46bd4b71c54ee50580287"
    sha256 cellar: :any_skip_relocation, monterey:       "652571844ec1f914a6bf896766bd03e1a50476ac3d51fcdfc411ff00953a5a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d424431bae3fd74268153e164d9008408f3c87fcced8d048eba3ba6fee9d060"
  end

  depends_on "python-psutil"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages5fb61e45c3a145304c3feaf48959c6a46efe9a256eec4d417a445b0d9827d20cboto3-1.34.14.tar.gz"
    sha256 "5c1bb487c68120aae236354d81b8a1a55d0aa3395d30748a01825ef90891921e"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages356da5aaf38f980060d17905398301033e9eb45c2552bf281fa7fd4c8e23ebddbotocore-1.34.14.tar.gz"
    sha256 "041bed0852649cab7e4dcd4d87f9d1cc084467fb846e5b60015e014761d96414"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages365104defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("bash -c '. #{bin}awsume -v 2>&1'")

    file_path = File.expand_path("~.awsumeconfig.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  PARTITION  ACCOUNT",
                 shell_output("bash -c '. #{bin}awsume --list-profiles 2>&1'")
  end
end