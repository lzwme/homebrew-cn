class Credstash < Formula
  include Language::Python::Virtualenv

  desc "Little utility for managing credentials in the cloud"
  homepage "https://github.com/fugue/credstash"
  url "https://files.pythonhosted.org/packages/b4/89/f929fda5fec87046873be2420a4c0cb40a82ab5e30c6d9cb22ddec41450b/credstash-1.17.1.tar.gz"
  sha256 "6c04e8734ef556ab459018da142dd0b244093ef176b3be5583e582e9a797a120"
  license "Apache-2.0"
  revision 9
  head "https://github.com/fugue/credstash.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30e9dfa2ccc36e720b7eee5e40102b2947d9122107dd7b40ba7ce9dc5375e1e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eb5dcf022551de21d49cc7f06492e78e0c525ae292c17f8c54db51b1bf931db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e9e08e6ddbd9f464b06d3fd9b3d4ae4845dffa5641da31122e177df9ebc325a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b9d87bb6fbd1f3587cbb9983589c608023f5664bcc74dd6686b0981ce1d4a34"
    sha256 cellar: :any_skip_relocation, ventura:        "b57a63ebebb9eab01391f6392bf2e7daea6db637d82db81206769b3afd80c333"
    sha256 cellar: :any_skip_relocation, monterey:       "0df5a49ffb25c4bf2459d9d3d834a26121af53a158b16465d99e877d8c2b09d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f4d15f859169b45ef90c2f055a8fd4a593b0e1fafd61387b5dd506cd4458b2"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/42/56/633b5f5b930732282e8dfb05c02a3d19394d41f4e60abfe85d26497e8036/boto3-1.28.61.tar.gz"
    sha256 "7a539aaf00eb45aea1ae857ef5d05e67def24fc07af4cb36c202fa45f8f30590"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/2e/9cb8adca433af2bb6240514448b35fa797c881975ea752242294d6e0b79f/botocore-1.31.61.tar.gz"
    sha256 "39b059603f0e92a26599eecc7fe9b141f13eb412c964786ca3a7df5375928c87"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
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
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    output = shell_output("#{bin}/credstash put test test 2>&1", 1)
    assert_match "Could not generate key using KMS key", output
  end
end