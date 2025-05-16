class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https:gettaurus.org"
  url "https:files.pythonhosted.orgpackages896879ef0e906c3b97405e98facacf49b71d445334480dec0ef99a9d54901837bzt-1.16.42.tar.gz"
  sha256 "b7458646f20ee46f0195622bbdadffc2f791df7b39c68a6fdb04febb2ba39a19"
  license "Apache-2.0"
  head "https:github.comBlazemetertaurus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9067847d79ec0f6077e60b5d4e663fc4536d5ff00d82103ccb49b3e01524d0c"
    sha256 cellar: :any,                 arm64_sonoma:  "e195b17db08ebe5883027a4dd597ad70e47e381838eb3a000997939f73af635d"
    sha256 cellar: :any,                 arm64_ventura: "d9ded46afdacec1f5caf288f45663fcd7e4455f7f7c0ec502a269189538f2bb9"
    sha256 cellar: :any,                 sonoma:        "6e99a620103918529c737c403e4c1fbb71a804b3a6c45f4333e5a52f0c5c4584"
    sha256 cellar: :any,                 ventura:       "496953ee3f6b86b5e37153b6f9af8701fdefc85cb45dac544184cd7481c26d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdc512e6d32bc0a059e7be4b6bf7b85692b51f35cce349dedd16fbf66a8ba1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf3af0d0459a2927e972fd27340f396b36f8228fe901d279d51fa972fadce9c"
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
    url "https:files.pythonhosted.orgpackages63e7fa1a8c00e2c54b05dc8cb5d1439f627f7c267874e3f7bb047146116020f9aiohttp-3.11.18.tar.gz"
    sha256 "ae856e1138612b7e412db63b7708735cff4d38d0399f6a5435d3dac2669f558a"
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
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
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
    url "https:files.pythonhosted.orgpackagescff7db37a613aec5abcd51c8000a386a701ac32e94659aa03fa69c3e5c19b149cython-3.1.0.tar.gz"
    sha256 "1097dd60d43ad0fff614a57524bfd531b35c13a907d13bee2cc2ec152e6bf4a1"
  end

  resource "dill" do
    url "https:files.pythonhosted.orgpackages1280630b4b88364e9a8c8c5797f4602d0f76ef820909ee32f0bacb9f90654042dill-0.4.0.tar.gz"
    sha256 "0633f1d2df477324f53a895b02c901fb961bdbf65a17122586ea7019292cbcf0"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackageseef4d744cba2da59b5c1d88823cf9e8a6c74e4659e2b27604ed973be2a0bf5abfrozenlist-1.6.0.tar.gz"
    sha256 "b99655c32c1c8e06d111e7f41c06c29a5318cb1835df23a45518e02a47c63b68"
  end

  resource "fuzzyset2" do
    url "https:files.pythonhosted.orgpackages493344f03c3642922580229651ef07a6ade59352710ef56db99887eb21bc2ecffuzzyset2-0.2.5.tar.gz"
    sha256 "150bc83ef37228ee1d6fc20e4c11dea0ecc64c0acbf251cfd973316738957a16"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hdrpy" do
    url "https:files.pythonhosted.orgpackages478c159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfdhdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages22d1bbc4d251187a43f69844f7fd8941426549bbe4723e8ff0a7441796b0789fhumanize-4.12.3.tar.gz"
    sha256 "8430be3a615106fdfceb0b2c1b41c4c98c6b0fc5cc59663a5539b111dd325fb0"
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
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
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
    url "https:files.pythonhosted.orgpackagesda2ce367dfb4c6538614a0c9453e510d75d66099edf1c4e69da1b5ce691a1931multidict-6.4.3.tar.gz"
    sha256 "3ada0b058c9f213c5f95ba301f922d402ac234f1111a7d8fd70f1b99f3c281ec"
  end

  resource "multiprocess" do
    url "https:files.pythonhosted.orgpackages72fd2ae3826f5be24c6ed87266bc4e59c46ea5b059a103f3d7e7eb76a52aeecbmultiprocess-0.70.18.tar.gz"
    sha256 "f9597128e6b3e67b23956da07cf3d2e5cba79e2f4e0fba8d7903636663ec6d0d"
  end

  resource "progressbar33" do
    url "https:files.pythonhosted.orgpackages71fc7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6bprogressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
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
    url "https:files.pythonhosted.orgpackages3c9d8492fbde3d4cb0e052de8a91a09754f222b5093f0342ef2dac92d60c751fpython_engineio-4.12.1.tar.gz"
    sha256 "9f2b5a645c416208a9c727254316d487252493de52bee0ff70dc29ca9210397e"
  end

  resource "python-socketio" do
    url "https:files.pythonhosted.orgpackages211a396d50ccf06ee539fa758ce5623b59a9cb27637fc4b2dc07ed08bf495e77python_socketio-5.13.0.tar.gz"
    sha256 "ac4e19a0302ae812e23b712ec8b6427ca0521f7c582d6abb096e36e24a263029"
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
    url "https:files.pythonhosted.orgpackages9e8bdc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
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

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesdd199e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  resource "urwid" do
    url "https:files.pythonhosted.orgpackages9821ad23c9e961b2d36d57c63686a6f86768dd945d406323fb58c84f09478530urwid-2.6.16.tar.gz"
    sha256 "93ad239939e44c385e64aa00027878b9e5c486d59e855ec8ab5b1e1adcdb32a2"
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
    url "https:files.pythonhosted.orgpackages6251c0edba5219027f6eab262e139f73e2417b0f4efffa23bf562f6e18f76ca5yarl-1.20.0.tar.gz"
    sha256 "686d51e51ee5dfe62dec86e4866ee0e9ed66df700d55c828a615640adc885307"
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