class Credstash < Formula
  include Language::Python::Virtualenv

  desc "Little utility for managing credentials in the cloud"
  homepage "https://github.com/fugue/credstash"
  url "https://files.pythonhosted.org/packages/b4/89/f929fda5fec87046873be2420a4c0cb40a82ab5e30c6d9cb22ddec41450b/credstash-1.17.1.tar.gz"
  sha256 "6c04e8734ef556ab459018da142dd0b244093ef176b3be5583e582e9a797a120"
  license "Apache-2.0"
  revision 5
  head "https://github.com/fugue/credstash.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "1cffee038b336f6e9df970b9d44e84b7450243bb198e88b98ee3b389c5c2d87b"
    sha256 cellar: :any,                 arm64_monterey: "357c449f4b8d69267518766e9987c990ae81191c085ae04eb9c9a1badd30748b"
    sha256 cellar: :any,                 arm64_big_sur:  "8d37bc25623a567bf438a79c8454028b9098c974e328d112a1c43d25453da2dd"
    sha256 cellar: :any,                 ventura:        "7030205fb14bc22af538fa845510fbd1c9ed194bf89975129174ad51be8b06f1"
    sha256 cellar: :any,                 monterey:       "4027f1207181e09013ade7d97529211c287c27a1c0bec3954e4d2dad25e1c4db"
    sha256 cellar: :any,                 big_sur:        "04d1a325bb4025d10fb59b2b4dfbc10a8ba6241c3b20c7b30e0f182e6f4102ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d78f3ed6e3d277a0dd581595c92479c34a0d7546fcdd415c4ed257cf17f377b"
  end

  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f7/d4/0448f83fa6fb5de4bafaf5490d105683ad82bb97d95ce82ec26c48180a8a/boto3-1.26.142.tar.gz"
    sha256 "8f4b5c93a7f0c8e40ae1983cfbefd017bd625e554426544c78dceb4045648911"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/fd/40/df47658153a2458cf92c45bbcb878b96e860dfc30ac935117ff7905d3d21/botocore-1.29.142.tar.gz"
    sha256 "512d2f48fc1471f169bc210eede662f8da66be3cebc1515dfb5411a18b2aeabf"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
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
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
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