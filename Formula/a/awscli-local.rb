class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/70/b2/a3eab5a0909bc2729fe14abdf9642889b6b6ff43a05777ed837235ec7fec/awscli-local-0.21.tar.gz"
  sha256 "99aad6b8e0cfefb2093453866cbcd24e710d7e6a1523cac0969ed0f64442ea7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f838b35373e0c53e39f8e33b2d54b254e4befca00382725b9b4110987b9305b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4aac2a52363f1a94a499c5402254f70d3303f76186304a42c5222c346681f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2ac156b6c9601527059193dbe34131021e3145712db6999cfca3ca5a0c680f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe395a2fa3b4c7bc83b9938cdf514d2ab311edd9c2ec142dda4955361def6c17"
    sha256 cellar: :any_skip_relocation, ventura:        "7dbf44b9021a4ec90313692cd0db9ecf7662f9fe7564fd8617e1d9b71ac344b6"
    sha256 cellar: :any_skip_relocation, monterey:       "0ad12085ff392710d9155c8926aeafc1ecae779c077881c00569bf903131252d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25200e2bb2943bc38af05e6f20c45ca04f3a6b772149430e507a4c64c8c2a18c"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/99/ac/3ddc134c8a4b81a7fdaf54ffe0e2e1cbd35bab929a2a3e7965b684f3d6ed/boto3-1.29.1.tar.gz"
    sha256 "20285ebf4e98b2905a88aeb162b4f77ff908b2e3e31038b3223e593789290aa3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e8/54/36268c9e26eafbf3db3764300f5dc195e26058b6e740c7025cb4ace47acc/botocore-1.32.1.tar.gz"
    sha256 "fcf3cc2913afba8e5f7ebcc15e8f6bfae844ab64bf983bf5a6fe3bb54cce239d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/ce/f6/7c19f1249cdcdc946616387e8aa93472f879624eb6acdd31a78a76fc046f/localstack-client-2.5.tar.gz"
    sha256 "8b8b2ee6013265a55d3e312a4513efccd222131bed79395545a4f643704f9213"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    output = shell_output("#{bin}/awslocal kinesis list-streams 2>&1", 255)
    assert_match "Could not connect to the endpoint URL", output
  end
end