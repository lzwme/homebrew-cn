class Llm < Formula
  include Language::Python::Virtualenv

  desc "Access large language models from the command-line"
  homepage "https://llm.datasette.io/"
  url "https://files.pythonhosted.org/packages/a4/27/99003e30e646346e3beb160edb9d8554aa6a3aaa2b62168f665776d06d16/llm-0.6.1.tar.gz"
  sha256 "f4470292202abb57871b6ee373c1397b9da6271044094b01afd8efdb7f0770ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2dcb0deb7fbcae9c8918b74a0aadb046e9dc13c07753473a957e84a7dbe6707a"
    sha256 cellar: :any,                 arm64_monterey: "d29bc9b6ad0fc95f9d26183c3326b113f7e994e7fd37e057e4b15f7ec3c3e50c"
    sha256 cellar: :any,                 arm64_big_sur:  "0fab633749f23f76a326d58379cdee517c8e00cbc7b3c44a2ff477909868d542"
    sha256 cellar: :any,                 ventura:        "2c9553253be6be57534839985666c8f75fbd8e784b37fe38a7cbadd105245136"
    sha256 cellar: :any,                 monterey:       "bffd01c98f8fbc73870b63267a9a5699a56a7493a0f96d52b2a29907efe10899"
    sha256 cellar: :any,                 big_sur:        "5f53153ab66114a0b00fd99c05b47d6e8fadfec66fb0f7d3a28ed9b2710dc98a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5143f3397139afa4ad17878276a51534e9e8ef070c2eccfe83dc072059688df"
  end

  depends_on "rust" => :build
  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/d6/12/6fc7c7dcc84e263940e87cbafca17c1ef28f39dae6c0b10f51e4ccc764ee/aiohttp-3.8.5.tar.gz"
    sha256 "b9552ec52cc147dbf1944ac7ac98af7602e51ea2dcd076ed194ca3c0d1c7d0bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/42/97/41ccb6acac36fdd13592a686a21b311418f786f519e5794b957afbcea938/annotated_types-0.5.0.tar.gz"
    sha256 "47cdc3490d9ac1506ce92c7aaa76c579dc3509ff11e098fc867e5130ab7be802"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "click-default-group-wheel" do
    url "https://files.pythonhosted.org/packages/3d/da/f3bbf30f7e71d881585d598f67f4424b2cc4c68f39849542e81183218017/click-default-group-wheel-1.2.2.tar.gz"
    sha256 "e90da42d92c03e88a12ed0c0b69c8a29afb5d36e3dc8d29c423ba4219e6d7747"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/89/ee/84bbd0161090f0f24e8a2ac175e6b6a936289ee02e9d5da414ce14d3d332/openai-0.27.8.tar.gz"
    sha256 "2483095c7db1eee274cebac79e315a986c4e55207bb4fa7b82d185b3a2ed9536"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/11/07/106b00ae62297bb3c89b6fbeb571feaf7cbbf6b2ada0e513d756daafd4ce/pydantic-2.0.3.tar.gz"
    sha256 "94f13e0dcf139a5125e88283fc999788d894e14ed90cf478bcc2ee50bd4fc630"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/57/ea/edff47ad42857534f3abcc87472802b3181041f4e4fbeac988a5ecfcffae/pydantic_core-2.3.0.tar.gz"
    sha256 "5cfb5ac4e82c47d5dc25b209dd4c3989e284b80109f9e08b33c895080c424b4f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-ulid" do
    url "https://files.pythonhosted.org/packages/e8/8b/0580d8ee0a73a3f3869488856737c429cbaa08b63c3506275f383c4771a8/python-ulid-1.1.0.tar.gz"
    sha256 "5fb5e4a91db8ca93e8938a613360b3def299b60d41f847279a8c39c9b2e9c65e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/29/4d/eae906595a22c1ffa96105f6a5477cd502cc3ec1dfcabad2f5057dced4ea/sqlite-utils-3.34.tar.gz"
    sha256 "4607683cbb32cfd4f3c63929045eaa020ab0221c5036f9bb41b7b25bc755cd23"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["OPENAI_API_BASE"] = "https://openai-canned-completion.vercel.app/v1"
    ENV["OPENAI_API_KEY"] = "x"
    assert_match "Hello! How can I assist you today?", shell_output("#{bin}/llm hello --no-log")

    assert_match "llm, version", shell_output("#{bin}/llm --version")
  end
end