class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https:gitlab.comduplicityduplicity"
  url "https:files.pythonhosted.orgpackagesf333da4f4edb3332f47051017f876709b47633873904aeb7c9ccf9dcaf3d7433duplicity-2.2.2.tar.gz"
  sha256 "833ef5fa922d559be1c4f6a0f61315e8cb26da409f2024bcf310ba3fb9486d27"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5f253d86fc92bbf07a4d1b618ff08aee7d86bda1339ffeab83e266ce6ca3f429"
    sha256 cellar: :any,                 arm64_ventura:  "14604f7c3be5b0fbf0acad27b99a7f1e8e54ba3c085f77676b4bedb11fb14bc2"
    sha256 cellar: :any,                 arm64_monterey: "e8ddc8fcbca0c8fe1a1a664095fe39fcb2e9a4250103b7757c6c3bc7a05de13b"
    sha256 cellar: :any,                 sonoma:         "2f3fc3db7164066b1922075cc93bcb5841b72f0b934fc15c94766f3d3ea20ce8"
    sha256 cellar: :any,                 ventura:        "d01d1e8f8584ca0607c3ef83d17adc82cd41159192ad11dff324a4aadc858587"
    sha256 cellar: :any,                 monterey:       "7aacbc2078f3fdaaf2ca52cb6552635afe6ed73071132bf7bad57f572e21734e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4f445929c70bd51b5763c30fec44606c2a601b6903d351462af9707b4920597"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "rust" => :build # for bcrypt
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "gnupg"
  depends_on "librsync"
  depends_on "libyaml"
  depends_on "protobuf"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "args" do
    url "https:files.pythonhosted.orgpackagese51cb701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6bargs-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "atom" do
    url "https:files.pythonhosted.orgpackages0087d27d5c6c348db24df2403d4a7fc0f23e82b842fbfca0064f6ec063394f3fatom-0.10.4.tar.gz"
    sha256 "7e493fbcf7b58e7e991d5bdabb4b8d5ed5be2c2a36a21ca892dee8db3086a155"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackages510db76383f028aa3570419edf97ab504cb84b839e3cbc8c8b2048f16bbea2d3azure-core-1.30.1.tar.gz"
    sha256 "26273a254131f84269e8ea4464f3560c731f29c0c1f69ac99010845f239c1a8f"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackagesfdf859c209132b3b2993402df6b7e79728726927b53168624e917cd9daaffea8azure-storage-blob-12.19.0.tar.gz"
    sha256 "26c0a4320a34a3c2a1b74528ba6812ebcb632a04cd67b1c7377232c4b01a5897"
  end

  resource "b2sdk" do
    url "https:files.pythonhosted.orgpackages620777dc84bdf8da0ba5bbd1302ea2d1b4a697b05e5be373ed00ee40edc315adb2sdk-1.32.0.tar.gz"
    sha256 "46321bccdd9a295af52cb05d98b5df9771bddf8dcdf68afe3a9fdf7dda156b32"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages72076a6f2047a9dc9d012b7b977e4041d37d078b76b44b7ee4daf331c1e6fb35bcrypt-4.1.2.tar.gz"
    sha256 "33313a1200a3ae90b75587ceac502b048b840fc69e7f7a0905b5f87fac7a1258"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages99a74bde4b0ef2941cfad22a3527cf1fdace545d36cf5b7132613e0cb1e6a035boto3-1.34.53.tar.gz"
    sha256 "cd30261a782824ce543a628ae524480abb4ca6ab4e4a2631477e48baed43b5f2"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages1b3cef2bbbc3d569aa46805ceacb4582b5501415eddbdbb1fa9eeea013e4a044botocore-1.34.53.tar.gz"
    sha256 "3d243781e994dfc5b20036d9fb92672bfaef4dbe388eaa79dae6440ea56c53eb"
  end

  resource "boxsdk" do
    url "https:files.pythonhosted.orgpackages8519ea14622e93be7eda5acdf3ec89915f89a8ffa7b9c911d623199da68a4f62boxsdk-3.9.2.tar.gz"
    sha256 "10e23e2f82e9cff2b2e501b7ca7ffe7bac0e280d1cd4b2983dea95f826e3008b"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesb34d27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5bcachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
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
    url "https:files.pythonhosted.orgpackages31e2a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3cdebtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
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
    url "https:files.pythonhosted.orgpackages58e2c2ce7bf379a7200ecab7de2cbf17dcbb3fe2ab5085925dfe6797e263a475google-api-core-2.17.1.tar.gz"
    sha256 "9df18a1f87ee0df0bc4eea2770ebc4228392d8cc4066655b320e2cfccb15db95"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages1856f49df62e4a221dbd93d8b8c303f7360f41d3e6c210f6905b0f90c1cdfdb9google-api-python-client-2.120.0.tar.gz"
    sha256 "a0c8769cad9576768bcb3191cb1f550f6ab3290cba042badb0fb17bba03f70cc"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages9a15ac42556763c08e1b1821a7e55f3a93982c50ca7f25adf8f61a01dd2ed98bgoogle-auth-2.28.1.tar.gz"
    sha256 "34fc3046c257cedcf1622fc4b31fc2be7923d9b4d44973d481125ecc50d83885"
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

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackagesa58aed955184b2ef9c1eef3aa800557051c7354e5f40a9efc9a46e38c3e6d237jaraco.classes-3.3.1.tar.gz"
    sha256 "cb28a5ebda8bc47d8c8015307d93163464f9f2b91ab4006e09ff0ce07e8bfb30"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jottalib" do
    url "https:files.pythonhosted.orgpackagesaa4b7a5dea988a7a76842738fa23ff8e397109ccb0a85702d10153ce9e46c3cajottalib-0.5.1.tar.gz"
    sha256 "015c9a1772f06a2ad496278aff4b20ad41acc660304fa8f8b854932c662bb0a5"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackagesae6cbd2cfc6c708ce7009bdb48c85bb8cad225f5638095ecc8f49f15e8e1f35ekeyring-24.3.1.tar.gz"
    sha256 "c3327b6ffafc0e8befbdb597cacdb4928ffe5c1212f7645f186e6d9957a898db"
  end

  resource "keystoneauth1" do
    url "https:files.pythonhosted.orgpackagesb85a90d7ae409bdefb9e7cd8e6024e29c33e051e3b20765a12fd88fb963769fekeystoneauth1-5.6.0.tar.gz"
    sha256 "ecb7f34759ebe103db372ab0953c0b821929ddd497f332aa6b3ef6caacffed88"
  end

  resource "logfury" do
    url "https:files.pythonhosted.orgpackages90f224389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "megatools" do
    url "https:files.pythonhosted.orgpackages690ecc12d8dfa5cee8b11c72179de7b23b00d1c1555dfe8c25101d88ae86a7ecmegatools-0.0.4.tar.gz"
    sha256 "4418b67fd6ec4b9417d32e2a153a1757d47bc2819b32c155d744640345630112"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagesc2d55662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackages54e60308695af3bd001c7ce503b3a8628a001841fe1def19374c06d4bce9089bnetaddr-1.2.1.tar.gz"
    sha256 "6eb8fedf0412c6d294d06885c110de945cf4d22d2b510d0404f4e06950857987"
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
    url "https:files.pythonhosted.orgpackages9f79d75e9a6234883adc93838602263d394ffaff6b8d315127c98afd596083f6oslo.config-9.4.0.tar.gz"
    sha256 "35b11a661b608edb50305dad91e4e30819d90ef794b7d7dba5bd8b2ef2eb8c0d"
  end

  resource "oslo-i18n" do
    url "https:files.pythonhosted.orgpackagesc1d67c48b3444e08a0ef7555747a11cddcadf32437cf3ba45b7722b3ab7b1ae0oslo.i18n-6.3.0.tar.gz"
    sha256 "64a251edef8bf1bb1d4e6f78d377e149d4f15c1a9245de77f172016da6267444"
  end

  resource "oslo-serialization" do
    url "https:files.pythonhosted.orgpackages21ff78cc62d4282cf26d322eedf7409a39f7cd5f8c1a83329dc0a65bfa545bd4oslo.serialization-5.4.0.tar.gz"
    sha256 "315cb3465e99c685cb091b90365cb701bee7140e204ba3e5fc2d8a20b4ec6e76"
  end

  resource "oslo-utils" do
    url "https:files.pythonhosted.orgpackages1d82a81644eea01b60fa3fa32e9d376dd2730da82161be8f68d8805c9f05ec23oslo.utils-7.1.0.tar.gz"
    sha256 "5e42f3394d1f1f976e8994ac4a0918966d2f7eaf7c77380dd612c4a4148dd98e"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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

  resource "pydrive2" do
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
    url "https:files.pythonhosted.orgpackageseb81022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577dpyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages37fe65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44bpyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-keystoneclient" do
    url "https:files.pythonhosted.orgpackagesb17c8eeff2659a281a9eaf66bf1c754268cdea71510ef4d2a757fcf5ce312a11python-keystoneclient-5.3.0.tar.gz"
    sha256 "bc5e7719f4156425dec77d75c3a79918e3d0b519378a16d8d7efa8849e4c2a79"
  end

  resource "python-swiftclient" do
    url "https:files.pythonhosted.orgpackagesbfde30a429d8f4f4f5fb725a58c94b3fc7ac714599d5e95fb3da095eca9182a7python-swiftclient-4.5.0.tar.gz"
    sha256 "f2a0887e5a39297abc043251ae3f908914ce1447a2f8d2dca5671618608142bd"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagese7c1b210bf1071c96ecfcd24c2eeb4c828a2a24bf74b38af13896d02203b1eecstevedore-5.2.0.tar.gz"
    sha256 "46b93ca40e1114cea93d738a6c1e365396981bb6bb78c27045b7587c9473544d"
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
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages163a0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages745be025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
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

  resource "jeepney" do
    on_linux do
      url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end
  end

  resource "SecretStorage" do
    on_linux do
      url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
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