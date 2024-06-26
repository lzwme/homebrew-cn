class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/d5/29/640500973b4c22af48fef3526c111c7fe2cb9ade63c71e6fdd76e2154b2d/terraform_local-0.18.2.tar.gz"
  sha256 "f28a6231de99c605912480dad2f859261e5b9ac3bf09a1e0189e2c74477164b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07ae3407bbbbfed88e9f1c012f30f34d4a4c670d90927393580cd13cd921bcfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07ae3407bbbbfed88e9f1c012f30f34d4a4c670d90927393580cd13cd921bcfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07ae3407bbbbfed88e9f1c012f30f34d4a4c670d90927393580cd13cd921bcfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "51840dbcf0de52d123b652dc47f2b40e828e698d230d10a6fb9a546bccbb2efd"
    sha256 cellar: :any_skip_relocation, ventura:        "51840dbcf0de52d123b652dc47f2b40e828e698d230d10a6fb9a546bccbb2efd"
    sha256 cellar: :any_skip_relocation, monterey:       "51840dbcf0de52d123b652dc47f2b40e828e698d230d10a6fb9a546bccbb2efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0d70c8a873094e0bd2338d16df4ec3727bde1b72de18c7eca9d845e12568d5"
  end

  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/dc/67/5af04581d1fa7411cc336a6fdaaa9794005b2a4f87e0cb08f2e8af761040/boto3-1.34.132.tar.gz"
    sha256 "3b2964060620f1bbe9574b5f8d3fb2a4e087faacfc6023c24154b184f1b16443"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1e/81/2340ab8930a14ccf5caf15c4383649ef83ce27f99a3487e97232b58a1fa3/botocore-1.34.132.tar.gz"
    sha256 "372a6cfce29e5de9bcf8c95af901d0bc3e27d8aa2295fadee295424f95f43f16"
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
    url "https://files.pythonhosted.org/packages/cb/67/94c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fab/s3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
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