class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/52/7c/ab31630035e2617420a76c2df8a92628798221e6d68d3116d0f0a3121933/terraform_local-0.22.0.tar.gz"
  sha256 "9724ab31837ef930d27cc57b09ebce4612f43338ccf2c10ba9518dde4070319f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0dd79bcf14897f294199a12bfeea2abae996498421d7abdb16b3c02c8531912e"
  end

  depends_on "localstack"
  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a5/dd/68ea8ab6dfbed46b75fcfe0bbd5ae19e4d3ef094b749ff8d944398e90f2d/boto3-1.38.17.tar.gz"
    sha256 "6058feef976ece2878ad3555f39933e63d20d02e2bbd40610ab2926d4555710a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/33/73/8b831403be00dbea152d4827929a5772f58e0413dd3e6b6d4b3592d88d39/botocore-1.38.17.tar.gz"
    sha256 "f2db4c4bdcfbc41d78bfe73b9affe7d217c7840f8ce120cff815536969418b18"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
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
    url "https://files.pythonhosted.org/packages/e6/ac/2897618a086ccef9e78389ce58cc28a38b058b5a211c29e2fd4ebf0324ff/python_hcl2-7.2.1.tar.gz"
    sha256 "bb5aad9e157ef65551a1fda0c08b170127b88caa416151c968b9688dbe99153d"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/fc/9e/73b14aed38ee1f62cd30ab93cd0072dec7fb01f3033d116875ae3e7b8b44/s3transfer-0.12.0.tar.gz"
    sha256 "8ac58bc1989a3fdb7c7f3ee0918a66b160d038a147c7b5db1500930a607e9a1c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end