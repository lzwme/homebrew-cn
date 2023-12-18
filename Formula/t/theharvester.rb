class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http:www.edge-security.comtheharvester.php"
  url "https:github.comlaramiestheHarvesterarchiverefstags4.4.4.tar.gz"
  sha256 "502902effd86e8f1ff21a61386b627c57b3b9a6d0b42c4220a4ab9d3f17cab93"
  license "GPL-2.0-only"
  head "https:github.comlaramiestheHarvester.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sonoma:   "d1bf2d692add4aa44ff4eeada192a226b026d34c7b35b0c6a3a43f55f3d43a68"
    sha256 cellar: :any,                 arm64_ventura:  "fab2bde6dbbf9ef215ef5544df94573a7cd7a7a57184aaaa2166fd59537037e1"
    sha256 cellar: :any,                 arm64_monterey: "5d4df693a07384dabebc179b05c75052990dd54c74508e44d88cc4951be11186"
    sha256 cellar: :any,                 sonoma:         "7adbb2620ef5b11642c4bbae7fd6a311c1efd7c4596c18dbabf93d59c675800e"
    sha256 cellar: :any,                 ventura:        "838bf56c4facf9ad04868e32de08da4cba4ec98ed23acf92a62aeb26af29e468"
    sha256 cellar: :any,                 monterey:       "eaca8373194f4f1a309cddc7a1ee6e4551c96fea3e0dbda435b851847c48cd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59973ca47be2d5178ac19cec7b813b843a9efcb081c5decab60b1cbae6ae1f8"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-filelock"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "uvicorn"

  # How to update the resources
  # tar -zxvf theHarvester-#{version}.tar.gz
  # cd theHarvester-#{version} && virtualenv -p python3.12 .
  # source usrlocalbinactivate && pip install -r requirementsbase.txt
  # pip freeze > dependencies.log
  # run homebrew-pypi-poet on the freezed dependencies
  resource "aiodns" do
    url "https:files.pythonhosted.orgpackages2779df72e25df0fdd9bf5a5ab068539731d27c5f2ae5654621ae0c92ceca94cfaiodns-3.0.0.tar.gz"
    sha256 "946bdfabe743fceeeb093c8a010f5d1645f708a241be849e17edfb0e49e08cd6"
  end

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackagesaf41cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages718068f3bd93240efd92e9397947301efb76461db48c5ac80be2423ffa9c20a3aiohttp-3.9.0.tar.gz"
    sha256 "09f23292d29135025e19e8ff4f0a68df078fe4ee013bca0105b2e803989de92d"
  end

  resource "aiomultiprocess" do
    url "https:files.pythonhosted.orgpackages593064e01ec7ecb4aa1123b54401ffc36c16bb1d7155b924f7430a651fb956c1aiomultiprocess-0.9.0.tar.gz"
    sha256 "07e7d5657697678d9d2825d4732dfd7655139762dee665167380797c02c68848"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aiosqlite" do
    url "https:files.pythonhosted.orgpackagesea51060efa10a814145acd4e42c6e5ed540b8714cad52ca026c5930e7c473049aiosqlite-0.19.0.tar.gz"
    sha256 "95ee77b91c8d2808bd08a59fbebf66270e9090c3d92ffbf260dc0db0b979577d"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "censys" do
    url "https:files.pythonhosted.orgpackages3c2f8163deec66d895a86f9e477bdcd9049e0c52b85f3905b44049f188f4a1d8censys-2.2.5.tar.gz"
    sha256 "2c31eed2ac3df561be91225af30f4b0e7a8641645b535997a99e5e123f9f60a6"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "Deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages652d372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "fastapi" do
    url "https:files.pythonhosted.orgpackages90c48fda12dab6608a40f3490b0cad896b47bbeb8a0b952e94af36825042dfbffastapi-0.103.1.tar.gz"
    sha256 "345844e6a82062f06a096684196aaf96c1198b25c06b72c1311b882aa2d8a35d"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8c1f49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages3344ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "importlib-resources" do
    url "https:files.pythonhosted.orgpackagesd406402fb5efbe634881341ff30220798c4c5e448ca57c068108c4582c692160importlib_resources-6.1.1.tar.gz"
    sha256 "3893a00122eafde6894c59914446a512f728a0c1a45f9bb9b63721b6bacf0b4a"
  end

  resource "limits" do
    url "https:files.pythonhosted.orgpackages27aa7406e290a9072c47d4ec694e418a042bb0c3380429ac937704f4cdc58ee7limits-3.6.0.tar.gz"
    sha256 "57a9c69fd37ad1e4fa3886dff8d035227e1f6af87f47e9118627e72cf1ced3bf"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackagesc33bfe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "pycares" do
    url "https:files.pythonhosted.orgpackages1b8fdaf60bbc06f4a3cd1cfb0ab807057151287df6f5c78f2e0d298acc9193acpycares-4.4.0.tar.gz"
    sha256 "f47579d508f2f56eddd16ce72045782ad3b1b3b678098699e2b6a1b30733e1c2"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages0b6ccebf0e87ee0f2496584e04079592f33610f1f9aaf3684cb3105f03969e2bpydantic-2.5.1.tar.gz"
    sha256 "0b8be5413c06aadfbe56f6dc1d45c9ed25fd43264414c571135c97dd77c2bedb"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages4ceeb3479b31f47226bae5d9033761971bec215774a6078ce08e8618d6381470pydantic_core-2.14.3.tar.gz"
    sha256 "3ad083df8fe342d4d8d00cc1d3c1a23f0dc84fce416eb301e69f1ddbbe124d3f"
  end

  resource "pyee" do
    url "https:files.pythonhosted.orgpackagese688a917aaa0da1915292022745184275e095516b490a85d89fc48fd4de1c01apyee-8.2.2.tar.gz"
    sha256 "5c7e60f8df95710dbe17550e16ce0153f83990c00ef744841b43f371ed53ebea"
  end

  resource "pyppeteer" do
    url "https:files.pythonhosted.orgpackages68d610e7dfaa677888f59bb68902729e0b3d4dee540642533f60a4cdb8c1eb63pyppeteer-1.0.2.tar.gz"
    sha256 "ddb0d15cb644720160d49abb1ad0d97e87a55581febf1b7531be9e983aad7742"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages505cd32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "retrying" do
    url "https:files.pythonhosted.orgpackagesce7015ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9ddretrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "shodan" do
    url "https:files.pythonhosted.orgpackagesdb142e16620742e5d56eb6035c0bbf16ae04a8dee50d67d09d8df4e196d53184shodan-1.30.0.tar.gz"
    sha256 "c9617c66c47b87d4801e7080b6c769ec9a31da398defe0b047a6794927436453"
  end

  resource "slowapi" do
    url "https:files.pythonhosted.orgpackagesf5973e85a6097fb4986691b52dbef7ca7576f49740fc880160602f91a1062c69slowapi-0.1.8.tar.gz"
    sha256 "8cc268f5a7e3624efa3f7bd2859b895f9f2376c4ed4e0378dd2f7f3343ca608e"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackages0668559bed5484e746f1ab2ebbe22312f2c25ec62e4b534916d41a8c21147bf8starlette-0.27.0.tar.gz"
    sha256 "6a6b0d042acb8d469a01eba54e9cda6cbd24ac602c4cd016723117d6a7e73b75"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackages02214f2d7d6023650770112dd8144dbc47afabbfaf568a0d39abc0a4f37e8e9etldextract-5.1.1.tar.gz"
    sha256 "9b6dbf803cb5636397f0203d48541c0da8ba53babaf0e8a6feda2d88746813d4"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "ujson" do
    url "https:files.pythonhosted.orgpackages1516ff0a051f9a6e122f07630ed1e9cbe0e0b769273e123673f0d2aa17fe3a36ujson-5.8.0.tar.gz"
    sha256 "78e318def4ade898a461b3d92a79f9441e7e0e4d2ad5419abed4336d702c7425"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "XlsxWriter" do
    url "https:files.pythonhosted.orgpackages2ba3dd02e3559b2c785d2357c3752cc191d750a280ff3cb02fa7c2a8f87523c3XlsxWriter-3.1.9.tar.gz"
    sha256 "de810bf328c6a4550f4ffd6b0b34972aeb7ffcf40f3d285a0413734f9b63a929"
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
    inreplace "setup.py", "etctheHarvester", etc"theharvester"
    virtualenv_install_with_resources
    bin.install_symlink libexec"bintheHarvester" => "theharvester"

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[uvicorn].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    (testpath"proxies.yaml").write <<~EOS
      http:
      - ip:port
    EOS

    output = shell_output("#{bin}theharvester -d brew.sh --limit 1 --source urlscan 2>&1")
    assert_match "docs.brew.sh", output
    assert_match "formulae.brew.sh", output
  end
end