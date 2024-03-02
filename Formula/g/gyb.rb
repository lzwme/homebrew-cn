class Gyb < Formula
  include Language::Python::Virtualenv

  desc "CLI for backing up and restoring Gmail messages"
  homepage "https:github.comGAM-teamgot-your-back"
  url "https:github.comGAM-teamgot-your-backarchiverefstagsv1.80.tar.gz"
  sha256 "171aa8d50d833f1d878337150a0cc99d9bfd26b9b922da244de94775a4ec251b"
  license "Apache-2.0"
  head "https:github.comGAM-teamgot-your-back.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dff4b1401d910ff0c5e216793b0844816e6b5a8945121ce802d1364599d6718"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cff871be5e5cb05250945cc1713a7951561270c400c413b6e69b706d4e439b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cd5dc876b1ff24b3867ac9161798853f0593afc117af10085c719628f22efa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "424fd98779ad110758ad61468770821c2063d222ebc17e074ac8adf7ab3564c3"
    sha256 cellar: :any_skip_relocation, ventura:        "c13a0abce8772cd396b81667049583a1d413b8970a58d75e93226d6cdba11a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb11df7f0478abb642c23ca9bf6753f2171841c4feee02f70b694e4f2e7063e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "004b4223d8530cfc8b38448d748de2b6a3547191c9f4308f4d7cbfd940f51908"
  end

  depends_on "python-certifi" => :build
  depends_on "python-cryptography" => :build
  depends_on "python@3.12" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https:files.pythonhosted.orgpackagesdea87145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages10211b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages2ce456b14d35057a23cab9067dd8fb841407d05d32b5d6c7a3c66c1360e8a7c0google-api-core-2.15.0.tar.gz"
    sha256 "abc978a72658f14a2df1e5e12532effe40f94f868f6e23d95133bd6abcca35ca"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages475f2cb762b9996a4c3644a1efe602043ca178f3b63cce051bb83b729a04beadgoogle-api-python-client-2.114.0.tar.gz"
    sha256 "e041bbbf60e682261281e9d64b4660035f04db1cccba19d1d68eebc24d1465ed"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages9aa796f6b41c736ac080844a96d34896019127427e66f59d6b03e001d243c6c6google-auth-2.26.2.tar.gz"
    sha256 "97327dbbf58cccb58fc5a1712bba403ae76668e64814eb30f7316f7e27126b81"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackages44777433818d44cadd1964473b1d9ab5ecea36e6f951cf2b5188e08f7ebd5dabgoogle-auth-oauthlib-1.2.0.tar.gz"
    sha256 "292d2d3783349f2b0734a0a0207b1e1e322ac193c2c09d8f7c613fb7cc501ea8"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages4a5feb12d721b45d20a977289d674e179995a0ddab1684d2c61b29a63d43a5f1googleapis-common-protos-1.62.0.tar.gz"
    sha256 "83f0ece9f94e5672cced82f592d2a5edf527a96ed1794f0bab36d5735c996277"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "macholib" do
    url "https:files.pythonhosted.orgpackages95eeaf1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesdba505ea470f4e793c9408bc975ce1c6957447e3134ce7f7a58c13be8b2c216fprotobuf-4.25.2.tar.gz"
    sha256 "fe599e175cb347efc8ee524bcd4b902d11f7262c0e569ececcb89995c15f0a5e"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagescedc996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages3be47dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070fpyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pyinstaller" do
    url "https:files.pythonhosted.orgpackages835c752340e73c195e21112eaec094d2d176705e4c18dc42a8357b68bb0dd693pyinstaller-6.4.0.tar.gz"
    sha256 "1bf608ed947b58614711275a7ff169289b32560dc97ec748ebd5fa8bdec80649"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https:files.pythonhosted.orgpackagesc4d0276175694985ae97497f176591a724c226257ad93acf1901896a218aed76pyinstaller-hooks-contrib-2024.1.tar.gz"
    sha256 "51a51ea9e1ae6bd5ffa7ec45eba7579624bf4f2472ff56dba0edc186f6ed46a6"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages37fe65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44bpyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages9552531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49frequests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackagesd25a4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000ebauritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    # change user config location from default of executable own path
    inreplace "gyb.py", "default=getProgPath()",
                        "default='#{pkgetc}'"
    venv = virtualenv_create(buildpath, "python3.12")
    venv.pip_install resources

    system "binpyinstaller", "gyb.spec"
    bin.install "distgyb"
  end

  def post_install
    pkgetc.mkpath
  end

  def caveats
    <<~EOS
      Default config_folder: #{pkgetc}
    EOS
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}gyb --version 2>&1")
    # Below throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdatedtoo newetc.
    assert_match "ERROR: --email is required.", shell_output("#{bin}gyb", 1)
  end
end