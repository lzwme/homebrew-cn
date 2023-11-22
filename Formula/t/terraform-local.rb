class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/aa/f7/69c2981d89c0e074bf15272304fe6843ffcb266cfe044b32f36e23a6e628/terraform-local-0.16.0.tar.gz"
  sha256 "3193213c54275d5a2407d01763778a876e45a04daaa48c4a698a64807d757a1e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4787ee0fd67f0a48555fe8f57f967958b7ba21e01c0a6c85a041682e05e895e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83b87457938333dad2ec3b84d48dad8f83f80af81fbc9ed496e1fbc1dc3c86d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2db5173c4077797ae8d3675e4a6a324d16a4c4e4a97074483e4ebd1ec0745ce8"
    sha256 cellar: :any_skip_relocation, sonoma:         "351a8bc6364ff11b9b23043011d15f34637eacbe383cd16db74ef2b25da68bb3"
    sha256 cellar: :any_skip_relocation, ventura:        "463318200f3932921761be0205850b3c155a0709b6d7def039d83cf42b16ec42"
    sha256 cellar: :any_skip_relocation, monterey:       "ff0de69dc965fab6da50871c25de7971cdc554672a4d5fc008c4a78bbed5203f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58cdb69108e7faa75be90a199fce526d274e55de43945c6bb90a8f840ca024d2"
  end

  depends_on "localstack"
  depends_on "python-dateutil"
  depends_on "python@3.12"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/de/a5/4ae1555dd922da0543172241849a795a9dc6385e0bd8a0d8acd8765d10d6/boto3-1.29.2.tar.gz"
    sha256 "f3024bba9ac980007ba7b5f28a9734d111fb5466e2426ac76c5edbd6dedd8db2"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/63/5b/b78ac001e26069a2348b7edc131cbd2aa526ffa496a603df8ed3231ae36d/botocore-1.32.2.tar.gz"
    sha256 "0e231524e9b72169fe0b8d9310f47072c245fb712778e0669f53f264f0e49536"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/12/1c/b466b58dacac15ffefce9bcb5128e18948a143849610a7d5300f31920be0/lark-1.1.8.tar.gz"
    sha256 "7ef424db57f59c1ffd6f0d4c2b705119927f566b68c0fe1942dddcc0e44391a5"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/ce/f6/7c19f1249cdcdc946616387e8aa93472f879624eb6acdd31a78a76fc046f/localstack-client-2.5.tar.gz"
    sha256 "8b8b2ee6013265a55d3e312a4513efccd222131bed79395545a4f643704f9213"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/ef/94/cc6f7100a857a5a4a676c2c71322ca476051278fad4ec956f0116c1d3834/python-hcl2-4.3.2.tar.gz"
    sha256 "7122661438be27ccd8b8f3db71969d8ef2cce3b3cf183e88f8172575e7405a65"
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
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match "No such file or directory", output
  end
end