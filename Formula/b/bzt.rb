class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https:gettaurus.org"
  url "https:files.pythonhosted.orgpackagesd9dfc7e1202295f3007fbb7af5a40c8a9d383ed14b9cd46ede29ebcdad039b2ebzt-1.16.32.tar.gz"
  sha256 "a8009c625e5b9dfb4e31cfac03c3d41f1aa84ad9314d019e1e9000da687781bc"
  license "Apache-2.0"
  head "https:github.comBlazemetertaurus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "283df223d69291b3220359f819e180a8dbc7117ef8878418742a97ada18da4a2"
    sha256 cellar: :any,                 arm64_ventura:  "437df44b83589d8905f3762d59f31d68fd123c827c3799f8200d6b8d0029af36"
    sha256 cellar: :any,                 arm64_monterey: "6c37b50383e77d5a83db7a7e2d7c5469cd1b7ecd407591ad1fdbfff04203d625"
    sha256 cellar: :any,                 sonoma:         "bc726d10fee1706a31b9099bf929fd7c683534779624d129035e2d8a2be50842"
    sha256 cellar: :any,                 ventura:        "143a3044d85a6e8817c713eb799b9259078528dd51defae287c1691d58824011"
    sha256 cellar: :any,                 monterey:       "4c781e1ec277a45e8cec9fc5470c425dd1774b31df1be106872a066209ef50a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "672799a6206ab68356d73433c8f0d4c8f3aea538eedfc208df4ba93beb81a34b"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "aiodogstatsd" do
    url "https:files.pythonhosted.orgpackages8dead2d79661f213f09df0e9f56d25dbae41501880822e5c85a0a6d6857baa55aiodogstatsd-0.16.0.post0.tar.gz"
    sha256 "f783c7d6d74edd160b34141ff5f069c9a935bb32636823e39e36f0d1dbe14931"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages04a4e3679773ea7eb5b37a2c998e25b017cc5349edf6ba2739d1f32855cfb11baiohttp-3.9.5.tar.gz"
    sha256 "edea7d15772ceeb29db4aff55e482d4bcfb6ae160ce144f2682de02f6d693551"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "astunparse" do
    url "https:files.pythonhosted.orgpackagesf3af4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "bidict" do
    url "https:files.pythonhosted.orgpackages9a6e026678aa5a830e07cd9498a05d3e7e650a4f56a42f267a53d22bcda1bdc9bidict-0.23.1.tar.gz"
    sha256 "03069d763bc387bbd20e7d49914e75fc4132a41937fa3405417e1a5a2d006d71"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesdb382992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "cssselect" do
    url "https:files.pythonhosted.orgpackagesd191d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081ccssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "cython" do
    url "https:files.pythonhosted.orgpackagesd5f72fdd9205a2eedee7d9b0abbf15944a1151eb943001dbdc5233b1d1cfc34eCython-3.0.10.tar.gz"
    sha256 "dcc96739331fb854dcf503f94607576cfe8488066c61ca50dfd55836f132de99"
  end

  resource "dill" do
    url "https:files.pythonhosted.orgpackages174dac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "fuzzyset2" do
    url "https:files.pythonhosted.orgpackagesb4d2f2be47222e34b12b1750425cd490c911559b0048cc8915827ecb94c27aadfuzzyset2-0.2.4.tar.gz"
    sha256 "97de8218b20ad00e07aae0156943afa0da91655a43ee8ae5caa79bf163c79efe"
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
    url "https:files.pythonhosted.orgpackages76217a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75chumanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "influxdb" do
    url "https:files.pythonhosted.orgpackages12d44c1bd3a8f85403fad3137a7e44f7882b0366586b7c27d12713493516f1c7influxdb-5.3.2.tar.gz"
    sha256 "58c647f6043712dd86e9aee12eb4ccfbbb5415467bc9910a48aa8c74c1108970"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "molotov" do
    url "https:files.pythonhosted.orgpackages54225820c7cad221514a04d9cdada884476e35c5972d7b84f88755094beab4fcmolotov-2.6.tar.gz"
    sha256 "0f52d260b4566709882a12710eff9b5863604f88c9bc03749cab4f9de462771a"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackages084c17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "multiprocess" do
    url "https:files.pythonhosted.orgpackagesb5ae04f39c5d0d0def03247c2893d6f2b83c136bf3320a2154d7b8858f2ba72dmultiprocess-0.70.16.tar.gz"
    sha256 "161af703d4652a0e1410be6abccecde4a7ddffd19341be0a7011b94aeb171ac1"
  end

  resource "progressbar33" do
    url "https:files.pythonhosted.orgpackages71fc7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6bprogressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages476d0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879fprompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages18c78c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-engineio" do
    url "https:files.pythonhosted.orgpackages500194faf505820f1fb94133a456dad87a76df589f6999de563229a342e412fapython_engineio-4.9.1.tar.gz"
    sha256 "7631cf5563086076611e494c643b3fa93dd3a854634b5488be0bba0ef9b99709"
  end

  resource "python-socketio" do
    url "https:files.pythonhosted.orgpackages1e74b1e8787cea757e1f533a7878e94f929679ef7e07a2aaf44de6b71065b1f2python_socketio-5.11.3.tar.gz"
    sha256 "194af8cdbb7b0768c2e807ba76c7abc288eb5bb85559b7cddee51a6bc7a65737"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyvirtualdisplay" do
    url "https:files.pythonhosted.orgpackages869f23e5a82987c26d225139948a224a93318d7a7c8b166d4dbe4de7426dc4e4PyVirtualDisplay-3.0.tar.gz"
    sha256 "09755bc3ceb6eb725fb07eca5425f43f2358d3bf08e00d2a9b792a1aedd16159"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackages50b922b4848fc842b17c4446433d5d472007c9799dbe8dd90bc0f6d60767c29drapidfuzz-3.9.3.tar.gz"
    sha256 "b398ea66e8ed50451bce5997c430197d5e4b06ac4aa74602717f792d8d8d06e2"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages1c1c8a56622f2fc9ebb0df743373ef1a96c8e20410350d12f44ef03c588318c3setuptools-70.1.0.tar.gz"
    sha256 "01a1e793faa5bd89abc851fa15d0a0db26f160890c7102cd8dce643e886b47f5"
  end

  resource "simple-websocket" do
    url "https:files.pythonhosted.orgpackagesd3823cf87d317911864a2f2a8daf1779fc7f82d5d55e6a8aaa0315f8209047a7simple-websocket-1.0.0.tar.gz"
    sha256 "17d2c72f4a2bd85174a97e3e4c88b01c40c3f81b7b648b0cc3ce1305968928c8"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
    url "https:files.pythonhosted.orgpackagesb8d6ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
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
    assert_match(INFO: Done performing with code: 0, output)
  end
end