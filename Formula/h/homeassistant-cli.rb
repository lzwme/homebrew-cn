class HomeassistantCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line utility for Home Assistant"
  homepage "https://github.com/home-assistant-ecosystem/home-assistant-cli"
  url "https://files.pythonhosted.org/packages/b2/98/fd5e7beb7cc135f80d78b32c85ac15f3ba9219063b794b1d184fb07fd84b/homeassistant-cli-0.9.6.tar.gz"
  sha256 "9b9b705eaf6ee40dc6a732f3458c78ba37b62b7330bc17b132e6fee385ec8606"
  license "Apache-2.0"
  revision 4
  head "https://github.com/home-assistant-ecosystem/home-assistant-cli.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfb89b35b6050ba5222269153f826aa54f9e4af62e73bdd0aa2337c052f2fb6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01ea41ca3ef79a1eaecd9ecdad031c3700496cd2bc56a25d9313adbb9fa9bcd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e81150ec7d3ec5ecf35cdcf873757c1330afeff4e66174a450c5c9e87ddd4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "df04485741886d6fa537d32fb448e936da686df42a575491916068baaff8155b"
    sha256 cellar: :any_skip_relocation, ventura:        "fcaef0cc9c8572081c7c1a7bcc36c9b0254fb69be26deada2cf082eb4cbc5dd4"
    sha256 cellar: :any_skip_relocation, monterey:       "e10fc25494a258f37b2e9f5e7287123f06d33c9a4f033a9f5884e9dfe7e092b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4074769064d8ee4cf5599cb93e527dc2b1f7e1ba0bba24cf35cc53c73a9ebc8"
  end

  depends_on "python-certifi"
  depends_on "python-pytz"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c4/50/a717a133bda2efc27efbf8a65398c925b6d0605213da0db6929627ccb758/aiohttp-3.9.0b0.tar.gz"
    sha256 "cecc64fd7bae6debdf43437e3c83183c40d4f4d86486946f412c113960598eee"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
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
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/86/6e/9a47cf3841bcfd1dd07a20b2aca42d4e02822ea7121aeb022869855b8d2f/dateparser-0.7.6.tar.gz"
    sha256 "e875efd8c57c85c2d02b238239878db59ff1971f5a823457fcc69e493bf6ebfa"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/b2/f3/37dfe7f3e4f5e21f66f301bc82a6aaca23fed8c435514a699f0af283c9e7/jsonpath-ng-1.6.0.tar.gz"
    sha256 "5483f8e9d74c39c9abfab554c070ae783c1c8cbadf5df60d561bc705ac68a07e"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "netdisco" do
    url "https://files.pythonhosted.org/packages/65/ca/f9263e384128a973595dda4022c96cb89afab8a9a83435bc955ec6f23358/netdisco-3.0.0.tar.gz"
    sha256 "4dbb590482f377ccc461e01742707ccbe8f1d2d1b28578af91dc9b7febcdcbd2"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/de/7d/4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54/ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/b2/e2/adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0a/tzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/47/29/59b3d01126e9dfee0a53f51f6f0b3e7b0afdeb0bc26c3dae7aac59b27a14/zeroconf-0.118.0.tar.gz"
    sha256 "d0254229b9fde339e6578caeb76d0a8d0ec7c768bb194308a006f9001467cbea"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/hass-cli"
    generate_completions_from_executable(bin/"hass-cli", base_name:              "hass-cli",
                                                         shells:                 [:fish, :zsh],
                                                         shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/hass-cli info 2>&1", 3)
    assert_match "Trying to locate Home Assistant on local network", output
    assert_match "warning: Found no Home Assistant on local network. Using defaults", output

    assert_match "hass-cli, version #{version}", shell_output("#{bin}/hass-cli --version")
  end
end