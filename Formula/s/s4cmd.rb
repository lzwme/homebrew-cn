class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https://github.com/bloomreach/s4cmd"
  url "https://files.pythonhosted.org/packages/42/b4/0061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34/s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 2
  head "https://github.com/bloomreach/s4cmd.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfa74e751836c043bb6d908e92f59818408e7eed6bb701d4cfe02feff676f587"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11adfe8f1c87eb35d70d950465d4c9ff92482cf0da8ad84a1d02d09c1cd76820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7e56759aef5c24f86c1152e52c565de712f9706bb4111595e80c8ae895de180"
    sha256 cellar: :any_skip_relocation, sonoma:         "854f04b313ddbc68dfb859749c49f343cdbcd384c278ae6e2d11b5b913076366"
    sha256 cellar: :any_skip_relocation, ventura:        "c8f40364d09dcb7c9a72ebcc7b0aaf1f1d438ce7ccef44b6054becd37b0fd601"
    sha256 cellar: :any_skip_relocation, monterey:       "681ddc2aba08ba18ec2d3bb4db42f3ba3a45cdcfce973ca24b3536fbf2dbf70f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8aa586e1f2f5f8c89f67f21ca0be9a3fe654263947ba34fd0634e3809dd94fa"
  end

  depends_on "python-dateutil"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/32/e0/451d5ff97dd90376224ba54c6771ead856b020c74939d16f7923f88bc601/boto3-1.28.79.tar.gz"
    sha256 "b8acb57a124434284d6ab69c61d32d70e84e13e2c27c33b4ad3c32f15ad407d3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/64/4a/c4829451faaf9c7b670a4520864e6838bdbb7eec7b92450d879e4b8e4d1a/botocore-1.31.79.tar.gz"
    sha256 "07ecb93833475dde68e5c0e02a7ccf8ca22caf68cdc892651c300529894133e1"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}/s4cmd ls s3://brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/s4cmd --version")
  end
end