class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https:snapcraft.io"
  url "https:github.comsnapcoresnapcraftarchiverefstags8.2.4.tar.gz"
  sha256 "ad08a63846ce8d4303b42a6e873564a9a8f09e92818ad9ff691e5d69b03ed6de"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4dd330e2210cf96230048c20359d09683a845f3fc2b811125c3948e77074164c"
    sha256 cellar: :any,                 arm64_ventura:  "14d31c5ab962fb4047aaba25e4bfdb3aea742453cd2028e49a1204a38996b67c"
    sha256 cellar: :any,                 arm64_monterey: "f50e6f4d955ad06888660379f149f7523ac7d742ad83eb71719391a5b4f7480a"
    sha256 cellar: :any,                 sonoma:         "b26ebc51f8306a92e4140d1ae56839132cfc007ab103ce75084e2e66b84de3b7"
    sha256 cellar: :any,                 ventura:        "912a6eaa395c5da7623efddbc20373f4601a125757fe19688603c53a333348d6"
    sha256 cellar: :any,                 monterey:       "770c464f0ee58347c07ea26445402d1d3448dd4a4ac89a9f75c536422505210f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f8f74efce50593e79179d042c38c5ec1913f4a33f242c26616b7557d3ffb085"
  end

  depends_on "libgit2"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "python@3.12"
  depends_on "snap"
  depends_on "xdelta"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "intltool" => :build # for python-distutils-extra
    depends_on "apt"
    depends_on "cryptography"

    # Extra non-PyPI Python resources
    # https:github.comsnapcoresnapcraftblob91a18b3128de4971edfc090a8683a64ff1679f2esetup.py#L154-L158

    resource "python-distutils-extra" do
      url "https:deb.debian.orgdebianpoolmainppython-distutils-extrapython-distutils-extra_3.0.tar.xz"
      sha256 "e5b9aa81a48a4dfdd817310b4f8c932a7bd9b86081a331d956581eac884e0499"
    end

    resource "python-apt" do
      url "https:deb.debian.orgdebianpoolmainppython-aptpython-apt_2.7.6.tar.xz"
      sha256 "19918f9f2e30f690e89bb7c2eeb8b9bc229a2a0792df3aecf632ad4cbc6ee4b9"
    end

    # Extra PyPI Python resources for Linux

    resource "chardet" do
      url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
      sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
    end

    resource "jeepney" do
      url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "pylxd" do
      url "https:files.pythonhosted.orgpackagesc396660420c53f18b570697f40e9f69ab80cc61f8075fc7bd92f115d56a48ea1pylxd-2.3.3.tar.gz"
      sha256 "931674c06f3f3c83104983457fed03f3bf78cd4c8aebcd8b666c8134ea839bff"
    end

    resource "python-debian" do
      url "https:files.pythonhosted.orgpackagesce8d2ebc549adf1f623d4044b108b30ff5cdac5756b0384cd9dddac63fe53eaepython-debian-0.1.49.tar.gz"
      sha256 "8cf677a30dbcb4be7a99536c17e11308a827a4d22028dc59a67f6c6dd3f0f58c"
    end

    resource "secretstorage" do
      url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end

    resource "ws4py" do
      url "https:files.pythonhosted.orgpackages53204019a739b2eefe9282d3822ef6a225250af964b117356971bd55e274193cws4py-0.5.1.tar.gz"
      sha256 "29d073d7f2e006373e6a848b1d00951a1107eb81f3742952be905429dc5a5483"
    end
  end

  fails_with gcc: "5" # due to apt on Linux

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "catkin-pkg" do
    url "https:files.pythonhosted.orgpackages2ea288f8ba42a0119833887b8afe159f6e3ae96e2700720baf461eeabcc6acd8catkin_pkg-1.0.0.tar.gz"
    sha256 "476e9f52917282f464739241b4bcaf5ebbfba9a7a68d9af8f875225feac0e1b5"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackages71dae94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "craft-application" do
    url "https:files.pythonhosted.orgpackages42b8c0a024554bddaed086576610348ceffc0de13555dbe9a50f8adf50e3bb8acraft_application-2.6.3.tar.gz"
    sha256 "b7bf5a185970d400d64b705d138bf1fa340eae3bd155d9508119d80c27922392"
  end

  resource "craft-archives" do
    url "https:files.pythonhosted.orgpackagesf66690a253f7d787800902ec412c7b9e25f4a06d2593214ebc16da57d259d19bcraft-archives-1.1.3.tar.gz"
    sha256 "2efd153df09870c4d5e851e5bd05c6dc1824e973852b83c6218b97d2362035a5"
  end

  resource "craft-cli" do
    url "https:files.pythonhosted.orgpackages9d3647163ccdb62ba207fd8336f7c0d30f57ef34d52a3cdd4ce71aaffe5467a7craft-cli-2.5.1.tar.gz"
    sha256 "c961f8683bf4b6d0d5c0a798def401bd4b62c912c8fc2222d13e38ced0976c4f"
  end

  resource "craft-grammar" do
    url "https:files.pythonhosted.orgpackages41c3e008b986b5fac41286b93e129059addb27deee7dfa32d3756b416b24d8d3craft-grammar-1.2.0.tar.gz"
    sha256 "2f770f986c74e89247b31b9df18221f7c79d1423aef4a34268d0f9a47ace63da"
  end

  resource "craft-parts" do
    url "https:files.pythonhosted.orgpackagesaf3022154fdfc6ec43cdce792855fe7708239ebae2afba922c0159ad7f16f745craft-parts-1.29.0.tar.gz"
    sha256 "09958d5c5802cf48fd9d7d189f5c30bf7a4721d0b668bd14e47bee32edd25a5b"
  end

  resource "craft-providers" do
    url "https:files.pythonhosted.orgpackagesd7c18b75707587ac6bf403482298febcc0eb170d2bd5b902449145a8b6c37c31craft-providers-1.23.1.tar.gz"
    sha256 "60dd086f638a5de2930068839b5f7cd52c661f083e154db9e1deb65279da6c56"
  end

  resource "craft-store" do
    url "https:files.pythonhosted.orgpackagesc4c45033f4deebe022b6b3ae96a75c254280362d437a1822c5ffa73a38a30ee1craft-store-2.6.1.tar.gz"
    sha256 "30b6b8c5deca963e320af604904c5fbf92d1cb884a2f1dd3c9d0958dac2adde0"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages6b5c330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91fdocutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "gnupg" do
    url "https:files.pythonhosted.orgpackages966c21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesa0fcc4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages580dc816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackagesae6cbd2cfc6c708ce7009bdb48c85bb8cad225f5638095ecc8f49f15e8e1f35ekeyring-24.3.1.tar.gz"
    sha256 "c3327b6ffafc0e8befbdb597cacdb4928ffe5c1212f7645f186e6d9957a898db"
  end

  resource "launchpadlib" do
    url "https:files.pythonhosted.orgpackagese161cf604b4248ccb707c433f9905a8d18943667a1823cf4d3712bd5587db790launchpadlib-1.11.0.tar.gz"
    sha256 "01898c937477b0c64a75338adb0977028d7346a8a019eb023cf68fed99850146"
  end

  resource "lazr-restfulclient" do
    url "https:files.pythonhosted.orgpackageseaa345d80620a048c6f5d1acecbc244f00e65989914bca370a9179e3612aeec8lazr.restfulclient-0.14.6.tar.gz"
    sha256 "43f12a1d3948463b1462038c47b429dcb5e42e0ba7f2e16511b02ba5d2adffdb"
  end

  resource "lazr-uri" do
    url "https:files.pythonhosted.orgpackagesa6db310eaccd3639f5a8a6011c3133bb1cac7fd80bb46f8a50406df2966302e4lazr.uri-1.0.6.tar.gz"
    sha256 "5026853fcbf6f91d5a6b11ea7860a641fe27b36d4172c731f4aa16b900cf8464"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseae23834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "macaroonbakery" do
    url "https:files.pythonhosted.orgpackages4bae59f5ab870640bd43673b708e5f24aed592dc2673cc72caa49b0053b4af37macaroonbakery-1.3.4.tar.gz"
    sha256 "41ca993a23e4f8ef2fe7723b5cd4a30c759735f1d5021e990770c8a0e0f33970"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "mypy-extensions" do
    url "https:files.pythonhosted.orgpackages98a41ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3fmypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "overrides" do
    url "https:files.pythonhosted.orgpackages3686b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesb2e42856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  resource "progressbar" do
    url "https:files.pythonhosted.orgpackagesa3a6b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesd2e57e22ca7201a6b1040aae7787d0fe6cd970311da376a86fdafa5182be1d1bprotobuf-5.26.1.tar.gz"
    sha256 "8ca2a1d97c290ec7b16e4e5dff2e5ae150cc1582f55b5ab300d45cb0dfa90e51"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages90c76dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages6f3a1a057845b787469aa8c4ff2c126d5110d616223c82e74561b8ae56b46ec7pydantic-1.10.15.tar.gz"
    sha256 "ca832e124eda231a60a041da4f013e3ff24949d94a01154b137fc2f2a43c3ffb"
  end

  resource "pydantic-yaml" do
    url "https:files.pythonhosted.orgpackages9ee730713a0fae04001f8886b0219cad667b0fbf56149f4ea3ee5a84e8e0c9e7pydantic_yaml-0.11.2.tar.gz"
    sha256 "19c8f3c9a97041b0a3d8fc06ca5143ff71c0846c45b39fde719cfbc98be7a00c"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages88560f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pygit2" do
    url "https:files.pythonhosted.orgpackages0950f0795db653ceda94f4388d2b40598c188aa4990715909fabcf16b381b843pygit2-1.13.3.tar.gz"
    sha256 "0257c626011e4afb99bdb20875443f706f84201d4c92637f02215b98eac13ded"
  end

  resource "pymacaroons" do
    url "https:files.pythonhosted.orgpackages37b452ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923epymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pyrfc3339" do
    url "https:files.pythonhosted.orgpackages005275ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyxdg" do
    url "https:files.pythonhosted.orgpackagesb0257998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "raven" do
    url "https:files.pythonhosted.orgpackages7957b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket" do
    url "https:files.pythonhosted.orgpackagesc3ea0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354ebrequests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackages79793ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afasimplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "snap-helpers" do
    url "https:files.pythonhosted.orgpackages502a221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tinydb" do
    url "https:files.pythonhosted.orgpackages300b9e75a8d3333a6a3d9b36de04bf87a37a8d7f100035ea23c9c37bf0a112abtinydb-4.8.0.tar.gz"
    sha256 "6dd686a9c5a75dfa9280088fd79a419aefe19cd7f4bd85eba203540ef856d564"
  end

  resource "toml" do
    url "https:files.pythonhosted.orgpackagesbeba1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3ctoml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "types-deprecated" do
    url "https:files.pythonhosted.orgpackages2710d9e72aedcd94fba94e511eebb03bcbd2b535e7e1c48e4416367682cd1c4etypes-Deprecated-1.2.9.20240311.tar.gz"
    sha256 "0680e89989a8142707de8103f15d182445a533c1047fd9b7e8c5459101e9b90a"
  end

  resource "types-pyyaml" do
    url "https:files.pythonhosted.orgpackages0a3c6f4c97d9eb2b58f57fc595c105ae0a53a851747cddfb7df30f3d7192c837types-PyYAML-6.0.12.20240311.tar.gz"
    sha256 "a9e0f0f88dc835739b0c1ca51ee90d04ca2a897a71af79de9aec5f38cb0a5342"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "wadllib" do
    url "https:files.pythonhosted.orgpackages3507040cc4cc736cdf25873848bd4c717cc25e257196a7c11f42b3a09617a961wadllib-1.3.6.tar.gz"
    sha256 "acd9ad6a2c1007d34ca208e1da6341bbca1804c0e6850f954db04bdd7666c5fc"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3eef65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["SNAP_VERSION"] = version.to_s
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}snapcraft --version")

    assert_match "Package, distribute, and update snaps", shell_output("#{bin}snapcraft --help 2>&1")

    system bin"snapcraft", "init"
    assert_predicate testpath"snapsnapcraft.yaml", :exist?
  end
end