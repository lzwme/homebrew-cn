class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https:gitlab.comduplicityduplicity"
  url "https:files.pythonhosted.orgpackages48987c5ba07fdd930079bc20ea73b53428acf99cd9e2a60d5eb885b0fe47bfbaduplicity-2.1.5.tar.gz"
  sha256 "676c14e1b0029396954a054ddc2e9f12c939dfcfa95a4fb79b27ec396d6c15d1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3df97bfcdd765a3fb12ea287790921c48efe66072d6dd9f95ff0edec863d555c"
    sha256 cellar: :any,                 arm64_ventura:  "c6bd9cd7f5560529cb27f28e1d24dfa0ee735f6b984d89033e336cadfd153722"
    sha256 cellar: :any,                 arm64_monterey: "4878cb0973673aae69082d5968692a615291bde19686db8af4a5dd44ff1d7664"
    sha256 cellar: :any,                 sonoma:         "bfb279a859c3c08a4b1a79858470d5d6a69cc884174a1be40836b89dcf634981"
    sha256 cellar: :any,                 ventura:        "45874d4f0ad08260ce89aa4fb4d88d7f5468c3197cdcb152ad54fa79bd4219d0"
    sha256 cellar: :any,                 monterey:       "30645a4fc70e7e8dc5d40aae576bdfa7b7cb77c1789c9b3e48edcf123ea17b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038e1bf4168cea7aaa9641a30426722325a1f9724249756b8f26bae0484ad1fe"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "rust" => :build # for bcrypt
  depends_on "gnupg"
  depends_on "keyring"
  depends_on "librsync"
  depends_on "protobuf"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-dateutil"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python-ply"
  depends_on "python-psutil"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  # upstream as of 2.1.5 requires a Python no higher than 3.11
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "args" do
    url "https:files.pythonhosted.orgpackagese51cb701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6bargs-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "atom" do
    url "https:files.pythonhosted.orgpackagesff3a47fa91bfb49ea12307a0470fce4c48281c63ad0f86b9bbf83398efe4dd17atom-0.10.3.tar.gz"
    sha256 "4378d8d6db6399ce75a039b08e3b4a9561e22f62ef84db358c40726805c295e5"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackagesad78a1aeb8f80306101112810263e74ec81a99cdd50ecca1f03819716c1aedb3azure-core-1.29.6.tar.gz"
    sha256 "13b485252ecd9384ae624894fe51cfa6220966207264c360beada239f88b738a"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackagesfdf859c209132b3b2993402df6b7e79728726927b53168624e917cd9daaffea8azure-storage-blob-12.19.0.tar.gz"
    sha256 "26c0a4320a34a3c2a1b74528ba6812ebcb632a04cd67b1c7377232c4b01a5897"
  end

  resource "b2sdk" do
    url "https:files.pythonhosted.orgpackagesa7c63f2cfe70f4fb1ccc00fdd1e73417a9e6aff2e5bc390ba005705563deaf48b2sdk-1.29.0.tar.gz"
    sha256 "87fa572c6a50dbe10dc56a886fdcad7aba1ab9db12f07cfeb2b68e37eeb94ccc"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages72076a6f2047a9dc9d012b7b977e4041d37d078b76b44b7ee4daf331c1e6fb35bcrypt-4.1.2.tar.gz"
    sha256 "33313a1200a3ae90b75587ceac502b048b840fc69e7f7a0905b5f87fac7a1258"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesa94cb9b0786dd9a13e6f05ce8ba83ce54da163d3c963f9c3ba3c8312a2423058boto3-1.34.12.tar.gz"
    sha256 "67b763669f9eff10a55fe199875d6e66fda8051647af49f8b9b8fced674d75d7"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesbf49cdd991d1cf0306f4a98df37848eb40ce628e6e430b4805d14b73dc4f4cf3botocore-1.34.12.tar.gz"
    sha256 "53dfc19d63f2b70821e9804b7ecfc5e50fc84d9bd6818359b27db629ef43ec59"
  end

  resource "boxsdk" do
    url "https:files.pythonhosted.orgpackages8519ea14622e93be7eda5acdf3ec89915f89a8ffa7b9c911d623199da68a4f62boxsdk-3.9.2.tar.gz"
    sha256 "10e23e2f82e9cff2b2e501b7ca7ffe7bac0e280d1cd4b2983dea95f826e3008b"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages10211b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "clint" do
    url "https:files.pythonhosted.orgpackages3db441ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26dclint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "debtcollector" do
    url "https:files.pythonhosted.orgpackagesc87d904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211adebtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "dropbox" do
    url "https:files.pythonhosted.orgpackages8d0f2059c5ef8669e625a533661a2054a82241696954df6662aeee51a34b1022dropbox-11.36.2.tar.gz"
    sha256 "d48d3d16d486c78b11c14a1c4a28a2611fbf5a0d0a358b861bfd9482e603c500"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackagesff7bba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "fasteners" do
    url "https:files.pythonhosted.orgpackages5fd4e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "gdata-python3" do
    url "https:files.pythonhosted.orgpackagesde137c54a70f2d415750408b22f6a5ede98d33c0f1da9a40449926e8a2037723gdata-python3-3.0.1.tar.gz"
    sha256 "b77301becfb3bf42e9a459169e75e6ff4c20cc7b7e247d4d84988e8c8ac6d898"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages2ce456b14d35057a23cab9067dd8fb841407d05d32b5d6c7a3c66c1360e8a7c0google-api-core-2.15.0.tar.gz"
    sha256 "abc978a72658f14a2df1e5e12532effe40f94f868f6e23d95133bd6abcca35ca"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages040e5f8e84ec422e5037eb38c6ee3cc3b8c5a4f74ab5b7b099ebb7d00762f73dgoogle-api-python-client-2.111.0.tar.gz"
    sha256 "3a45a53c031478d1c82c7162dd25c9a965247bca6bd438af0838a9d9b8219405"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackagesc69fe10d974ebbf4df841ed56cdb7f9fde341cf27c3ef52c0f951ea7cc793fe9google-auth-2.26.0.tar.gz"
    sha256 "5d8bf0a5143baa45368c3d08bf157babda468db1c5dd987cd2c824b788524196"
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

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages76217a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75chumanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackagesdb7ac0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1afisodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jottalib" do
    url "https:files.pythonhosted.orgpackagesaa4b7a5dea988a7a76842738fa23ff8e397109ccb0a85702d10153ce9e46c3cajottalib-0.5.1.tar.gz"
    sha256 "015c9a1772f06a2ad496278aff4b20ad41acc660304fa8f8b854932c662bb0a5"
  end

  resource "keystoneauth1" do
    url "https:files.pythonhosted.orgpackages7a280b760f26f0c33c48aec42003c8a9ea96b0bc409d7fb892593ee30f272a9fkeystoneauth1-5.4.0.tar.gz"
    sha256 "1ac134151ceb02e50b68ad78dec9821bf89fe53bd36fc8658501c47b07cbdf53"
  end

  resource "logfury" do
    url "https:files.pythonhosted.orgpackages90f224389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "megatools" do
    url "https:files.pythonhosted.orgpackages690ecc12d8dfa5cee8b11c72179de7b23b00d1c1555dfe8c25101d88ae86a7ecmegatools-0.0.4.tar.gz"
    sha256 "4418b67fd6ec4b9417d32e2a153a1757d47bc2819b32c155d744640345630112"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagesc2d55662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackagesaf96f4878091248450bbdebfbd01bf1d95821bd47eb38e756815a0431baa6b07netaddr-0.10.1.tar.gz"
    sha256 "f4da4222ca8c3f43c8e18a8263e5426c750a3a837fdfeccf74c68d0408eaa3bf"
  end

  resource "netifaces" do
    url "https:files.pythonhosted.orgpackagesa69186a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "oauth2client" do
    url "https:files.pythonhosted.orgpackagesa67b17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "os-service-types" do
    url "https:files.pythonhosted.orgpackages583f09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ecos-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
  end

  resource "oslo-config" do
    url "https:files.pythonhosted.orgpackages86df3806c478e29866001cd0e04f22a9688851928a2da830aceb5a026d125a40oslo.config-9.2.0.tar.gz"
    sha256 "ffeb01ca65a603d5525905f1a88a3319be09ce2c6ac376c4312aaec283095878"
  end

  resource "oslo-i18n" do
    url "https:files.pythonhosted.orgpackagesa424c4c441628dee6f6a34b8a433fb1e12853f066f9d0a0c7b7cf88cb8547b10oslo.i18n-6.2.0.tar.gz"
    sha256 "70f8a4ce9871291bc609d07e31e6e5032666556992ff1ae53e78f2ed2a5abe82"
  end

  resource "oslo-serialization" do
    url "https:files.pythonhosted.orgpackages1d75dff75372e7af48468da06f52c6a9abca63b7a4000165ce49e161011a4a10oslo.serialization-5.2.0.tar.gz"
    sha256 "9cf030d61a6cce1f47a62d4050f5e83e1bd1a1018ac671bb193aee07d15bdbc2"
  end

  resource "oslo-utils" do
    url "https:files.pythonhosted.orgpackagesdd64453052c33d834e4b187e5459e7a3f8ae67134d321de96aa0bd3e918c9bf2oslo.utils-6.3.0.tar.gz"
    sha256 "758d945b2bad5bea81abed80ad33ffea1d1d793348ac5eb5b3866ba745b11d55"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackagesccaf11996c4df4f9caff87997ad2d3fd8825078c277d6a928446d2b6cf249889paramiko-3.4.0.tar.gz"
    sha256 "aac08f26a31dc4dffd92821527d1682d99d52f9ef6851968114a8728f3c274d3"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages8dc2ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagescedc996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages3be47dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070fpyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "PyDrive2" do
    url "https:files.pythonhosted.orgpackagesbd37f256fce47c0bd63af9e8c63253e144f26e22ad5969dc83dfa59282ff11cbPyDrive2-1.19.0.tar.gz"
    sha256 "21aea7da27635c2c3f7050e020206191f3b0305c6550315e6e8e3dd526f8b531"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackagesbfa0e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610epyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "python-keystoneclient" do
    url "https:files.pythonhosted.orgpackages13c3456c3d3125a189adf7d23e7ca7759226d717fdce20c6c590686d03886897python-keystoneclient-5.2.0.tar.gz"
    sha256 "72a42c3869e2128bb0c626ac856c3dbf3e38ef16d7e85dd35567b82cd24539a9"
  end

  resource "python-swiftclient" do
    url "https:files.pythonhosted.orgpackages1269e6c03ad881aa63d9c1aada4613e463b0af384df406d358e502d2aeaf277apython-swiftclient-4.4.0.tar.gz"
    sha256 "a77d97ab0e4012c678732e575bdfeed282b3489b9175e82c46a47ac8491eee84"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages9552531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49frequests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rfc3986" do
    url "https:files.pythonhosted.orgpackages85401520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "setuptools-scm" do
    url "https:files.pythonhosted.orgpackagesebb10248705f10f6de5eefe7ff93e399f7192257b23df4d431d2f5680bb2778fsetuptools-scm-8.0.4.tar.gz"
    sha256 "b5f43ff6800669595193fd09891564ee9d1d7dcb196cab4b2506d53a2e1c95c7"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagesacd677387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  # Using GitHub tarball as requirements.txt is missing from PyPI tarball.
  # Issue ref: https:github.comdropboxstoneissues266
  resource "stone" do
    url "https:github.comdropboxstonearchiverefstagsv3.3.1.tar.gz"
    sha256 "dc5aff3fad1333188d4ddb4eee0a19d31e6262bb3cdf10c0bbdaeb309ff91a52"
  end

  resource "tlslite-ng" do
    url "https:files.pythonhosted.orgpackagescd954311e6b70ded82035b7f3a92bfe5ea350e6d9effe925493ac31ccaf924cctlslite-ng-0.7.6.tar.gz"
    sha256 "6ab56f0e9629ce3d807eb528c9112defa9f2e00af2b2961254e8429ca5c1ff00"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages4d60acd18ca928cc20eace3497b616b6adb8ce1abc810dd4b1a22bc6bdefac92tzdata-2023.4.tar.gz"
    sha256 "dd54c94f294765522c77399649b4fefd95522479a664a0cec87f41bebc6148c9"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackagesd25a4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000ebauritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install_and_link(buildpath, link_manpages: true)

    site_packages = Language::Python.site_packages("python3.11")
    paths = %w[keyring].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    (testpath"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    system Formula["gnupg"].opt_bin"gpg", "--batch", "--gen-key", "batch.gpg"
    begin
      (testpath"testhello.txt").write "Hello!"
      ENV["PASSPHRASE"] = "brew"
      system bin"duplicity", "--tempdir=#{testpath}", "full", ".test", "file:output"
      assert_match "duplicity-full-signatures", Dir["output*"].to_s

      # Ensure requests[security] is activated
      script = "import requests as r; r.get('https:mozilla-modern.badssl.com')"
      system libexec"binpython", "-c", script
    ensure
      system Formula["gnupg"].opt_bin"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin"gpgconf", "--homedir", "keyringslive",
                                                 "--kill", "gpg-agent"
    end
  end
end