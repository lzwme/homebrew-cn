class HomeassistantCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line utility for Home Assistant"
  homepage "https:github.comhome-assistant-ecosystemhome-assistant-cli"
  url "https:files.pythonhosted.orgpackagesb298fd5e7beb7cc135f80d78b32c85ac15f3ba9219063b794b1d184fb07fd84bhomeassistant-cli-0.9.6.tar.gz"
  sha256 "9b9b705eaf6ee40dc6a732f3458c78ba37b62b7330bc17b132e6fee385ec8606"
  license "Apache-2.0"
  revision 5
  head "https:github.comhome-assistant-ecosystemhome-assistant-cli.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6896be90f5f0303cc83991675e96bb6ed2cd52c3386fd809e904207f9e4c6a9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e566298a8da19b7408774192e3d19f2a3018544d528a53a7df0537b5342f42ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3bdb54890889e3cc71d5cced7ff2a77adbf80e46435229a70a63dfd80cf8687"
    sha256 cellar: :any_skip_relocation, sonoma:         "53d2bbfc5f21d454205a709a800d0fe0b48a6ec5ebc6d4873e56e188c601d565"
    sha256 cellar: :any_skip_relocation, ventura:        "01739a27d0ddaa24db56e493f014d458d9e3140eb3baf82401e110fb2bbb060c"
    sha256 cellar: :any_skip_relocation, monterey:       "9df1b00d4e1d47a4ec0ed52a11a974f1f8a5193203575bf45d92a4e2f7f178d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "564de712b06777f82e301c86107abaee4ef329d64e8e86639f2459b87e81b19e"
  end

  depends_on "python-attrs"
  depends_on "python-click"
  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python-ply"
  depends_on "python-pytz"
  depends_on "python-requests"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages18931f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258baiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages3232228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "dateparser" do
    url "https:files.pythonhosted.orgpackages866e9a47cf3841bcfd1dd07a20b2aca42d4e02822ea7121aeb022869855b8d2fdateparser-0.7.6.tar.gz"
    sha256 "e875efd8c57c85c2d02b238239878db59ff1971f5a823457fcc69e493bf6ebfa"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "ifaddr" do
    url "https:files.pythonhosted.orgpackagese8acfb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "jsonpath-ng" do
    url "https:files.pythonhosted.orgpackages2a58a31c70d23cbab69129e72be2d70c7d525ee1bd7825e6312e7c09517a01a0jsonpath-ng-1.6.1.tar.gz"
    sha256 "086c37ba4917304850bd837aeab806670224d3f038fe2833ff593a672ef0a5fa"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "netdisco" do
    url "https:files.pythonhosted.orgpackages65caf9263e384128a973595dda4022c96cb89afab8a9a83435bc955ec6f23358netdisco-3.0.0.tar.gz"
    sha256 "4dbb590482f377ccc461e01742707ccbe8f1d2d1b28578af91dc9b7febcdcbd2"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesb53931626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesd1d6eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages04d3c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  resource "zeroconf" do
    url "https:files.pythonhosted.orgpackagesb4b0a4f6ceb219d3cfed5f1f8dcdbf026f9224b1da0d4da9e57af01d814fec17zeroconf-0.131.0.tar.gz"
    sha256 "90c431e99192a044a5e0217afd7ca0ca9824af93190332e6f7baf4da5375f331"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec"binhass-cli"
    generate_completions_from_executable(bin"hass-cli", base_name:              "hass-cli",
                                                         shells:                 [:fish, :zsh],
                                                         shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}hass-cli info 2>&1", 3)
    assert_match "Trying to locate Home Assistant on local network", output
    assert_match "warning: Found no Home Assistant on local network. Using defaults", output

    assert_match "hass-cli, version #{version}", shell_output("#{bin}hass-cli --version")
  end
end