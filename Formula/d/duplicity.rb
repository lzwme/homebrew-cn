class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https:gitlab.comduplicityduplicity"
  url "https:files.pythonhosted.orgpackages56c134f63e68f81481e9a1e276f9a8e185ff869c81e9e4acdfb7ee4994a2592cduplicity-2.1.4.tar.gz"
  sha256 "9bbe8cb3527b296011c11ce8a8d4323d8562fe532aa70d355305bea2927158e5"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "fe8aa4712f82c04c2859a33f34fc47afbf8618eb0e0df75008633f57bf1437b0"
    sha256 cellar: :any,                 arm64_ventura:  "c6225c8555e0022ff030413b0908ff3e4b38fee0e58a9952b578892159bb04a2"
    sha256 cellar: :any,                 arm64_monterey: "d1e00615f7139e7c7269a5f523c50d6185809608f4746b7105005fd8e38e6ab6"
    sha256 cellar: :any,                 sonoma:         "826ecd53088487403664abc146c25ad9b08e9bda3adae484baf68264d8120ac9"
    sha256 cellar: :any,                 ventura:        "91a87bce78353950e9f936904842c5532d19498963c67e14cefe078d5bc00e24"
    sha256 cellar: :any,                 monterey:       "7e6b7c58ef0fe946ba3bcd337ac071872bd9bf8436355187f15abaf2473e095c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "586dc8bc5dd230a7c04e17ad3406a044e0ff6ed81c49aa1376e047954321e099"
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
  depends_on "python@3.12"
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
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackagese339328faea9f656075dbb8ecf70f1a4697bc80510fcc70e3e8f0090c34fc00cazure-core-1.29.5.tar.gz"
    sha256 "52983c89d394c6f881a121e5101c5fa67278ca3b1f339c8fb2ef39230c70e9ac"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackages9df54ec0b5b3a99f6a4bb5c82f8dbab121bcd892c355ae363140558a164cff08azure-storage-blob-12.18.3.tar.gz"
    sha256 "d8ced0deee3367fa3d4f3d1a03cd9edadf4440c0a371f503d623fa6c807554ee"
  end

  resource "b2sdk" do
    url "https:files.pythonhosted.orgpackages8981ffd3998f719b9ccdeae3604ed85f190ebdee9af8ced388a203f5475024ecb2sdk-1.24.1.tar.gz"
    sha256 "4e9f518edc9ba824b1075805657ae3c0d2789a6c25f8e593cd5c87776e7425ab"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages8cae3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aadbcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages97a1d30d1f8e5b6a32222e2c8d0c01b976b91ca382ac7c70ed7df8f3d4cd7660boto3-1.28.73.tar.gz"
    sha256 "a61cf96f7e196b1450afdf4856b7ea0e58080752e687b0011157be96934489be"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages358209f64a0a79554b26b301a7cd1ee4ec75ae9658e315f593fa4fd35b154d76botocore-1.31.73.tar.gz"
    sha256 "5334c22d5a3f4643931896137c57b2496fef005b039d87d8740e7a28eb31519d"
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
    url "https:files.pythonhosted.orgpackages6db3aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768bcharset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
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
    url "https:files.pythonhosted.orgpackages3f5d9138d873205a38e5264a78fd4ebf446fc987f20e2566719ed6eee69c200agoogle-api-core-2.12.0.tar.gz"
    sha256 "c22e01b1e3c4dcd90998494879612c38d0a3411d1f7b679eb89e2abe3ce1f553"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages03757a04c88700a6c186bb7e9979c1b2b15d1944bf66453b778ea69e4efcccb6google-api-python-client-2.105.0.tar.gz"
    sha256 "0a8b32cfc2d9b3c1868ae6faef7ee1ab9c89a6cec30be709ea9c97f9a3e5902d"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages45710f19d6f51b6ea291fc8f179d152d675f49acf88cb44f743b37bf51ef2ec1google-auth-2.23.3.tar.gz"
    sha256 "6864247895eea5d13b9c57c9e03abb49cb94ce2dc7c58e91cba3248c7477c9e3"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages0f7a83c3a1f8419d66f91672ad7f2cea57d044f7f0b3c1740389a468ff3937edgoogle-auth-httplib2-0.1.1.tar.gz"
    sha256 "c64bc555fdc6dd788ea62ecf7bccffcf497bf77244887a3f3d7a5a02f8e3fc29"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackages6a34c584323ea98fb596e71ade06c06d514de898c60498efc72311e18ebe2825google-auth-oauthlib-1.1.0.tar.gz"
    sha256 "83ea8c3b0881e453790baff4448e8a6112ac8778d1de9da0b68010b843937afb"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages9541f9d4425eac5cec8c0356575b8f183e8f1f7206875b1e748bd3af4b4a8a1egoogleapis-common-protos-1.61.0.tar.gz"
    sha256 "8a64866a97f6304a7179873a465d6eee97b7a24ec6cfd78e0f575e96b821240b"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages0c84e58c665f4ebb03d2fbeb28b51afb0743f846db18a5b594ed8b8973676ddfhumanize-4.8.0.tar.gz"
    sha256 "9783373bf1eec713a770ecaa7c2d7a7902c98398009dfa3d8a2df91eec9311e8"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https:files.pythonhosted.orgpackages9bb3ddee6a16e07fea73295476394ab75c8294a396fc164d6547b73922ab3ee5keystoneauth1-5.3.0.tar.gz"
    sha256 "017c2b9b599453c92940750edbb20f17687121b2890114bf9d36df14a0627117"
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
    url "https:files.pythonhosted.orgpackages484c2491bfdb868c3f40d985037fa64a3903c125f45d7d3025640e05715db7a3netaddr-0.9.0.tar.gz"
    sha256 "7b46fa9b1a2d71fd5de9e4a3784ef339700a53a08c8040f08baf5f1194da0128"
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
    url "https:files.pythonhosted.orgpackagesf3846949f4ae2ab3fe2996a1200a6e2cd6acc9982d3a07790e43d807c7f9b99boslo.i18n-6.1.0.tar.gz"
    sha256 "e2b829f205bf1eb6204756cc34027d119494b62d271feee860bf816ca7a07ead"
  end

  resource "oslo-serialization" do
    url "https:files.pythonhosted.orgpackages1d75dff75372e7af48468da06f52c6a9abca63b7a4000165ce49e161011a4a10oslo.serialization-5.2.0.tar.gz"
    sha256 "9cf030d61a6cce1f47a62d4050f5e83e1bd1a1018ac671bb193aee07d15bdbc2"
  end

  resource "oslo-utils" do
    url "https:files.pythonhosted.orgpackages4bd0efe8943f8f4130708440870bb8f8167b16204b556fb94236554f4b213756oslo.utils-6.2.1.tar.gz"
    sha256 "1322ba05fa0ff3c1a8afc727fcf945df5aa82d6584727d2e04af038b5ae84244"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages4403158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages02d8acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackagese59bff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages61ef945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89dpyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages3be47dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070fpyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pydrive2" do
    url "https:files.pythonhosted.orgpackages9bf4ac87aa67907033a3f55bdee46ac6d2dccf9dc9df23235c1d4efa464b5e32PyDrive2-1.17.0.tar.gz"
    sha256 "68fea934347bb612b7a848811d48149db840bcfb5fa4d7a8b6161b2d2adfec70"
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
    url "https:files.pythonhosted.orgpackages3fff5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
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
    url "https:files.pythonhosted.orgpackages70e581f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420dtzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
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
    url "https:files.pythonhosted.orgpackagesf87d73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    venv.pip_install_and_link(buildpath, link_manpages: true)

    site_packages = Language::Python.site_packages("python3.12")
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