class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/7c/17/a88a3e54c7c35918be510139e04f051aacca1a51b9cad3b133b0dada9735/terraform-local-0.18.1.tar.gz"
  sha256 "771fe73edb37a1b4db53ad641cf4354ea6fe7ac7849eb6b47a69f33c9909df35"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5c8d86c9a5345b15251dbdc52dbfbbf1064aa899fddd3278b8112ae463693b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5c8d86c9a5345b15251dbdc52dbfbbf1064aa899fddd3278b8112ae463693b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5c8d86c9a5345b15251dbdc52dbfbbf1064aa899fddd3278b8112ae463693b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "116f39ea8f5df16f0f92726ae297251c98befa6493dc5f6a2d4913454eea8e39"
    sha256 cellar: :any_skip_relocation, ventura:        "116f39ea8f5df16f0f92726ae297251c98befa6493dc5f6a2d4913454eea8e39"
    sha256 cellar: :any_skip_relocation, monterey:       "c0f8141c9ea9d4e62cbba7175e64dd36425f35c2d46edbd0070ea3c59f1858be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e3c0275f5c9c41e19ab935a39e8e67993cb40a1331ddc723b059aef2e0ab57"
  end

  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/81/f5/0c7d1b745462d9fe0c2b4709dc6a4b1cbe399c02ad60b26ae2837714d455/boto3-1.34.128.tar.gz"
    sha256 "43a6e99f53a8d34b3b4dbe424dbcc6b894350dc41a85b0af7c7bc24a7ec2cead"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9e/c9/844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484/botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/2c/e1/804b6196b3fbdd0f8ba785fc62837b034782a891d6f663eea2f30ca23cfa/lark-1.1.9.tar.gz"
    sha256 "15fa5236490824c2c4aba0e22d2d6d823575dcaf4cdd1848e34b6ad836240fba"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/ce/f6/7c19f1249cdcdc946616387e8aa93472f879624eb6acdd31a78a76fc046f/localstack-client-2.5.tar.gz"
    sha256 "8b8b2ee6013265a55d3e312a4513efccd222131bed79395545a4f643704f9213"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/19/f2/ed82d872706e52614506f74845868408e3c4b299bbb0dd3ccfd5fbbf8057/python-hcl2-4.3.4.tar.gz"
    sha256 "ef1b9bad018bcfc1fe2792044974299e559145fe96e3ca298c1e5e9500c8de66"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end