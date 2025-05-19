class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https:github.comjujucharm-tools"
  url "https:files.pythonhosted.orgpackagesda8c26dcc9b99c6fbacd989f5d54b7a3a976cfa5b8ac26f6992d134091add085charm_tools-3.0.8.tar.gz"
  sha256 "ad1e8aaf8f6aece19f3f7db1d45010b471be998b54a0b2861f24b62912f24b9d"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "a84b9723f0d44259ab4d50cac76af7786870e9c05e14ea5d63d3b14d914a8522"
    sha256 cellar: :any,                 arm64_sonoma:  "910a277a7dca782c8e6426ab34cacbfe358c9c72b2b3526b99f078cdbd5efdf4"
    sha256 cellar: :any,                 arm64_ventura: "942c472efe4211cb003477a9606d239b6f1ac32e0a6eb0de9f7975ed7e3c0308"
    sha256 cellar: :any,                 sonoma:        "9bb7815b1072b158ec21d26de051bdce3b35e6c43290d980706d330bb9ca2bcf"
    sha256 cellar: :any,                 ventura:       "e07e53e79d4c44f56c79b86db8e7b7a6152d142dbb2a117096bb6a9a3c49b094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c559d7728920c5fef26f86d3e24ef02d09159478593969b6ed1da32a778f2fc0"
  end

  depends_on "certifi"
  depends_on "charm"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  on_linux do
    depends_on "gmp"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "blessings" do
    url "https:files.pythonhosted.orgpackages5cf89f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  # Using unreleased version for python 3.13 compatibility.
  resource "cheetah3" do
    url "https:github.comCheetahTemplate3cheetah3archive8d82736c0e760ca9bcd01ffcdf95fbb424af116d.tar.gz"
    sha256 "9d4782ec56b110891634370a19691b50d75d220649a51492b2cb96ad965a13b4"
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
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackages7b6f357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0cjeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
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
    url "https:files.pythonhosted.orgpackagescea0834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "otherstuf" do
    url "https:files.pythonhosted.orgpackages4fb5fe92e1d92610449f001e04dd9bf7dc13b8e99e5ef8859d2da61a99fc8445otherstuf-1.1.0.tar.gz"
    sha256 "7722980c3b58845645da2acc838f49a1998c8a6bdbdbb1ba30bcde0b085c4f4c"
  end

  resource "parse" do
    url "https:files.pythonhosted.orgpackages4f78d9b09ba24bb36ef8b83b71be547e118d46214735b6dfb39e4bfde0e9b9ddparse-1.20.2.tar.gz"
    sha256 "b41d604d16503c79d81af5165155c0b20f6c8d6c559efa66b4b695c3e5a0a0ce"
  end

  resource "path" do
    url "https:files.pythonhosted.orgpackages961c3950c87aa25437af5f1663cc8627d44ff26f8c5117a5053c9fc3f641027cpath-16.16.0.tar.gz"
    sha256 "a6a6d916c910dc17e0ddc883358756c5a33d1b6dbdf5d6de86554f399053af58"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackages321a6baf904503c3e943cae9605c9c88a43b964dea5b59785cf956091b341b08pathspec-0.10.3.tar.gz"
    sha256 "56200de4077d9d0791465aa9095a01d421861e405b5096955051deefd697d6f6"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesce3a5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95capyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requirements-parser" do
    url "https:files.pythonhosted.orgpackagesc2f976106e710015f0f8da37bff8db378ced99ae2553cc4b1cffb0aef87dc4acrequirements-parser-0.5.0.tar.gz"
    sha256 "3336f3a3ae23e06d3f0f88595e4052396e3adf91688787f637e5d2ca1a904069"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesd1d6eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages9e8bdc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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
    url "https:files.pythonhosted.orgpackages38b1a52ff157d80464beabb2f0e86881eca28fbc2d519f67ad2f274ef2fe9724types_setuptools-80.7.0.20250516.tar.gz"
    sha256 "57274b58e05434de42088a86074c9e630e5786f759cf9cc1e3015e886297ca21"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "vergit" do
    url "https:files.pythonhosted.orgpackagesd8dc2ef077a97a05633bbe7a46b9cb4b87fbf994a9aaa52b44a8f1086d20951fvergit-1.0.2.tar.gz"
    sha256 "ea82a4d6057d4891a4b16e0881bd756ceea2b66253edc05dd619450f88a5ff31"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages562c444f465fb2c65f40c3a104fd0c495184c4f2336d65baf398e3c75d72ea94virtualenv-20.31.2.tar.gz"
    sha256 "e10c0a9d02835e592521be48b332b6caee6887f332c111aa79a09b9e79efc2af"
  end

  def install
    venv = virtualenv_install_with_resources without: "cheetah3"
    resource("cheetah3").stage do
      # Package was renamed due to PyPI 2FA requirement and charm-tools use of
      # `pkg_resources` raises an exception on missing requirement
      # https:github.comCheetahTemplate3cheetah3commit673259b2d139b4ea970b1c2da12607b7ac39cbec
      inreplace "SetupConfig.py", "name = 'CT3'", "name = 'cheetah3'"
      venv.pip_install Pathname.pwd
    end
  end

  test do
    system bin"charm-create", "brewtest"
    assert_path_exists testpath"brewtestmetadata.yaml"

    assert_match version.to_s, shell_output("#{bin}charm-version")
  end
end