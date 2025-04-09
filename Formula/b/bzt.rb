class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https:gettaurus.org"
  url "https:files.pythonhosted.orgpackages230d2b00c42ced1b2497cbd29eca47cc457b277d119c1e93d76c8b29fec38bbfbzt-1.16.39.tar.gz"
  sha256 "e728997aed9bec3f4f26d82a7dc546e5e4f6ca8eae681e6c499c81681a3e07ce"
  license "Apache-2.0"
  head "https:github.comBlazemetertaurus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "14e53da6e3f931e9e37315ce785e2c5028edcfa481bada45af7cd1ef7672009e"
    sha256 cellar: :any,                 arm64_sonoma:  "b02c2754ee2feecbbc53c23eca28c7fff56a06191be907ad7b673616fc1f568e"
    sha256 cellar: :any,                 arm64_ventura: "58de6bf4118f25335b035152666fff9cbed8fe2639f4631136b73f246a9f099c"
    sha256 cellar: :any,                 sonoma:        "f74750cd3a53056e52578ccfba855f0b536258f7e31760e0b1a4d759066fc928"
    sha256 cellar: :any,                 ventura:       "f00f7dddca38fa98e2ffd42c1331dfbcbcfb4656608b64aad14dc34f76596e35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9317716560fb3397cd2003b18d841e72e8395ee59a9b56432a220641f1dbb95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b22449edc64552c731be9036c28066f25730bdda9d363d151786d01785a2c12a"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  # setuptools resource must be manually bumped to a current version until it is no longer pinned upstream:
  # https:github.comBlazemetertaurusblob7e511f0869f3170779aad3ae54fa177493335abbrequirements.txt#L21-L23
  resource "aiodogstatsd" do
    url "https:files.pythonhosted.orgpackages8dead2d79661f213f09df0e9f56d25dbae41501880822e5c85a0a6d6857baa55aiodogstatsd-0.16.0.post0.tar.gz"
    sha256 "f783c7d6d74edd160b34141ff5f069c9a935bb32636823e39e36f0d1dbe14931"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesf1d91c4721d143e14af753f2bf5e3b681883e1f24b592c0482df6fa6e33597faaiohttp-3.11.16.tar.gz"
    sha256 "16f8a2c9538c14a557b4d309ed4d0a7c60f0253e8ed7b6c9a2859a7582f8b1b8"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "astunparse" do
    url "https:files.pythonhosted.orgpackagesf3af4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "bidict" do
    url "https:files.pythonhosted.orgpackages9a6e026678aa5a830e07cd9498a05d3e7e650a4f56a42f267a53d22bcda1bdc9bidict-0.23.1.tar.gz"
    sha256 "03069d763bc387bbd20e7d49914e75fc4132a41937fa3405417e1a5a2d006d71"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesd37a359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "cssselect" do
    url "https:files.pythonhosted.orgpackages720ac3ea9573b1dc2e151abfe88c7fe0c26d1892fe6ed02d0cdb30f0d57029d5cssselect-1.3.0.tar.gz"
    sha256 "57f8a99424cfab289a1b6a816a43075a4b00948c86b4dcf3ef4ee7e15f7ab0c7"
  end

  resource "cython" do
    url "https:files.pythonhosted.orgpackages5a25886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "dill" do
    url "https:files.pythonhosted.orgpackages704386fe3f9e130c4137b0f1b50784dd70a5087b911fe07fa81e53e0c4c47feadill-0.3.9.tar.gz"
    sha256 "81aa267dddf68cbfe8029c42ca9ec6a4ab3b22371d1c450abc54422577b4512c"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8fed0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "fuzzyset2" do
    url "https:files.pythonhosted.orgpackages493344f03c3642922580229651ef07a6ade59352710ef56db99887eb21bc2ecffuzzyset2-0.2.5.tar.gz"
    sha256 "150bc83ef37228ee1d6fc20e4c11dea0ecc64c0acbf251cfd973316738957a16"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "hdrpy" do
    url "https:files.pythonhosted.orgpackages478c159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfdhdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackagese084ae8e64a6ffe3291105e9688f4e28fa65eba7924e0fe6053d85ca00556385humanize-4.12.2.tar.gz"
    sha256 "ce0715740e9caacc982bb89098182cf8ded3552693a433311c6a4ce6f4e12a2c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "influxdb" do
    url "https:files.pythonhosted.orgpackages12d44c1bd3a8f85403fad3137a7e44f7882b0366586b7c27d12713493516f1c7influxdb-5.3.2.tar.gz"
    sha256 "58c647f6043712dd86e9aee12eb4ccfbbb5415467bc9910a48aa8c74c1108970"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages8061d3dc048cd6c7be6fe45b80cedcbdd4326ba4d550375f266d9f4246d0f4bclxml-5.3.2.tar.gz"
    sha256 "773947d0ed809ddad824b7b14467e1a481b8976e87278ac4a730c2f7c7fcddc1"
  end

  resource "molotov" do
    url "https:files.pythonhosted.orgpackages54225820c7cad221514a04d9cdada884476e35c5972d7b84f88755094beab4fcmolotov-2.6.tar.gz"
    sha256 "0f52d260b4566709882a12710eff9b5863604f88c9bc03749cab4f9de462771a"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagescbd07555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4fmsgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesfa2d6e0d6771cadd5ad14d13193cc8326dc0b341cc1659c306cbfce7a5058fffmultidict-6.3.2.tar.gz"
    sha256 "c1035eea471f759fa853dd6e76aaa1e389f93b3e1403093fa0fd3ab4db490678"
  end

  resource "multiprocess" do
    url "https:files.pythonhosted.orgpackagese9341acca6e18697017ad5c8b45279b59305d660ecf2fbed13e5f406f69890e4multiprocess-0.70.17.tar.gz"
    sha256 "4ae2f11a3416809ebc9a48abfc8b14ecce0652a0944731a1493a3c1ba44ff57a"
  end

  resource "progressbar33" do
    url "https:files.pythonhosted.orgpackages71fc7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6bprogressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesa1e1bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackages07c8fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-engineio" do
    url "https:files.pythonhosted.orgpackages52e0a9e0fe427ce7f1b7dbf9531fa00ffe4b557c4a7bc8e71891c115af123170python_engineio-4.11.2.tar.gz"
    sha256 "145bb0daceb904b4bb2d3eb2d93f7dbb7bb87a6a0c4f20a94cc8654dec977129"
  end

  resource "python-socketio" do
    url "https:files.pythonhosted.orgpackagesced040ed38076e8aee94785d546d3e3a1cae393da5806a8530be877187e2875fpython_socketio-5.12.1.tar.gz"
    sha256 "0299ff1f470b676c09c1bfab1dead25405077d227b2c13cf217a34dadc68ba9c"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackagesf8bfabbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aacpytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyvirtualdisplay" do
    url "https:files.pythonhosted.orgpackages869f23e5a82987c26d225139948a224a93318d7a7c8b166d4dbe4de7426dc4e4PyVirtualDisplay-3.0.tar.gz"
    sha256 "09755bc3ceb6eb725fb07eca5425f43f2358d3bf08e00d2a9b792a1aedd16159"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagesedf66895abc3a3d056b9698da3199b04c0e56226d530ae44a470edabf8b664f0rapidfuzz-3.13.0.tar.gz"
    sha256 "d2eaf3839e52cbcc0accbe9817a67b4b0fcf70aaeb229cfddc1c28061f9ce5d8"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages92ec089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "simple-websocket" do
    url "https:files.pythonhosted.orgpackagesb0d4bfa032f961103eba93de583b161f0e6a5b63cebb8f2c7d0c6e6efe1e3d2esimple_websocket-1.1.0.tar.gz"
    sha256 "7939234e7aa067c534abdab3a9ed933ec9ce4691b0713c78acb195560aa52ae4"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "terminaltables" do
    url "https:files.pythonhosted.orgpackagesf5fc0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesdd199e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  resource "urwid" do
    url "https:files.pythonhosted.orgpackages943fe3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540curwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackages8a982d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25cwheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagesfc4d8a8f57caccce49573e567744926f88c6ab3ca0b47a257806d1cf88584c5fyarl-1.19.0.tar.gz"
    sha256 "01e02bb80ae0dbed44273c304095295106e1d9470460e773268a27d11e594892"
  end

  def install
    venv = virtualenv_install_with_resources without: "terminaltables"

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when released: https:github.commatthewdeanmartinterminaltablespull1
    resource("terminaltables").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match version.to_s, shell_output(bin"bzt -h")

    scenario = "execution.scenario.requests.0=https:gettaurus.org"
    output = shell_output(bin"bzt -o execution.executor=locust -o execution.iterations=1 -o #{scenario}")
    assert_match "INFO: Done performing with code: 0", output
  end
end