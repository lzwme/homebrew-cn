class Chatblade < Formula
  include Language::Python::Virtualenv

  desc "CLI Swiss Army Knife for ChatGPT"
  homepage "https://github.com/npiv/chatblade"
  url "https://files.pythonhosted.org/packages/23/b9/31ee0c050069c212d09027129e37fb0e5392c1827770bfe046977cac9340/chatblade-0.2.3.tar.gz"
  sha256 "61765ea885fc731343bcce0f9f4a2be8baa3d9f7d7f5a41bddbff13087811d19"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55e08fb80c9902f261f492072f9259668787af3bdfc639be35b112de4d9658c1"
    sha256 cellar: :any,                 arm64_monterey: "cef279173c6cbedd9de2ed04ebbf37efde8e5d0f46b42c677875c782abc5e2ae"
    sha256 cellar: :any,                 arm64_big_sur:  "274e54cd78f12c4ec58b846ca796927802013d3efe1400246a3a130f4355a7f6"
    sha256 cellar: :any,                 ventura:        "5e1446c7265e6d0fca8d2248a9193bb7ba5312baaf8a64123a8e751adf32d7e7"
    sha256 cellar: :any,                 monterey:       "df4995b29f5a8f24c7e2b50e9a36154caee79740d672e5aac26d4cd5f63845a2"
    sha256 cellar: :any,                 big_sur:        "29d80987bd05db35b3ca7e5f4a5363b8317907cd700168548a849223debd59fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c8a918e364b4b56e6129313063244d09783682739f84a1a439e1c2813d9378a"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c2/fd/1ff4da09ca29d8933fda3f3514980357e25419ce5e0f689041edb8f17dab/aiohttp-3.8.4.tar.gz"
    sha256 "bf2e1a9162c1e441bf805a1fd166e249d574ca04e03b34f97e2928769e91ab5c"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/a9/94/3d4755c8126eeb4b3469d8b9aff5600085f6d7de691da1ac04c79c24dc48/openai-0.27.2.tar.gz"
    sha256 "5869fdfa34b0ec66c39afa22f4a0fb83a135dff81f6505f52834c6ab3113f762"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/79/c4/f98a05535344f79699bbd494e56ac9efc986b7a253fe9f4dba7414a7f505/platformdirs-3.1.1.tar.gz"
    sha256 "024996549ee88ec1a9aa99ff7f8fc819bb59e2c3477b410d90a16d32d6e707aa"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/5e/0e/ef0a49be56dbc4052a086888cd2490e15fcc95b0eda79e9d0e737b1ab93d/rich-13.3.2.tar.gz"
    sha256 "91954fe80cfb7985727a467ca98a7618e5dd15178cc2da10f553b36a93859001"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/91/ed/c6596b42188c03b671ea4d8b6912c1f280ac2991664235039d3a18069d6a/tiktoken-0.3.2.tar.gz"
    sha256 "a51b5449e883e409cf2f4a846a6a97962d5656a354a5532c330811c833ac3b37"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/c4/1e/1b204050c601d5cd82b45d5c8f439cb6f744a2ce0c0a6f83be0ddf0dc7b2/yarl-1.8.2.tar.gz"
    sha256 "49d43402c6e3013ad0978602bf6bf5328535c48d192304b91b97a3c6790b1562"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "gpt-3.5-turbo", shell_output("#{bin}/chatblade -t count tokens")
  end
end