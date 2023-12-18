class Pferd < Formula
  include Language::Python::Virtualenv

  desc "Programm zum Flotten Einfachen Runterladen von Dateien"
  homepage "https:github.comGarmelonPFERD"
  url "https:files.pythonhosted.orgpackages6550fae763bf94e3d9a25716f1a8b36481b1196bb64b5ac226286f3ad588dc81pferd-3.5.0.tar.gz"
  sha256 "90170cb5b7b5421193ba8b73d66899fc2027f3a8f595c10ac97fc6de756df7cf"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "581432771685aea2995b2301bd9742729463147c11af66c463c74f98fe2aed3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e21a6b3281c5e4acd379966564cbcad7cb9c876c7e82e309e4d6aa1c6f31a945"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a797aec2467997cce8447fd969bf5f8edf3b6854201f06aa35e50b6fbbb6a244"
    sha256 cellar: :any_skip_relocation, sonoma:         "28a1e770288cae00f0d3bb5ecff35668e0c8e33618a542ed286220bfea2cb05a"
    sha256 cellar: :any_skip_relocation, ventura:        "201786f4a6e3d0ac1c37c8fcf327e6fb81a5801c27cc11aedcbff5a82e8ab8ef"
    sha256 cellar: :any_skip_relocation, monterey:       "ad8bf60f21ebffff05b18b8811c0f50a89a4ca0ac23d6a01db550acc49fefa7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aadbddd02aab9380404459ea54b97a1c338e1b9de449cf62e9238dec3cd0304c"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages718068f3bd93240efd92e9397947301efb76461db48c5ac80be2423ffa9c20a3aiohttp-3.9.0.tar.gz"
    sha256 "09f23292d29135025e19e8ff4f0a68df078fe4ee013bca0105b2e803989de92d"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8c1f49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages3344ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages8bded0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfajaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages69cd889c6569a7e5e9524bc1e423fd2badd967c4a5dcd670c04c2eff92a9d397keyring-24.3.0.tar.gz"
    sha256 "e730ecffd309658a08ee82535a3b5ec4b4c8669a9be11efb66249d8e0aeb9a25"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages2d733557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages5f3f04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "PFERD #{version} (#{homepage})", shell_output("#{bin}pferd --version").strip

    assert_match "Error Failed to load config", shell_output("#{bin}pferd", 1)

    (testpath"pferd.cfg").write <<~EOS
      [crawl:Foo]
      type = kit-ilias-web
      target = 1234567
    EOS
    assert_match "key 'auth': Missing value", shell_output("#{bin}pferd -c #{testpath}pferd.cfg", 1)
  end
end