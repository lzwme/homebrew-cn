class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/48/30/3ca48aa0615960bc891c976512df7cca1ecf72535446f4bbe9b1ac110ebf/terraform_local-0.25.0.tar.gz"
  sha256 "8730cfc92dcdbfcb10293420cafb22566d56a2af58139e8a976828b10e07c7e2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcca12ab1ce928dfcf3d4a855fa36848a49a9853485876a8c8a796b66ebb0c1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2015b904ee6a3b2661d144174a723aadb38b32c0a1a614dd0af00e11473e9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9df6e8bf35581311014f1060e4d2cb298db76ce4076424949050a0280069d68d"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8f42469f5ad9bc726679e7ee03e849682bb7bb01883531c6ff5e5d0309fffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39d102b5d13a565c8acec434e3fef625a79d27ad38400a42db3cddb39777ae26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f78d6d783a389be3334d3ec4f450aa5e8b1e2aa9c5e315aebbc7c454d659d6"
  end

  depends_on "localstack"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f3/31/246916eec4fc5ff7bebf7e75caf47ee4d72b37d4120b6943e3460956e618/boto3-1.42.4.tar.gz"
    sha256 "65f0d98a3786ec729ba9b5f70448895b2d1d1f27949aa7af5cb4f39da341bbc4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/5c/b7/dec048c124619b2702b5236c5fc9d8e5b0a87013529e9245dc49aaaf31ff/botocore-1.42.4.tar.gz"
    sha256 "d4816023492b987a804f693c2d76fb751fdc8755d49933106d69e2489c4c0f98"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/22/11/4f10b87d634edd616d8063dd0ed1193be747e524e28801f826d72828b98f/localstack_client-2.10.tar.gz"
    sha256 "732a07e23fffd6a581af2714bbe006ad6f884ac4f8ac955211a8a63321cdc409"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/50/8e/f82ed407a10c2dd4228ff0fceec8a16dd6a9191a2ed119233c04dccf2ca4/python_hcl2-7.3.1.tar.gz"
    sha256 "f8f55583703daf7bbcb595a33c68de891064d565974ea39998b81d15a4c4657b"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end