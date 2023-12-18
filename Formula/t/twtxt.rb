class Twtxt < Formula
  include Language::Python::Virtualenv

  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https:github.combuckkettwtxt"
  url "https:files.pythonhosted.orgpackagesfc4ccff74642212dbca8d4d9059119555cd335324b3da0b52990a414a0257756twtxt-1.3.1.tar.gz"
  sha256 "f15e580f8016071448b24048402b939b9e8dec07eabacd84b1f2878d751b71ff"
  license "MIT"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94084bf50b4023c9717fed819b4ac3fdb2f5647f453d9a2e8613609fc0a94f5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7dd80e80d55c39478cce312b6587ddd49721a1e2492ca9fb52d81c8d533e7ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dca14622de8dda2e63577b05b8810ef671104787553a396a5ad3a0197b33914a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f890820dd3b7b3a6d30b225db867a227259615c7d7facf963b23b6bb050d92e"
    sha256 cellar: :any_skip_relocation, ventura:        "054f0f471019a0e9f4e6707b4cc853439df52cc24e4551f3fd5d22caae58ad71"
    sha256 cellar: :any_skip_relocation, monterey:       "87d74fbbd094e3529ab3ff62d935ef4225c740b7c86305c7728f3f20a8712564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66e7434748b514f0411d5ff7919c462fcea51aa6c1287698add2200bd934758"
  end

  depends_on "python-click"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

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

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8c1f49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages0c84e58c665f4ebb03d2fbeb28b51afb0743f846db18a5b594ed8b8973676ddfhumanize-4.8.0.tar.gz"
    sha256 "9783373bf1eec713a770ecaa7c2d7a7902c98398009dfa3d8a2df91eec9311e8"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages5f3f04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"twtxt", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath"config").write <<~EOS
      [twtxt]
      nick = homebrew
      twtfile = twtxt.txt
      [following]
      brewtest = https:example.orgalice.txt
    EOS
    assert_match "✓ You’ve unfollowed brewtest", shell_output("#{bin}twtxt -c config unfollow brewtest")

    assert_match version.to_s, shell_output(bin"twtxt --version")
  end
end