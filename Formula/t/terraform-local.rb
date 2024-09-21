class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/3f/c8/e80071e1de6b2c3f9b069ae78cc2c0bfb0688ee4c2467742891ea254bb11/terraform_local-0.20.0.tar.gz"
  sha256 "2f1c7f82d8cbb9f1595b372f3a2892514a6d33b26d1678a004dec31be9614318"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "669085a7eac383a57d7910216518fef115c958a60bd1a559e33dd1386892ab07"
  end

  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/09/31/aa8f565871e00264874bf220ab9913a168fe8acf8b19f7c1a344d1623104/boto3-1.35.23.tar.gz"
    sha256 "3fbf1d5b749c92ed43aa190650979dff9f83790a42522e1e9eefa54c8e44bc4b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9a/7a/1c9a1b478c4cdafae166572d5dc2aff93cd34c04fdfbfb0772cf1fccfcfa/botocore-1.35.23.tar.gz"
    sha256 "25b17a9ccba6ad32bb5bf7ba4f52656aa03c1cb29f6b4e438050ee4ad1967a3b"
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
    url "https://files.pythonhosted.org/packages/d8/25/49e13f48edf63194359022cd288b643caec10acceef78dcbe93a46e4ee04/localstack_client-2.6.tar.gz"
    sha256 "67c9da9ea04152b142ecd1ac9a2ae2e231c2a8fcff542faf02d7f9f80843f215"
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
    url "https://files.pythonhosted.org/packages/17/b8/6d82f3ac6b14493e524df946365670235570a2074cb2621ea67caa4e8952/python-hcl2-4.3.5.tar.gz"
    sha256 "71fbe48ee9a13335828f04adff2b267e06045c44c99c737b13d940aa1468d101"
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
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end