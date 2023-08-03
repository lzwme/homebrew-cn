class Credstash < Formula
  include Language::Python::Virtualenv

  desc "Little utility for managing credentials in the cloud"
  homepage "https://github.com/fugue/credstash"
  url "https://files.pythonhosted.org/packages/b4/89/f929fda5fec87046873be2420a4c0cb40a82ab5e30c6d9cb22ddec41450b/credstash-1.17.1.tar.gz"
  sha256 "6c04e8734ef556ab459018da142dd0b244093ef176b3be5583e582e9a797a120"
  license "Apache-2.0"
  revision 8
  head "https://github.com/fugue/credstash.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7fc86c4ae019c9128481991f49a110e2976fe8a7269c7866e1e80c9d49f91b5"
    sha256 cellar: :any,                 arm64_monterey: "654e3512263aa1c466a011e3eaeddd5db7d9587c35df15ee70ecc795ef36373a"
    sha256 cellar: :any,                 arm64_big_sur:  "3cb7ebdaa4ca6e1a5ab67cf58f08f1ee3a209430847c5a2cdcd1a92e237c3d3d"
    sha256 cellar: :any,                 ventura:        "075e19ae95cc539286c6db05f0db8860e1b6e4c2baf76c62d404cf9de3ec1336"
    sha256 cellar: :any,                 monterey:       "c728f090886658565c5d94f1feb61d8ffe69d74eaa94bbc392f2802b8fa0d697"
    sha256 cellar: :any,                 big_sur:        "04217ea50519235ee427929270ecbb84fe37031c25630fbbc721a16577a6bc0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd291334b2878491a4cb1e4d5e36223e98540fd86f5c2e0d00b9f74155dac17f"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/f9/889e0c7d07bc5616d193d63b9600145d2d83f21a09fca40be078ef9323eb/boto3-1.28.17.tar.gz"
    sha256 "90f7cfb5e1821af95b1fc084bc50e6c47fa3edc99f32de1a2591faa0c546bea7"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/54/ce/3aced9653aa3b81aeda70574f342cd3014ecc36aff6a20e74c767f92864f/botocore-1.31.17.tar.gz"
    sha256 "396459065dba4339eb4da4ec8b4e6599728eb89b7caaceea199e26f7d824a41c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/8e/5d/2bf54672898375d081cb24b30baeb7793568ae5d958ef781349e9635d1c8/cryptography-41.0.3.tar.gz"
    sha256 "6d192741113ef5e30d89dcb5b956ef4e1578f304708701b8b73d38e3e1461f34"
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
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    output = shell_output("#{bin}/credstash put test test 2>&1", 1)
    assert_match "Could not generate key using KMS key", output
  end
end