class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https:github.combloomreachs4cmd"
  url "https:files.pythonhosted.orgpackages42b40061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 2
  head "https:github.combloomreachs4cmd.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "103c679241f0b70f2aa12599c10a46dcd7227ddbd9db66c8f108855a74d7c547"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22b4ce77eeb40eb4ecda2862cb2b75cee7e61dc17c74cdbb066ea6b350095f55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719c197edf8ade59f0eb9ff7afc3dfac57f39518d2ddece8e036390d2a379fb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "81774bd95aad818da2ecbe786245df9948da449dd1b8db459b9699c1b486222c"
    sha256 cellar: :any_skip_relocation, ventura:        "176842842c1cfa2ef5c103aa3f5e405d170aeb10c81286b3241f502d96be65d8"
    sha256 cellar: :any_skip_relocation, monterey:       "45fd295f1235ecab38e59f85d955cc85ee4579bf30edcc37ebc9f6332f177201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f19512e5dc935d54703e52701a066aa9bd9364ef5c3f5c41b12412d391aca84"
  end

  depends_on "python@3.12"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages89518b7c07768bef5756cdc38b3168b228139d2ff1ddd782e515f1c0f2c35a2aboto3-1.34.47.tar.gz"
    sha256 "7574afd70c767fdbb19726565a67b47291e1e35ec792c9fbb8ee63cb3f630d45"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages93cf8c9516f6b1fb859e7fcb7413942b51573b54113307a92db46a44497a3b96botocore-1.34.47.tar.gz"
    sha256 "29f1d6659602c5d79749eca7430857f7a48dd02e597d0ea4a95a83c47847993e"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}s4cmd ls s3:brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}s4cmd --version")
  end
end