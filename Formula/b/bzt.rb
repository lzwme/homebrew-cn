class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https:gettaurus.org"
  url "https:files.pythonhosted.orgpackages230d2b00c42ced1b2497cbd29eca47cc457b277d119c1e93d76c8b29fec38bbfbzt-1.16.39.tar.gz"
  sha256 "e728997aed9bec3f4f26d82a7dc546e5e4f6ca8eae681e6c499c81681a3e07ce"
  license "Apache-2.0"
  head "https:github.comBlazemetertaurus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc3b8b45f56ac87ed74c5741327b79546da40929023fb58ef0821b696bed3a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "a03043a64ab88419c8f642f77ac106ffee4df36838f3face5b8edb1b62503d23"
    sha256 cellar: :any,                 arm64_ventura: "4b4568516b0d23424961adb4593f931993a743be59ba200e94d7fce7a34afaee"
    sha256 cellar: :any,                 sonoma:        "6cd30530953778cf784eb7836a183fc63e3fb4f6e542e1e75e0b3ab055d1393a"
    sha256 cellar: :any,                 ventura:       "e6a60e8af8eedc3f245d52aace8bc43cefb0bb51084fc25eacdd4c7d04fb881d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad991a2651d4808505ba6806409a67aaf0f2230b5dcd34a4a952d156430a04c"
  end

  depends_on "cmake" => :build
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
    url "https:files.pythonhosted.orgpackages0807508f9ebba367fc3370162e53a3cfd12f5652ad79f0e0bfdf9f9847c6f159aiohappyeyeballs-2.4.6.tar.gz"
    sha256 "9b05052f9042985d32ecbe4b59a77ae19c006a78f1344d7fdad69d28ded3d0b0"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages374b952d49c73084fb790cb5c6ead50848c8e96b4980ad806cf4d2ad341eaa03aiohttp-3.11.12.tar.gz"
    sha256 "7603ca26d75b1b86160ce1bbe2787a0b706e592af5b2504e12caa88a217767b0"
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
    url "https:files.pythonhosted.orgpackages497cfdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17fattrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
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
    url "https:files.pythonhosted.orgpackagesd191d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081ccssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
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
    url "https:files.pythonhosted.orgpackages38ff9f38de04e15bd53f5b64d38e6b9f21357d7b3edee7e398d05aaf407dbdfehumanize-4.12.0.tar.gz"
    sha256 "87ff7b43591370b12a1d103c9405849d911d4b039ed22d80b718b62c76eec8a3"
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
    url "https:files.pythonhosted.orgpackageseff6c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
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
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
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
    url "https:files.pythonhosted.orgpackages20c82a13f78d82211490855b2fb303b6721348d0787fdd9a12ac46d99d3acde1propcache-0.2.1.tar.gz"
    sha256 "3f77ce728b19cb537714499928fe800c3dda29e8d9428778fc7c186da4c09a64"
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
    url "https:files.pythonhosted.orgpackages5f57df1c9157c8d5a05117e455d66fd7cf6dbc46974f832b1058ed4856785d8apytz-2025.1.tar.gz"
    sha256 "c2db42be2a2518b28e65f9207c4d05e6ff547d1efa4086469ef855e4ab70178e"
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
    url "https:files.pythonhosted.orgpackagesc9dfc300ead8c2962f54ad87872e6372a6836f0181a7f20b433c987bd106bfcerapidfuzz-3.12.1.tar.gz"
    sha256 "6a98bbca18b4a37adddf2d8201856441c26e9c981d8895491b5bc857b5f780eb"
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
    url "https:files.pythonhosted.orgpackagesb79d4b94a8e6d2b51b599516a5cb88e5bc99b4d8d4583e468057eaa29d5f0918yarl-1.18.3.tar.gz"
    sha256 "ac1801c45cbf77b6c99242eeff4fffb5e4e73a800b5c4ad4fc0be5def634d2e1"
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