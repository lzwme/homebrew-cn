class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https:github.combloomreachs4cmd"
  url "https:files.pythonhosted.orgpackages42b40061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 3
  head "https:github.combloomreachs4cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb2e46cd954e06eabe0bb8264cff721271d51c1dcd2fee8bdd6be1ff915c9b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb2e46cd954e06eabe0bb8264cff721271d51c1dcd2fee8bdd6be1ff915c9b8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb2e46cd954e06eabe0bb8264cff721271d51c1dcd2fee8bdd6be1ff915c9b8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb2e46cd954e06eabe0bb8264cff721271d51c1dcd2fee8bdd6be1ff915c9b8a"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2e46cd954e06eabe0bb8264cff721271d51c1dcd2fee8bdd6be1ff915c9b8a"
    sha256 cellar: :any_skip_relocation, monterey:       "cb2e46cd954e06eabe0bb8264cff721271d51c1dcd2fee8bdd6be1ff915c9b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "739d479e2f285c9a8c0f42d484423e53690b3319d47a6c9928483ac0dafef67f"
  end

  depends_on "python@3.12"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages9442f34ab93ea175b4e6c96e73a3b3f24d073f63418971925c8149d41f6a252aboto3-1.34.136.tar.gz"
    sha256 "0314e6598f59ee0f34eb4e6d1a0f69fa65c146d2b88a6e837a527a9956ec2731"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages3cec09d963aa91a1d09a87c21c014da5092a1eccde8b44cd51bbe8a27e3576fdbotocore-1.34.136.tar.gz"
    sha256 "7f7135178692b39143c8f152a618d2a3b71065a317569a7102d2306d4946f42f"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}s4cmd ls s3:brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}s4cmd --version")
  end
end