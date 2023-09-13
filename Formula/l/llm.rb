class Llm < Formula
  include Language::Python::Virtualenv

  desc "Access large language models from the command-line"
  homepage "https://llm.datasette.io/"
  url "https://files.pythonhosted.org/packages/a9/0a/feb801e768ada21e07744d3340d24c8c91855be50903b451646918282f56/llm-0.10.tar.gz"
  sha256 "67e64734365024a2ea563664af659600e7e48b2a6669aaa764f09bdef14362cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b396176b035f32688f565b382b87f0a0eeb7b208b71c5bbd3bb76b47866d687"
    sha256 cellar: :any,                 arm64_monterey: "a7e5eab4baacd8b935239ae88917d346c128bc0bfbff60ac759c608adde934ee"
    sha256 cellar: :any,                 arm64_big_sur:  "e994a7b16803a6ad22a08f674451c02442d5944b47a87f4ddd45d5f3b96ff846"
    sha256 cellar: :any,                 ventura:        "c10feda519398e38a99ab220f85b2eb421d9fe90c5ca5a5c59c3546861a68246"
    sha256 cellar: :any,                 monterey:       "f83e227888ea03f021cc4004e318e20e7b5db09cd9bb5684f869c08d0c6df520"
    sha256 cellar: :any,                 big_sur:        "5ee1c0a3134dea0a252500631b7a74a244315bd1f8a5cbbcb3f0d1800777ac1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "175434e62f732fe820957d6c6d288ea11772bc7ed417e812f04fb03e6efcc436"
  end

  depends_on "rust" => :build
  depends_on "pygments"
  depends_on "python-certifi"
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
    url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
    sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
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
    url "https://files.pythonhosted.org/packages/5e/a8/f8d00a76f3991ff250b6584434ca24c2d275c6f3e97592b44f4ca124c47a/openai-0.28.0.tar.gz"
    sha256 "417b78c4c2864ba696aedaf1ccff77be1f04a581ab1739f0a56e0aae19e5a794"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/fd/fe/8f08bf18b2c53afb4b358fae6e9b3501e169a2c1c9c0cd96f21a40bb7abd/pydantic-2.3.0.tar.gz"
    sha256 "1607cc106602284cd4a00882986570472f193fde9cb1259bceeaedb26aa79a6d"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/cb/fe/8c9363389f8f303fb151895af83ac30e06c0406779fe188b4281a64e4c50/pydantic_core-2.6.3.tar.gz"
    sha256 "1508f37ba9e3ddc0189e6ff4e2228bd2d3c3a4641cbe8c07177162f76ed696c7"
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

  resource "sqlite-migrate" do
    url "https://files.pythonhosted.org/packages/9e/33/0b0fc2ac04f91b0cde409ec1a177753a2ff46a7f211116d511dde2e6d2a2/sqlite-migrate-0.1a2.tar.gz"
    sha256 "c33b40a9edd35b4490e095f55cf59e03828d25c8b97377cd8a1f7b72694fc111"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/84/39/4ce5c5ac7ac6a485349f8636a920cd2568bf8f11298519d552b0c57351db/sqlite-utils-3.35.1.tar.gz"
    sha256 "e0f03e6976b05bdb7a5c56454971a0e980fc16dbfd3512bbd3bdcac4f0e4370e"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
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