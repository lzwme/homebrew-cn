class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http:www.edge-security.comtheharvester.php"
  url "https:github.comlaramiestheHarvesterarchiverefstags4.5.1.tar.gz"
  sha256 "cbda16881a0caef600a7f75a0b7443403f5744baa4cbe1080a49dfc7875ad5e0"
  license "GPL-2.0-only"
  head "https:github.comlaramiestheHarvester.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b52786713c379cd8969bc4eb14d75057d944dac6f4364a2318804ddb7ff895d"
    sha256 cellar: :any,                 arm64_ventura:  "704cfd24d46cd5afc5868c16b2e47a3b9afaa336f19fc9e0dc502cb24e7cbef7"
    sha256 cellar: :any,                 arm64_monterey: "0f07c6120a1b4708ca11263ac5a8ca2ac90e188c4041a5e1d02a782454b66fc9"
    sha256 cellar: :any,                 sonoma:         "810d3321ebbcf6b704bb28b6b7ddb8c6ae77da9c54eed668dea1e515e8d76adf"
    sha256 cellar: :any,                 ventura:        "6a176743e46faa0343b73cbfeb2e51c0f02b8f755b30de79127cff7dfd9bb318"
    sha256 cellar: :any,                 monterey:       "f95a317b120efe2e8fb29104e8455407720402fc1d104200ace1c0769ba094c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03bb3699fbdfab35795654036fd73298007c425ae4e1a16ea8c93669f4aa4330"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "cffi"
  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-dateutil"
  depends_on "python-filelock"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "uvicorn"

  resource "aiodns" do
    url "https:files.pythonhosted.orgpackagesfa104de99e6e67703d8f6b10ea92a4d2a6c5b96a9c0708b75389a00203387925aiodns-3.1.1.tar.gz"
    sha256 "1073eac48185f7a4150cad7f96a5192d6911f12b4fb894de80a088508c9b3a99"
  end

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackagesaf41cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages18931f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258baiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
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

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages2db87333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "censys" do
    url "https:files.pythonhosted.orgpackages64e260e8e2922e64ba38de3948c1ab04cdca6698920bc98d13637f77a259ea08censys-2.2.11.tar.gz"
    sha256 "d4e161e3085800c0f9b6ff6cc035a7727ff525135cdde62ff01e32eb371c5773"
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

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages6551fbffab4071afa789e515421e5749146beff65b3d371ff30d861e85587306dnspython-2.5.0.tar.gz"
    sha256 "a0034815a59ba9ae888946be7ccca8f7c157b286f8455b379c692efb51022a15"
  end

  resource "fastapi" do
    url "https:files.pythonhosted.orgpackageseeb6beaa92d1fd977edcd77c91c9d08a63d57ceb248a671a8641e3c598a34ef1fastapi-0.109.0.tar.gz"
    sha256 "b978095b9ee01a5cf49b19f4bc1ac9b8ca83aa076e770ef8fd9af09a2b88d191"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages90b4206081fca69171b4dc1939e77b378a7b87021b0f43ce07439d49d8ac5c84importlib_metadata-7.0.1.tar.gz"
    sha256 "f238736bb06590ae52ac1fab06a3a9ef1d8dce2b7a35b5ab329371d6c8f5d2cc"
  end

  resource "importlib-resources" do
    url "https:files.pythonhosted.orgpackagesd406402fb5efbe634881341ff30220798c4c5e448ca57c068108c4582c692160importlib_resources-6.1.1.tar.gz"
    sha256 "3893a00122eafde6894c59914446a512f728a0c1a45f9bb9b63721b6bacf0b4a"
  end

  resource "limits" do
    url "https:files.pythonhosted.orgpackages9cedc4c3838e7697fa7906bbf3c7fa8fad3ec0a9667071c17f2f17d2f5e601calimits-3.7.0.tar.gz"
    sha256 "124c6a04d2f4b20990fb1de019eec9474d6c1346c70d8fd0561609b86998b64a"
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
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackagesaf96f4878091248450bbdebfbd01bf1d95821bd47eb38e756815a0431baa6b07netaddr-0.10.1.tar.gz"
    sha256 "f4da4222ca8c3f43c8e18a8263e5426c750a3a837fdfeccf74c68d0408eaa3bf"
  end

  resource "pycares" do
    url "https:files.pythonhosted.orgpackages1b8fdaf60bbc06f4a3cd1cfb0ab807057151287df6f5c78f2e0d298acc9193acpycares-4.4.0.tar.gz"
    sha256 "f47579d508f2f56eddd16ce72045782ad3b1b3b678098699e2b6a1b30733e1c2"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages7327a17cc261bb974e929aa3b3365577e43c1c71c3dcd8669250613a7135cb8fpydantic-2.6.1.tar.gz"
    sha256 "4fd5c182a2488dc63e6d32737ff19937888001e2a6d86e94b3f233104a5d1fa9"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages0d7264550ef171432f97d046118a9869ad774925c2f442589d5f6164b8288e85pydantic_core-2.16.2.tar.gz"
    sha256 "0ba503850d8b8dcc18391f10de896ae51d37fe5fe43dbfb6a35c5c5cad271a06"
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
    url "https:files.pythonhosted.orgpackages2b69ba1b5f52f96cde4f2d8eca74a0aa2c11a66b2fe58d0fb63b2e46edce6ed3requests-file-2.0.0.tar.gz"
    sha256 "20c5931629c558fda566cacc10cfe2cd502433e628f568c34c80d96a0cc95972"
  end

  resource "retrying" do
    url "https:files.pythonhosted.orgpackagesce7015ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9ddretrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "shodan" do
    url "https:files.pythonhosted.orgpackagesc506c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "slowapi" do
    url "https:files.pythonhosted.orgpackagesf5973e85a6097fb4986691b52dbef7ca7576f49740fc880160602f91a1062c69slowapi-0.1.8.tar.gz"
    sha256 "8cc268f5a7e3624efa3f7bd2859b895f9f2376c4ed4e0378dd2f7f3343ca608e"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackages5e8a80e0343c8051e522752eaae54e96c814946ac97ae0c08b441620e3a22755starlette-0.35.1.tar.gz"
    sha256 "3e2639dac3520e4f58734ed22553f950d3f3cb1001cd2eaac4d57e8cdc5f66bc"
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
    url "https:files.pythonhosted.orgpackages6e546f2bdac7117e89a47de4511c9f01732a283457ab1bf856e1e51aa861619eujson-5.9.0.tar.gz"
    sha256 "89cc92e73d5501b8a7f48575eeb14ad27156ad092c2e9fc7e3cf949f07e75532"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "uvloop" do
    url "https:files.pythonhosted.orgpackages9c16728cc5dde368e6eddb299c5aec4d10eaf25335a5af04e8c0abd68e2e9d32uvloop-0.19.0.tar.gz"
    sha256 "0246f4fd1bf2bf702e06b0d45ee91677ee5c31242f39aab4ea6fe0c51aedd0fd"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages85dc549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273websockets-10.4.tar.gz"
    sha256 "eef610b23933c54d5d921c92578ae5f89813438fded840c2e9809d378dc765d3"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xlsxwriter" do
    url "https:files.pythonhosted.orgpackages2ba3dd02e3559b2c785d2357c3752cc191d750a280ff3cb02fa7c2a8f87523c3XlsxWriter-3.1.9.tar.gz"
    sha256 "de810bf328c6a4550f4ffd6b0b34972aeb7ffcf40f3d285a0413734f9b63a929"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec"bintheHarvester" => "theharvester"

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[uvicorn].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    output = shell_output("#{bin}theharvester -d brew.sh --limit 1 --source urlscan 2>&1")
    assert_match "docs.brew.sh", output
    assert_match "formulae.brew.sh", output
  end
end