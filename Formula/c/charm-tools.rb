class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https:github.comjujucharm-tools"
  url "https:files.pythonhosted.orgpackagesa421cd7198ae853a335b6a27078a024104ad5ee34e17ad5f0517867e85c27cd3charm-tools-3.0.7.tar.gz"
  sha256 "31cbee3edc9d26678c41761f80a54b58bca59524588c480c1682ad0bb475935e"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13eac8c5ca598352ad4e8b7bde20521ddea8196a62d1183c8d35ee71cbba5ea5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03a1248c9dbfb2537e15770a758c21dc8d115295ca70218843c7eba723865bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceafd902cb1523a7ec7e85282edfe9dda907e61f0e3e24b1cb570f8d4331df4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "12afb595c383543bbb805918ed713926e93a8416bada1d25e15b00fad48190e5"
    sha256 cellar: :any_skip_relocation, ventura:        "68a83c3a10314ea90038e91020c194a220d3ff9ebd196dfc6b568b0685d13620"
    sha256 cellar: :any_skip_relocation, monterey:       "691ce11a635a6a729fd33f5e02f453590ac24892e5195f7d912972fa5892c629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "307e005d33b2506485b986b8647de4b7937ed76f31f014efa6e9caa3b11b6670"
  end

  # `pkg-config` and `rust` are for `rpds-py`
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "charm"
  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  on_linux do
    depends_on "gmp"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "blessings" do
    url "https:files.pythonhosted.orgpackages5cf89f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "cheetah3" do
    url "https:files.pythonhosted.orgpackages2333ace0250068afca106c1df34348ab0728e575dc9c61928d216de3e381c460Cheetah3-3.2.6.post1.tar.gz"
    sha256 "58b5d84e5fbff6cf8e117414b3ea49ef51654c02ee887d155113c5b91d761967"
  end

  resource "colander" do
    url "https:files.pythonhosted.orgpackagesfa3c592bbb25f6199234167d713c220044473e2e57906d7ad7a34e13b7dc1144colander-1.8.3.tar.gz"
    sha256 "259592a0d6a89cbe63c0c5771f9c0c2522387415af8d715f599583eac659f7d4"
  end

  resource "dict2colander" do
    url "https:files.pythonhosted.orgpackagesaa7e5ed2ba3dc2f06457b76d4bc8c93559179472bf87e6982f9a9e5cea30e84edict2colander-0.2.tar.gz"
    sha256 "6f668d60896991dcd271465b755f00ffd6f87f81e0d4d054be62a16c086978c7"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages293463be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagesd571bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages3344ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages8bded0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfajaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages363dca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "jujubundlelib" do
    url "https:files.pythonhosted.orgpackages5757039c6b7e6a01df336f38549eec0836b61166f012528449e37a0ced4e9ddcjujubundlelib-0.5.7.tar.gz"
    sha256 "7e2b1a679faab13c4d56256e31e0cc616d55841abd32598951735bf395ca47e3"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages55fe282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages2d733557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "otherstuf" do
    url "https:files.pythonhosted.orgpackages4fb5fe92e1d92610449f001e04dd9bf7dc13b8e99e5ef8859d2da61a99fc8445otherstuf-1.1.0.tar.gz"
    sha256 "7722980c3b58845645da2acc838f49a1998c8a6bdbdbb1ba30bcde0b085c4f4c"
  end

  resource "parse" do
    url "https:files.pythonhosted.orgpackages29d9a874f3b01b618dae366de5d18c529d961dddf58eccca5c99ba691040325eparse-1.19.1.tar.gz"
    sha256 "cc3a47236ff05da377617ddefa867b7ba983819c664e1afe46249e5b469be464"
  end

  resource "path" do
    url "https:files.pythonhosted.orgpackages5beabf8061e92cd3a8aa0c064f3c24105f0f8505720de86872a9fdac93fd27f7path-16.7.1.tar.gz"
    sha256 "2b477f5887033f3cbea1cfd8553ee6a6a498eb2540a19f4aa082822aadcea30a"
  end

  resource "path-py" do
    url "https:files.pythonhosted.orgpackagesb6e381be70016d58ade0f516191fa80152daba5453d0b07ce648d9daae86a188path.py-12.5.0.tar.gz"
    sha256 "8d885e8b2497aed005703d94e0fd97943401f035e42a136810308bff034529a8"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackages321a6baf904503c3e943cae9605c9c88a43b964dea5b59785cf956091b341b08pathspec-0.10.3.tar.gz"
    sha256 "56200de4077d9d0791465aa9095a01d421861e405b5096955051deefd697d6f6"
  end

  # Requires pip < 23.0
  resource "pip" do
    url "https:files.pythonhosted.orgpackagesa350c4d2727b99052780aad92c7297465af5fe6eec2dbae490aa9763273ffdc1pip-22.3.1.tar.gz"
    sha256 "65fd48317359f3af8e593943e6ae1506b66325085ea64b706a998c6e83eeaf38"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesd3e3aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesbf90445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requirements-parser" do
    url "https:files.pythonhosted.orgpackagesc2f976106e710015f0f8da37bff8db378ced99ae2553cc4b1cffb0aef87dc4acrequirements-parser-0.5.0.tar.gz"
    sha256 "3336f3a3ae23e06d3f0f88595e4052396e3adf91688787f637e5d2ca1a904069"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages27fc73edf1269fab4ae08ada602f4bf17b0a0428b3bf10574c2ea7331d73f87druamel.yaml-0.17.33.tar.gz"
    sha256 "5c56aa0bff2afceaa93bffbfc78b450b7dc1e01d5edb80b3a570695286ae62b1"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "stuf" do
    url "https:files.pythonhosted.orgpackages7662171e06b6d2d3072ea333de19632c61a44f83199e20cbf4924d12827cf66astuf-0.9.16.tar.bz2"
    sha256 "e61d64a2180c19111e129d36bfae66a0cb9392e1045827d6495db4ac9cb549b0"
  end

  resource "translationstring" do
    url "https:files.pythonhosted.orgpackages143932325add93da9439775d7fe4b4887eb7986dbc1d5675b0431f4531f560e5translationstring-1.4.tar.gz"
    sha256 "bf947538d76e69ba12ab17283b10355a9ecfbc078e6123443f43f2107f6376f3"
  end

  resource "types-setuptools" do
    url "https:files.pythonhosted.orgpackages1f32ad55729b96c07993bbf83a0a734a3ee8402ea42268939aeae30c4f3600d0types-setuptools-68.2.0.0.tar.gz"
    sha256 "a4216f1e2ef29d089877b3af3ab2acf489eb869ccaf905125c69d2dc3932fd85"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8b00db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "vergit" do
    url "https:files.pythonhosted.orgpackagesd8dc2ef077a97a05633bbe7a46b9cb4b87fbf994a9aaa52b44a8f1086d20951fvergit-1.0.2.tar.gz"
    sha256 "ea82a4d6057d4891a4b16e0881bd756ceea2b66253edc05dd619450f88a5ff31"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackagesd350fa955bbda25c0f01297843be105f9d022f461423e69a6ab487ed6cabf75dvirtualenv-20.24.5.tar.gz"
    sha256 "e8361967f6da6fbdf1426483bfe9fca8287c242ac0bc30429905721cefbff752"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesa49978c4f3bd50619d772168bec6a0f34379b02c19c9cced0ed833ecd021fd0dwheel-0.41.2.tar.gz"
    sha256 "0c5ac5ff2afb79ac23ab82bab027a0be7b5dbcf2e54dc50efe4bf507de1f7985"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}charm-create", "brewtest"
    assert_predicate testpath"brewtestmetadata.yaml", :exist?

    assert_match version.to_s, shell_output("#{bin}charm-version")
  end
end