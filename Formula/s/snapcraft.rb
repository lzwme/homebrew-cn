class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https:snapcraft.io"
  # Use git checkout so setuptools-scm and update-python-resources works
  url "https:github.comcanonicalsnapcraft.git",
      tag:      "8.8.1",
      revision: "f16a1aedf29e02a4a5589678c1d76a1d698d6ef2"
  license "GPL-3.0-only"
  head "https:github.comcanonicalsnapcraft.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9fa18f86a265157c7ebc13ffc90583d8505cb407a262ecc57c7ee72ad789670f"
    sha256 cellar: :any,                 arm64_sonoma:  "791cd5bb8a393cf63c105ce56e4bb755f56662632a66b2456feec1557725c4c5"
    sha256 cellar: :any,                 arm64_ventura: "e57a30d846e732cb07069293283bc82546231cb560297c1d17ce058d97d8b4c8"
    sha256 cellar: :any,                 sonoma:        "26fb82220920e75b3937bab9ca951cd2fd9a3651a3571debaaeb3bdb1d29359d"
    sha256 cellar: :any,                 ventura:       "99fc4fc36bbb45c85757668f041e22d33cdb03f243ec8e02ac8bc273598b4b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a9261a40fbedf69c711c6de8b4c71690604a44075768c5dd876ec94d6b81f4"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "pygit2"
  depends_on "python@3.13"
  depends_on "snap"
  depends_on "xdelta"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "intltool" => :build # for python-distutils-extra
    depends_on "apt"
    depends_on "cryptography"
  end

  # We hit a build failure with requested 2.4.0ubuntu1 tarball so just using latest Debian
  resource "python-apt" do
    on_linux do
      url "https:deb.debian.orgdebianpoolmainppython-aptpython-apt_3.0.0.tar.xz"
      sha256 "1963720a75b6916bf59c71e75ac4577b9dd51666030f11990f2f56cb31af115f"
    end
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "boolean-py" do
    url "https:files.pythonhosted.orgpackagesc4cf85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "catkin-pkg" do
    url "https:files.pythonhosted.orgpackages2ea288f8ba42a0119833887b8afe159f6e3ae96e2700720baf461eeabcc6acd8catkin_pkg-1.0.0.tar.gz"
    sha256 "476e9f52917282f464739241b4bcaf5ebbfba9a7a68d9af8f875225feac0e1b5"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "craft-application" do
    url "https:files.pythonhosted.orgpackages868620bac2f1a4e45097c01040328ff8ffd5313533d03231db08435559c684c3craft_application-4.10.0.tar.gz"
    sha256 "7a9cda0e854877fb80464e03274e69b97540a618e0c53cbc500b6fce25b9b8c4"
  end

  resource "craft-archives" do
    url "https:files.pythonhosted.orgpackagesa0b240c6f0fc84c87be9fe93aafbc0e98d0d5529aad351e9261fbab9ed1955facraft_archives-2.1.0.tar.gz"
    sha256 "1796ddbdd841443884b4820a9d95ea96639ae8d776c4f0c4a287346e2ccc8e94"
  end

  resource "craft-cli" do
    url "https:files.pythonhosted.orgpackages966486c6310c29a2b58470ee2ddef188a03250bdb2cffa07229e55776b63ac8ccraft_cli-3.0.0.tar.gz"
    sha256 "9dd847d62648fd312284e63237386ff99fc4d24f1adfa0100fe08b003abfe6d9"
  end

  resource "craft-grammar" do
    url "https:files.pythonhosted.orgpackages4f75f4851b02aacbf77ff581c4e09f338920ed0786cf4846c16ae3a65534b9fdcraft_grammar-2.0.3.tar.gz"
    sha256 "90bb9a8a2bf97df866798e634ec6d365c3bee01183c2e1a16394282b411b96a7"
  end

  resource "craft-parts" do
    url "https:files.pythonhosted.orgpackages38af3a36df71dd40f0267e5f7c5d2b0dbe92886a5170475e3a9876dbf88b2eb4craft_parts-2.8.0.tar.gz"
    sha256 "689c0baf4465eed5366bd02580867973cb3285ae3dc43dc9842c87ec37fbd7bc"
  end

  resource "craft-platforms" do
    url "https:files.pythonhosted.orgpackagese73b96f9c7aaf9eca6f677b880029e7c1c160b927d3409f8dc1954d4ccd2a22bcraft_platforms-0.8.0.tar.gz"
    sha256 "0c18f39aef7caadc7b101aa5123e76b4e32396d3217af7bad1184a5014f29369"
  end

  resource "craft-providers" do
    url "https:files.pythonhosted.orgpackages169293e3f7adff46a338ae7087ffedab34dd116b329917735677f3205369b931craft_providers-2.2.0.tar.gz"
    sha256 "dda4df4f777fbc6fbb4fd72cb85ccd237d07875b80a5c95bc70ace3c22d26b07"
  end

  resource "craft-store" do
    url "https:files.pythonhosted.orgpackages7880edc3cf128f1e3302f0c591539a278b4bd6a09ad23e959f620494ce8cb285craft_store-3.2.1.tar.gz"
    sha256 "0c8ae8870362e6e670c0766026849683f6f4563d108a7acca800d4db024a3a21"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "gnupg" do
    url "https:files.pythonhosted.orgpackages966c21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages9f45ad3e1b4d448f22c0cff4f5692f5ed0666658578e358b8d58a19846048059httpcore-1.0.8.tar.gz"
    sha256 "86e94505ed24ea06514883fd44d2bc02d90e77e7979c8eb71b90f41d364a1bad"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https:files.pythonhosted.orgpackagesdfadf3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesab239894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackages7b6f357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0cjeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages580dc816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages7009d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37dkeyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "launchpadlib" do
    url "https:files.pythonhosted.orgpackages30ece659321733decaafe95d4cf964ce360b153de48c5725d5f27cefe97bf5f8launchpadlib-2.1.0.tar.gz"
    sha256 "b4c25890bb75050d54c08123d2733156b78a59a2555f5461f69b0e44cd91242f"
  end

  resource "lazr-restfulclient" do
    url "https:files.pythonhosted.orgpackageseaa345d80620a048c6f5d1acecbc244f00e65989914bca370a9179e3612aeec8lazr.restfulclient-0.14.6.tar.gz"
    sha256 "43f12a1d3948463b1462038c47b429dcb5e42e0ba7f2e16511b02ba5d2adffdb"
  end

  resource "lazr-uri" do
    url "https:files.pythonhosted.orgpackages5853de9135d731a077b1b4a30672720870abdb62577f18b1f323c87e6e61b96clazr_uri-1.0.7.tar.gz"
    sha256 "ed0cf6f333e450114752afb1ce0c299c36ac4b109063eb50354c4f87f825a3ee"
  end

  resource "license-expression" do
    url "https:files.pythonhosted.orgpackages746f8709031ea6e0573e6075d24ea34507b0eb32f83f10e1420f2e34606bf0dalicense_expression-30.4.1.tar.gz"
    sha256 "9f02105f9e0fcecba6a85dfbbed7d94ea1c3a70cf23ddbfb5adf3438a6f6fce0"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "macaroonbakery" do
    url "https:files.pythonhosted.orgpackages4bae59f5ab870640bd43673b708e5f24aed592dc2673cc72caa49b0053b4af37macaroonbakery-1.3.4.tar.gz"
    sha256 "41ca993a23e4f8ef2fe7723b5cd4a30c759735f1d5021e990770c8a0e0f33970"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagescea0834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "mypy-extensions" do
    url "https:files.pythonhosted.orgpackagesa26e371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628bmypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
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
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesb62d7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "progressbar" do
    url "https:files.pythonhosted.orgpackagesa3a6b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesc88ccf2ac658216eebe49eaedf1e06bc06cbf6a143469236294a1171a51357c3protobuf-6.30.2.tar.gz"
    sha256 "35c859ae076d8c56054c25b59e5e59638d86545ed6e2b6efac6be0b6ea3ba048"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages102eca897f093ee6c5f3b0bee123ee4465c50e75431c3d5b6a3b44a47134e891pydantic-2.11.3.tar.gz"
    sha256 "7471657138c16adad9322fe3070c0116dd6c3ad8d649300e3cbdfe91f4db4ec3"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages1719ed6a078a5287aea7922de6841ef4c06157931622c89c2a47940837b5eecdpydantic_core-2.33.1.tar.gz"
    sha256 "bcc9c6fdb0ced789245b02b7d6603e17d1563064ddcfc36f046b61c0c05dd9df"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackagesb9ab33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071afpyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pylxd" do
    url "https:files.pythonhosted.orgpackages9b8e6a31a694560adaba20df521c3102bdecec06a0fea9c73ff1466834e2df30pylxd-2.3.5.tar.gz"
    sha256 "d67973dd2dc1728e3e1b41cc973e11e6cbceae87878d193ac04cc2b65a7158ef"
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
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyrfc3339" do
    url "https:files.pythonhosted.orgpackages005275ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-debian" do
    url "https:files.pythonhosted.orgpackagesce8d2ebc549adf1f623d4044b108b30ff5cdac5756b0384cd9dddac63fe53eaepython-debian-0.1.49.tar.gz"
    sha256 "8cf677a30dbcb4be7a99536c17e11308a827a4d22028dc59a67f6c6dd3f0f58c"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackagesf8bfabbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aacpytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyxdg" do
    url "https:files.pythonhosted.orgpackagesb0257998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "raven" do
    url "https:files.pythonhosted.orgpackages7957b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket2" do
    url "https:files.pythonhosted.orgpackagese37b8f398d91382a2bbae06530389f74d6296a4da04827144a3015f34b7d82c4requests_unixsocket2-1.0.0.tar.gz"
    sha256 "8c6cad0326369658db931b4c36f03cd1cccb7668e081e7fb3972b500a93bb563"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesbb71b6365e6325b3290e14957b2c3a804a529968c77a049b2ed40c095f749707setuptools-79.0.1.tar.gz"
    sha256 "128ce7b8f33c3079fd1b067ecbb4051a66e8526e7b65f6cec075dfc650ddfa88"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackagesaf9251b417685abd96b31308b61b9acce7ec50d8e1de8fbc39a7fd4962c60689simplejson-3.20.1.tar.gz"
    sha256 "e64139b4ec4f1f24c142ff7dcafe55a22b811a74d86d66560c8815687143037d"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "snap-helpers" do
    url "https:files.pythonhosted.orgpackages502a221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tinydb" do
    url "https:files.pythonhosted.orgpackagesa0794af51e2bb214b6ea58f857c51183d92beba85b23f7ba61c983ab3de56c33tinydb-4.8.2.tar.gz"
    sha256 "f7dfc39b8d7fda7a1ca62a8dbb449ffd340a117c1206b68c50b1a481fb95181d"
  end

  resource "toml" do
    url "https:files.pythonhosted.orgpackagesbeba1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3ctoml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackages825ce6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "validators" do
    url "https:files.pythonhosted.orgpackages640791582d69320f6f6daaf2d8072608a4ad8884683d4840e7e4f3a9dbdcc639validators-0.34.0.tar.gz"
    sha256 "647fe407b45af9a74d245b943b18e6a816acf4926974278f6dd617778e1e781f"
  end

  resource "wadllib" do
    url "https:files.pythonhosted.orgpackagesda5482866d8c2bf602ed9df52c8f8b7a45e94f8c2441b3d1e9e46d34f0e3270fwadllib-2.0.0.tar.gz"
    sha256 "1edbaf23e4fa34fea70c9b380baa2a139b1086ae489ebcccc4b3b65fc9737427"
  end

  resource "ws4py" do
    url "https:files.pythonhosted.orgpackagescb55dd8a5e1f975d1549494fe8692fc272602f17e475fe70de910cdd53aec902ws4py-0.6.0.tar.gz"
    sha256 "9f87b19b773f0a0744a38f3afa36a803286dd3197f0bb35d9b75293ec7002d19"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    without = %w[jeepney secretstorage pylxd ws4py] if OS.mac?
    virtualenv_install_with_resources(without:)
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}snapcraft --version")

    assert_match "Package, distribute, and update snaps", shell_output("#{bin}snapcraft --help 2>&1")

    system bin"snapcraft", "init"
    assert_path_exists testpath"snapsnapcraft.yaml"
  end
end