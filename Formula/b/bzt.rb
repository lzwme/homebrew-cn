class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https:gettaurus.org"
  url "https:files.pythonhosted.orgpackages92a60aba1c89418050fb8bd5e1217897ef533321e874bd4d87ed414a2355f218bzt-1.16.29.tar.gz"
  sha256 "b1666800901a70327c9788ae4b20c43fce90ca31aa182577a5bbee71d37d3d7c"
  license "Apache-2.0"
  head "https:github.comBlazemetertaurus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc1fc3d4dec6bbf2a7e7b6f7ec222566048eb5acce1c2ef3233b5b9d234546c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c40f3b641b5904997fcbc63149ac4df78f34a715678259482c1dcb6996d27bbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55be8a8a06f273da38d25205d581b02b76689c0e83f7f7043b0f2cfa22b919de"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a028bb78569ba20155e3a1d576f525758ce284c1e61a690223ac5f84e6c3547"
    sha256 cellar: :any_skip_relocation, ventura:        "5abb532856b1c0ebefbe45866120f7435baf4432942bc27c1ef40bc541e058e3"
    sha256 cellar: :any_skip_relocation, monterey:       "782ca12cb0ba2e346ad90b8ff3ee27ddc98b5379af3c3c9c837aa98ceb735cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a39c8d4c0018b8db2e5a3fd9c2194e2237d7b81e849fdcc6deffe80da5a1cf7b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libcython"
  depends_on "numpy"
  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python-psutil"
  depends_on "python-pytz"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "aiodogstatsd" do
    url "https:files.pythonhosted.orgpackages8dead2d79661f213f09df0e9f56d25dbae41501880822e5c85a0a6d6857baa55aiodogstatsd-0.16.0.post0.tar.gz"
    sha256 "f783c7d6d74edd160b34141ff5f069c9a935bb32636823e39e36f0d1dbe14931"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages18931f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258baiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
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

  resource "dill" do
    url "https:files.pythonhosted.orgpackages174dac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "fuzzyset2" do
    url "https:files.pythonhosted.orgpackagese4f48a14a8fdf98941995bc028bd8a3c6c79d1d4d9bf5839e234cb6aad56936bfuzzyset2-0.2.2.tar.gz"
    sha256 "71f08c69ece31e73631f402ee532f74115255290819747d25e55661b5029cfb5"
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
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "influxdb" do
    url "https:files.pythonhosted.orgpackages864fa9c524576677c1694b149e09d4fd6342e4a1d9a5f409e437168a14d6d150influxdb-5.3.1.tar.gz"
    sha256 "46f85e7b04ee4b3dee894672be6a295c94709003a7ddea8820deec2ac4d8b27a"
  end

  resource "molotov" do
    url "https:files.pythonhosted.orgpackages54225820c7cad221514a04d9cdada884476e35c5972d7b84f88755094beab4fcmolotov-2.6.tar.gz"
    sha256 "0f52d260b4566709882a12710eff9b5863604f88c9bc03749cab4f9de462771a"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagesc2d55662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
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
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-engineio" do
    url "https:files.pythonhosted.orgpackagesbe1b13caab8337dc0cec96c65226a0fbaa2d1c6ec4ad0fb4faf02b1f2fdc150apython-engineio-4.9.0.tar.gz"
    sha256 "e87459c15638e567711fd156e6f9c4a402668871bed79523f0ecfec744729ec7"
  end

  resource "python-socketio" do
    url "https:files.pythonhosted.orgpackages89d9ceffa05f1cd72717c1677707debcb04654ad99844d87375ed14301536f27python-socketio-5.11.1.tar.gz"
    sha256 "bbcbd758ed8c183775cb2853ba001361e2fa018babf5cbe11a5b77e91c2ec2a2"
  end

  resource "pyvirtualdisplay" do
    url "https:files.pythonhosted.orgpackages869f23e5a82987c26d225139948a224a93318d7a7c8b166d4dbe4de7426dc4e4PyVirtualDisplay-3.0.tar.gz"
    sha256 "09755bc3ceb6eb725fb07eca5425f43f2358d3bf08e00d2a9b792a1aedd16159"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagesd4f4039e35e99c967100d73616ec08d4c02325f67e0d5c32a6d5a49a7f620942rapidfuzz-3.6.1.tar.gz"
    sha256 "35660bee3ce1204872574fa041c7ad7ec5175b3053a4cb6e181463fc07013de7"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "simple-websocket" do
    url "https:files.pythonhosted.orgpackagesd3823cf87d317911864a2f2a8daf1779fc7f82d5d55e6a8aaa0315f8209047a7simple-websocket-1.0.0.tar.gz"
    sha256 "17d2c72f4a2bd85174a97e3e4c88b01c40c3f81b7b648b0cc3ce1305968928c8"
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
    url "https:files.pythonhosted.orgpackages20072a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb0b4bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97bwheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
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
    # Enable finding cython, which is keg-only
    site_packages = Language::Python.site_packages("python3.12")
    (libexecsite_packages"homebrew-libcython.pth").write Formula["libcython"].opt_libexecsite_packages

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin"bzt -h")

    scenario = "execution.scenario.requests.0=https:gettaurus.org"
    output = shell_output(bin"bzt -o execution.executor=locust -o execution.iterations=1 -o #{scenario}")
    assert_match(INFO: Done performing with code: 0, output)
  end
end