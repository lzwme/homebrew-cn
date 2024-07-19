class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https:dvc.org"
  url "https:files.pythonhosted.orgpackages554f4bf3dabe2929073ca50f9318fa678b1413816f3d1c2ca36f9d9bd67a87a3dvc-3.51.2.tar.gz"
  sha256 "bc714b727e02f4702e79346933fbed8a6409da6ec1bef7b51416af741fc6aa13"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7250fd56a6c5a09fa351935f8ec40493b05cb29fef07dc50411da3a07753b539"
    sha256 cellar: :any,                 arm64_ventura:  "f314959b691c381770ce416f2f625b2c1187e8cf4642e9c368e18971efb46594"
    sha256 cellar: :any,                 arm64_monterey: "eff4e8b9ead1ee9f91dd29a7f55b77555c63bdbcc39816f574cac0df3affa707"
    sha256 cellar: :any,                 sonoma:         "df8f88f714fe6c05cfc80dc8bd0e6ea63dd70f57091913512865c2744e349c20"
    sha256 cellar: :any,                 ventura:        "8a0e88463aa1db7f55e426119aa3555399eebfe7d86d0eb61e422681d922187c"
    sha256 cellar: :any,                 monterey:       "febcf5a972a1effd1d58a6305a659a54a098fd21b42f0a0332321897791da876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27257571923333fbe22958d3189cb5f4753a98459ca5bffbacf1b5659b25504a"
  end

  depends_on "cmake" => :build # for pyarrow
  depends_on "ninja" => :build # for pyarrow
  depends_on "openjdk" => :build # for hydra-core
  depends_on "rust" => :build # for bcrypt
  depends_on "apache-arrow"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.12"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  resource "adlfs" do
    url "https:files.pythonhosted.orgpackages98e06caa4d4848e81cd810f9ccc268b4fc9a71401f98a9b8feb536e3974daae7adlfs-2024.4.1.tar.gz"
    sha256 "75530a45447f358ae53c5c39c298b8d966dae684be84db899f63b94cd96fc000"
  end

  resource "aiobotocore" do
    url "https:files.pythonhosted.orgpackagescdd2d7e46bcc4c0b5b8e751092824d6ca9af5928adae0f864336e43c7f7a436aaiobotocore-2.13.1.tar.gz"
    sha256 "134f9606c2f91abde38cbc61c3241113e26ff244633e0c31abb7e09da3581c9b"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages04a4e3679773ea7eb5b37a2c998e25b017cc5349edf6ba2739d1f32855cfb11baiohttp-3.9.5.tar.gz"
    sha256 "edea7d15772ceeb29db4aff55e482d4bcfb6ae160ce144f2682de02f6d693551"
  end

  resource "aiohttp-retry" do
    url "https:files.pythonhosted.orgpackages01c1d57818a0ed5b0313ad8c620638225ddd44094d0d606ee33f3df5105572cdaiohttp_retry-2.8.3.tar.gz"
    sha256 "9a8e637e31682ad36e1ff9f8bcba912fcfc7d7041722bc901a4b948da4d71ea9"
  end

  resource "aioitertools" do
    url "https:files.pythonhosted.orgpackages4ae6888e1d726f0846c84e14a0f2f57873819eff9278b394d632aed979c98fbdaioitertools-0.11.0.tar.gz"
    sha256 "42c68b8dd3a69c2bf7f2233bf7df4bb58b557bca5252ac02ed5187bbc67d6831"
  end

  resource "aiooss2" do
    url "https:files.pythonhosted.orgpackages998163bc832d0ddf2ac5b61177343338ffb21d9ebd49964279a1bd83861b2844aiooss2-0.2.10.tar.gz"
    sha256 "65698a287386464e4a08fb862be85668df4d1e1acfe0620404617d88869630eb"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aliyun-python-sdk-core" do
    url "https:files.pythonhosted.orgpackages3ae6f579e8a5e26ef1066f6fb11074cedc9f668cb5f722c85cf7adc0f7e2e23ealiyun-python-sdk-core-2.15.1.tar.gz"
    sha256 "518550d07f537cd3afac3b6c93b5c997ce3440e4d0c054e3acbdaa8261e90adf"
  end

  resource "aliyun-python-sdk-kms" do
    url "https:files.pythonhosted.orgpackagesc5a6f958162647f2f581a5d767a5cf1b9e172183863559abfbe594face7141f7aliyun-python-sdk-kms-2.16.3.tar.gz"
    sha256 "c31b7d24e153271a3043e801e7b6b6b3f0db47e95a83c8d10cdab8c11662fc39"
  end

  resource "amqp" do
    url "https:files.pythonhosted.orgpackages322c6eb09fbdeb3c060b37bd33f8873832897a83e7a428afe01aad333fc405ecamqp-5.2.0.tar.gz"
    sha256 "a1ecff425ad063ad42a486c902807d1482311481c8ad95a72694b2975e75f7fd"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "antlr4-python3-runtime" do
    url "https:files.pythonhosted.orgpackages3e387859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5eantlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackagesdbca45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91fargcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  end

  resource "asyncssh" do
    url "https:files.pythonhosted.orgpackages9c0312850895815bc6d4d87e98030b016a20886343df4334681443db0234366easyncssh-2.15.0.tar.gz"
    sha256 "0a13a43816f46cf084657fb05596823b93d5b48e75ef7763c8a756ec1217837a"
  end

  resource "atpublic" do
    url "https:files.pythonhosted.orgpackagesae5b61439625efcd11dfa2f299d60183476f58a138020c2f9b6a4e46b0e74d78atpublic-4.1.0.tar.gz"
    sha256 "d1c8cd931af7461f6d18bc6063383e8654d9e9ef19d58ee6dc01e8515bbf55df"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackages99d41f469fa246f554b86fb5cebc30eef1b2a38b7af7a2c2791bce0a4c6e4604azure-core-1.30.2.tar.gz"
    sha256 "a14dc210efcd608821aa472d9fb8e8d035d29b68993819147bc290a8ac224472"
  end

  resource "azure-datalake-store" do
    url "https:files.pythonhosted.orgpackages22ff61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackages51c9f7e3926686a89670ce641b360bd2da9a2d7a12b3e532403462d99f81e9d5azure-identity-1.17.1.tar.gz"
    sha256 "32ecc67cc73f4bd0595e4f64b1ca65cd05186f4fe6f98ed2ae9f1aa32646efea"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackages1b0f86cdaec4be486d12fd5bd2c56e835492a58d3bcd4915d24473e889b70f2cazure-storage-blob-12.20.0.tar.gz"
    sha256 "eeb91256e41d4b5b9bad6a87fd0a8ade07dd58aa52344e2c8d2746e27a017d3b"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagescae90b36987abbcd8c9210c7b86673d88ff0a481b4610630710fb80ba5661356bcrypt-4.1.3.tar.gz"
    sha256 "2ee15dd749f5952fe3f0430d0ff6b74082e159c50332a1413d51b5689cf06623"
  end

  resource "billiard" do
    url "https:files.pythonhosted.orgpackages0952f10d74fd56e73b430c37417658158ad8386202b069b70ff97d945c3ab67abilliard-4.2.0.tar.gz"
    sha256 "9a3c3184cb275aa17a732f93f65b20c525d3d9f253722d26a82194803ade5a2c"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages1fd935978a20f6f9a585ff83afb384faf71526a1b25c4131755b1cdb6687b1d9boto3-1.34.131.tar.gz"
    sha256 "dab8f72a6c4e62b4fd70da09e08a6b2a65ea2115b27dd63737142005776ef216"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages414074bda5977985383b8ed403dced9d76ad5e1146db7b6c32089726b3130c8bbotocore-1.34.131.tar.gz"
    sha256 "502ddafe1d627fcf1e4c007c86454e5dd011dba7c58bd8e8a5368a79f3e387dc"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesb34d27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5bcachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "celery" do
    url "https:files.pythonhosted.orgpackages8a9ccf0bce2cc1c8971bf56629d8f180e4ca35612c7e79e6e432e785261a8be4celery-5.4.0.tar.gz"
    sha256 "504a19140e8d3029d5acad88330c541d4c3f64c789d85f94756762d8bca7e706"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-didyoumean" do
    url "https:files.pythonhosted.orgpackages30ce217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cbclick_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "click-repl" do
    url "https:files.pythonhosted.orgpackagescba257f4ac79838cfae6912f997b4d1a64a858fb0c86d7fcaae6f7b58d267fcaclick-repl-0.3.0.tar.gz"
    sha256 "17849c23dba3d667247dc4defe1757fff98694e90fe37474f3feebb69ced26a9"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagescb8717d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fbconfigobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "crcmod" do
    url "https:files.pythonhosted.orgpackages6bb0e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5bcrcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dictdiffer" do
    url "https:files.pythonhosted.orgpackages617b35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "diskcache" do
    url "https:files.pythonhosted.orgpackages3f211c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dpath" do
    url "https:files.pythonhosted.orgpackagesb5cee1fd64d36e4a5717bd5e6b2ad188f5eaa2e902fde871ea73a79875793fc9dpath-2.2.0.tar.gz"
    sha256 "34f7e630dc55ea3f219e555726f5da4b4b25f2200319c8e6902c394258dd6a3e"
  end

  resource "dulwich" do
    url "https:files.pythonhosted.orgpackagescfaccf6420b90832c4ffbc88b92962dd0167c58632c2b8d508d5baf4ecb0c61ddulwich-0.22.1.tar.gz"
    sha256 "e36d85967cfbf25da1c7bc3d6921adc5baa976969d926aaf1582bd5fd7e94758"
  end

  resource "dvc-azure" do
    url "https:files.pythonhosted.orgpackagesb1cd5cf47247c82e7b8eba42890a23e6700f4baade329d24722140d290c32dc3dvc-azure-3.1.0.tar.gz"
    sha256 "52cbc70d5414b50219b3db0a16f68ad25daba76e3f220aebe4e49b3c6498ae20"
  end

  resource "dvc-data" do
    url "https:files.pythonhosted.orgpackages31e2cd0168d9452ad19b2dda2eb24fc5c8339a172aa5783feb91bc45c430bca3dvc-data-3.15.1.tar.gz"
    sha256 "db141bbbcf9e1ff37d9ff8657d04747e804899b90b4931b120f5d21bbd401583"
  end

  resource "dvc-gdrive" do
    url "https:files.pythonhosted.orgpackagesb5ab278694dd93e8657d590408e37e440ead5ca809af6c265ca248df10942270dvc-gdrive-3.0.1.tar.gz"
    sha256 "ad7c9cd044083745150a57649eb4ef9240348f054bed5a8f8aa5f1820c6384ec"
  end

  resource "dvc-gs" do
    url "https:files.pythonhosted.orgpackages71587714c93a472f04613fee5714d847d1af7b1fabcca93784046cc07eb7b8d8dvc-gs-3.0.1.tar.gz"
    sha256 "e5430a297fb8182366f7c4bc910b1ab104d8e5cc22f611a19bce05165dffecd4"
  end

  resource "dvc-hdfs" do
    url "https:files.pythonhosted.orgpackageseab542a2a3b3897f6e7c0b77c1408ed27e472ffdf61c5a1fec91d396177da275dvc-hdfs-3.0.0.tar.gz"
    sha256 "286443cb2c107ad53e73d8d6c4af8524b6e3b6b88b1543c8bc0544738aeb9fee"
  end

  resource "dvc-http" do
    url "https:files.pythonhosted.orgpackages33e64fb38ab911a9d90fbe2c7759c430814fe2253760304a9de0d3ebd6e27c20dvc-http-2.32.0.tar.gz"
    sha256 "f714f8435634aab943c625f659ddac1188c6ddaf3ff161b39715b83ff39637fc"
  end

  resource "dvc-objects" do
    url "https:files.pythonhosted.orgpackagesf01822e1b3440ad2b1b6de864b10ef25e6e0069342524d2b592de40f0cb17e13dvc-objects-5.1.0.tar.gz"
    sha256 "22e919620f9ecf428a0d295efca8073d1c0e87206dd8e1f52b1d9520fa25b814"
  end

  resource "dvc-oss" do
    url "https:files.pythonhosted.orgpackagesc23208789c1aa80da525fd7bd0fbef4c11431aabf32cc9446e28a589daf9fa2edvc-oss-3.0.0.tar.gz"
    sha256 "1047f734022fcd2b96d32b06bf6e0921cd0a65810f7fc1e9b0fac29a147b6a9a"
  end

  resource "dvc-render" do
    url "https:files.pythonhosted.orgpackagesbe15605312dbdc0931547987ee25a9a3f6fcabf48ca1436039abcd524156b8e2dvc-render-1.0.2.tar.gz"
    sha256 "40d1cd81760daf34b48fa8362b5002fcbe415e3cdbcf42369b6347d01497ffc0"
  end

  resource "dvc-s3" do
    url "https:files.pythonhosted.orgpackagesfacf14e5f014f77381a58617c1ee3ae98f8fc15768e6a89ff0efac3ff7fc0016dvc_s3-3.2.0.tar.gz"
    sha256 "1d012ac1dce47659986f918123b48931cf9b3429ab0b4a22fd4b02448185ceb6"
  end

  resource "dvc-ssh" do
    url "https:files.pythonhosted.orgpackages1302ced97a5206110568a1360473d6416a71327155ae1b93d28b748da61c045fdvc-ssh-4.1.1.tar.gz"
    sha256 "96f0baa005d0478bbbb3ed759fa360404c4f73dcabab72409a65edb8ec36dad2"
  end

  resource "dvc-studio-client" do
    url "https:files.pythonhosted.orgpackages870813cf5bb8bf0855d47325467a5948848bcea51780e2212349034f5e4701e6dvc_studio_client-0.21.0.tar.gz"
    sha256 "db212ff5cf73dce886d0713a5d2bf4bc0bbfb499f3ca8548705ca98aab5addd1"
  end

  resource "dvc-task" do
    url "https:files.pythonhosted.orgpackages6718245fc0f1f47fc0a46a793af5359eaa4507bf375746d65fc3db6ad8b3b7b4dvc-task-0.4.0.tar.gz"
    sha256 "c0166626af9c0e932ba18194fbc57df38f22860fcc0fbd450dee14ef9615cd3c"
  end

  resource "dvc-webdav" do
    url "https:files.pythonhosted.orgpackages56207290e6bf073844970706db64109ab1fdad7038ff7a6df57dff3620170767dvc-webdav-3.0.0.tar.gz"
    sha256 "65e7eef2ebc83415a8ddbdcb579bf219a3797c67e7a62d4568c5c82de2b6a508"
  end

  resource "dvc-webhdfs" do
    url "https:files.pythonhosted.orgpackages36f5249f881b2e035d6c7362733986b5545fa8c88fed451972be5d0fedae5fabdvc-webhdfs-3.1.0.tar.gz"
    sha256 "6e894843d15ce766a05c616deda9d9bc361248e93bf9ea338b996e6e51ea0fea"
  end

  resource "entrypoints" do
    url "https:files.pythonhosted.orgpackagesea8da7121ffe5f402dc015277d2d31eb82d2187334503a011c18f2e78ecbb9b2entrypoints-0.4.tar.gz"
    sha256 "b706eddaa9218a19ebcd67b56818f05bb27589b1ca9e8d797b74affad4ccacd4"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages08dd49e06f09b6645156550fb9aee9cc1e59aba7efbc972d665a1bd6ae0435d4filelock-3.15.4.tar.gz"
    sha256 "2207938cbc1844345cb01a5a95524dae30f0ce089eba5b00378295a17e3e90cb"
  end

  resource "flatten-dict" do
    url "https:files.pythonhosted.orgpackages89c65fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl-lock" do
    url "https:files.pythonhosted.orgpackages3533d3baecd2545b9ae842f4df356aaa4a1816191eff737264542e9d27c5ec3bflufl.lock-7.1.1.tar.gz"
    sha256 "af14172b35bbc58687bd06b70d1693fd8d48cbf0ffde7e51a618c148ae24042d"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "fsspec" do
    url "https:files.pythonhosted.orgpackages90b6eba5024a9889fcfff396db543a34bef0ab9d002278f163129f9f01005960fsspec-2024.6.1.tar.gz"
    sha256 "fad7d7e209dd4c1208e3bbfda706620e0da5142bebbd9c384afb95b07e798e49"
  end

  resource "funcy" do
    url "https:files.pythonhosted.orgpackages70b8c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https:files.pythonhosted.orgpackages7fb1c5ae16ad1d499f0cf10e3306f717eadae30dba64ec29236077b8fe661e7cgcsfs-2024.6.1.tar.gz"
    sha256 "e8858c7a893b2265e9bfce2fe270a024a2e348c74c23528801db388fc0224ed7"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackagesc24142a127bf163d9bf1f21540a3bf41c69b231b88707d8d753680b8878201a6google-api-core-2.19.1.tar.gz"
    sha256 "f4695f1e3650b316a795108a76a1c416e6afb036199d1c1f1f110916df479ffd"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages78b6ce62a006e9df3ba9ef4e1dfec0bee97f426ed0cdd05f1220740c267588b0google_api_python_client-2.137.0.tar.gz"
    sha256 "e739cb74aac8258b1886cb853b0722d47c81fe07ad649d7f2206f06530513c04"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages8ca3cc4dc2e8a7f67012a26dec5b6b1fdf5261b12e7d54981c88de2580315726google_auth-2.32.0.tar.gz"
    sha256 "49315be72c55a6a37d62819e3573f6b416aca00721f7e3e31a008d928bf64022"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackagescc0f1772edb8d75ecf6280f1c7f51cbcebe274e8b17878b382f63738fd96cee5google_auth_oauthlib-1.2.1.tar.gz"
    sha256 "afd0cad092a2eaa53cd8e8298557d6de1034c6cb4a740500b5357b648af97263"
  end

  resource "google-cloud-core" do
    url "https:files.pythonhosted.orgpackagesb81f9d1e0ba6919668608570418a9a51e47070ac15aeff64261fb092d8be94c0google-cloud-core-2.4.1.tar.gz"
    sha256 "9b7749272a812bde58fff28868d0c5e2f585b82f37e09a1f6ed2d4d10f134073"
  end

  resource "google-cloud-storage" do
    url "https:files.pythonhosted.orgpackages1df90096c3f32ee6087da902d8e450639f3659371052301cc8d5587f5fb288fegoogle-cloud-storage-2.17.0.tar.gz"
    sha256 "49378abff54ef656b52dca5ef0f2eba9aa83dc2b2c72c78714b03a1a95fe9388"
  end

  resource "google-crc32c" do
    url "https:files.pythonhosted.orgpackagesd3a54bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https:files.pythonhosted.orgpackagesd63dd51e8c691d24e08cbf5b1924a4f950c492d44f7e3ccbacf362f1de04ce2bgoogle-resumable-media-2.7.1.tar.gz"
    sha256 "eae451a7b2e2cdbaaa0fd2eb00cc8a1ee5e95e16b55597359cbc3d27d7d90e33"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages0b1a41723ae380fa9c561cbe7b61c4eef9091d5fe95486465ccfc84845877331googleapis-common-protos-1.63.2.tar.gz"
    sha256 "27c5abdffc4911f28101e635de1533fb4cfd2c37fbaa9174587c799fac90aa87"
  end

  resource "grandalf" do
    url "https:files.pythonhosted.orgpackages950e4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "gto" do
    url "https:files.pythonhosted.orgpackages4c5f1c49a78fef3e040457b4195c4d7d9c315dde8bde134c0d91e9a180e1af57gto-1.7.1.tar.gz"
    sha256 "24100e735195c0d54539401f42804fc9042998276cdc4233f49f153fd38a7d75"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages17b05e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages5c2d3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "hydra-core" do
    url "https:files.pythonhosted.orgpackages6d8e07e42bc434a847154083b315779b0a81d567154504624e181caf2c71cd98hydra-core-1.3.2.tar.gz"
    sha256 "8a878ed67216997c3e9d88a8e72e7b4767e81af37afb4ea3334b269a4390a824"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackagesdb7ac0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1afisodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "iterative-telemetry" do
    url "https:files.pythonhosted.orgpackages32c10a2cdac1256bc1f8afde8a97be8d461036e8c09957b134bdd292eac6c18fiterative-telemetry-0.0.8.tar.gz"
    sha256 "5bed9d19109c892cff2a4712a2fb18ad727079a7ab260a28b1e2f6934eec652d"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages3c563f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https:files.pythonhosted.orgpackages0c5b7cc69b2941a11bdace4faffef8f023543feefd14ab0222b6e62a318c53b9knack-0.11.0.tar.gz"
    sha256 "eb6568001e9110b1b320941431c51033d104cc98cda2254a5c2b09ba569fd494"
  end

  resource "kombu" do
    url "https:files.pythonhosted.orgpackages993a2fb09708fef243e35c286414f2bf78543dc311ae7d3de5d343bd8437e38dkombu-5.3.7.tar.gz"
    sha256 "011c4cd9a355c14a1de8d35d257314a1d2456d52b7140388561acac3cf1a97bf"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https:files.pythonhosted.orgpackages39d8438af3c52f48bab135edbd47f24447c4985ec81c122ebf36e027621f6742msal-1.29.0.tar.gz"
    sha256 "8f6725f099752553f9b2fe84125e2a5ebe47b49f92eacca33ebedd3a9ebaae25"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackages2d38ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5ebmsal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages04e6b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ecnetworkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "oauth2client" do
    url "https:files.pythonhosted.orgpackagesa67b17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "omegaconf" do
    url "https:files.pythonhosted.orgpackages09486388f1bb9da707110532cb70ec4d2822858ddfb44f1cdf1233c20a80ea4bomegaconf-2.3.0.tar.gz"
    sha256 "d5d4b6d29955cc50ad50c46dc269bcd92c6e00f5f90d23ab5fee7bfca4ba4cc7"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages70248be1c9f6d21e3c510c441d6cbb6f3a75f2538b42a45f0c17ffb2182882f1orjson-3.10.6.tar.gz"
    sha256 "e54b63d0a7c6c54a5f5f726bc93a2078111ef060fec4ecbf34c5db800ca3b3a7"
  end

  resource "oss2" do
    url "https:files.pythonhosted.orgpackages4ae708b90651a435acde68c537eebff970011422f61c465f6d1c88c4b3af6774oss2-2.18.1.tar.gz"
    sha256 "5a901f6c0f3ac42f792e16a1e1c04e60f34e6cc9eb2bc4c0c3ce6e7bda2da4cc"
  end

  resource "ossfs" do
    url "https:files.pythonhosted.orgpackagesd2424cdce6e1ff4ce53c33cdc0dc1d212207181af3037d0a3a789367da42a266ossfs-2023.12.0.tar.gz"
    sha256 "f99eb2d74717d22551b1f32ec9434587962627a816a64536dc47d68470536110"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesd3e3aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "portalocker" do
    url "https:files.pythonhosted.orgpackagesedd3c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages476d0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879fprompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackages3efce9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages71a5d61e4263e62e6db1990c120d682870e5c50a30fb6b26119a214c7a014847protobuf-5.27.2.tar.gz"
    sha256 "f3ecdef226b9af856075f28227ff2c90ce3a594d092c39bee5513573f25e2714"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages18c78c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pyarrow" do
    url "https:files.pythonhosted.orgpackages1af267533f116deb6dae7a0ac04681695fe06135912253a115c5ecdc714a32d4pyarrow-16.1.0.tar.gz"
    sha256 "15fbb22ea96d11f0b5768504a3f961edab25eaf4197c341720c4a387f6c60315"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages8c99d0a5dca411e0a017762258013ba9905cd6e7baa9a3fd1fe8b6529472902epydantic-2.8.2.tar.gz"
    sha256 "6f62c13d067b0755ad1c21a34bdd06c0c12625a22b0fc09c6b149816604f7c2a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages12e30d5ad91211dba310f7ded335f4dad871172b9cc9ce204f5a56d76ccd6247pydantic_core-2.20.1.tar.gz"
    sha256 "26ca695eeee5f9f1aeeb211ffc12f10bcb6f71e2989988fda61dabd65db878d4"
  end

  resource "pydot" do
    url "https:files.pythonhosted.orgpackagesd72f482fcbc389e180e7f8d7e7cb06bc5a7c37be6c57939dfb950951d97f2722pydot-2.0.0.tar.gz"
    sha256 "60246af215123fa062f21cd791be67dda23a6f280df09f68919e637a1e4f3235"
  end

  resource "pydrive2" do
    url "https:files.pythonhosted.orgpackagesbd37f256fce47c0bd63af9e8c63253e144f26e22ad5969dc83dfa59282ff11cbPyDrive2-1.19.0.tar.gz"
    sha256 "21aea7da27635c2c3f7050e020206191f3b0305c6550315e6e8e3dd526f8b531"
  end

  resource "pygit2" do
    url "https:files.pythonhosted.orgpackages5377d33e2c619478d0daea4a50f9ffdd588db2ca55817c7e9a6c796fca3b80efpygit2-1.15.1.tar.gz"
    sha256 "e1fe8b85053d9713043c81eccc74132f9e5b603f209e80733d7955eafd22eb9d"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pygtrie" do
    url "https:files.pythonhosted.orgpackagesb91355deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5fpygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages91a8cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3fs" do
    url "https:files.pythonhosted.orgpackages694e9e32f7e5c37f42ff1b14b40eae260303a20f5bb4b518ec1bc9787bc6aa23s3fs-2024.6.1.tar.gz"
    sha256 "6c2106d6c34fbfbb88e3d20c6f3572896d5ee3d3512896696301c21a3c541bea"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "scmrepo" do
    url "https:files.pythonhosted.orgpackages043379d31493f32dc4928a6ff9ea5c1957046b0554b5584d24625d9924afa03ascmrepo-3.3.6.tar.gz"
    sha256 "ede18a83d05f73bf4f7921980fe5f8f7bf9b0fa44da17e240a8b743b0ba71893"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages65d810a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "shortuuid" do
    url "https:files.pythonhosted.orgpackages8ce2bcf761f3bff95856203f9559baf3741c416071dd200c0fc19fad7f078f86shortuuid-1.0.13.tar.gz"
    sha256 "3bb9cf07f606260584b1df46399c0b87dd84773e7b25912b7e391e30797c5e72"
  end

  resource "shtab" do
    url "https:files.pythonhosted.orgpackagesa9e413bf30c7c30ab86a7bc4104b1c943ff2f56c1a07c6d82a71ad034bcef1dcshtab-1.7.1.tar.gz"
    sha256 "4e4bcb02eeb82ec45920a5d0add92eac9c9b63b2804c9196c1f1fdc2d039243c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqltrie" do
    url "https:files.pythonhosted.orgpackages129877359c328ee9bf71bb1cc444a15c394a98aeaa38860c41f655117cc888b0sqltrie-0.11.0.tar.gz"
    sha256 "e613a74843e2b55ce1d20d333100d6a41127a1d6c12f835915f58fbd13944a82"
  end

  resource "sshfs" do
    url "https:files.pythonhosted.orgpackages9fbae03527a2d742a702f6a54b023cfff6ca42fb3aef26c2546ad88fc752dfe1sshfs-2024.6.0.tar.gz"
    sha256 "59c58835986e89dc781b4e5f027d2a48da1763ffc8126c4b36078feab6074580"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages4b34f5f4fbc6b329c948a90468dd423aaa3c3bfc1e07d5a76deec269110f2f6etomlkit-0.13.0.tar.gz"
    sha256 "08ad192699734149f5b97b45f1f18dad7eb1b6d16bc72ad0c2335772650d7b72"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages5ac0b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagesac0ad55af35db5f50f486e3eda0ada747eed773859e2699d3ce570b682a9b70atyper-0.12.3.tar.gz"
    sha256 "49e73131481d804288ef62598d97a1ceef3058905aa536a1134f90891ba35482"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "vine" do
    url "https:files.pythonhosted.orgpackagesbde4d07b5f29d283596b9727dd5275ccbceb63c44a1a82aa9e4bfd20426762acvine-5.1.0.tar.gz"
    sha256 "8b62e981d35c41049211cf62a0a1242d8c1ee9bd15bb196ce38aefd6799e61e0"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackages91afa54ce0fb6f1d867e0b9f0efe5f082a691f51ccf705188fca67a3ecefd7f4voluptuous-0.15.2.tar.gz"
    sha256 "6ffcab32c4d3230b4d2af3a577c87e1908a714a11f6f95570456b1849b0279aa"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webdav4" do
    url "https:files.pythonhosted.orgpackages083dd604f9d5195689e578f124f196a5d7e80f3106c8404f5c19b2181691de19webdav4-0.10.0.tar.gz"
    sha256 "387da6f0ee384e77149dddd9bcfd434afa155882f6c440a529a7cb458624407f"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  resource "zc-lockfile" do
    url "https:files.pythonhosted.orgpackages5b83a5432aa08312fc834ea594473385c005525e6a80d768a2ad246e78877afdzc.lockfile-3.0.post1.tar.gz"
    sha256 "adb2ee6d9e6a2333c91178dcb2c9b96a5744c78edb7712dc784a7d75648e81ec"
  end

  def install
    if DevelopmentTools.clang_build_version >= 1500
      # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
      # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types"

      # Work around an Xcode 15 linker issue which causes linkage against LLVM's
      # libunwind due to it being present in a library search path.
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    end

    # dvc-hdfs uses fsspec.implementations.arrow.HadoopFileSystem which is
    # a wrapper on top of pyarrow.fs.HadoopFileSystem.
    ENV["PYARROW_WITH_HDFS"] = "1"

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https:github.comiterativedvcblob3.0.0scriptsbuild.py#L23
    File.write("dvc_build.py", "PKG = \"brew\"")

    virtualenv_install_with_resources

    generate_completions_from_executable(bin"dvc", "completion", "-s", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}dvc doctor 2>&1")
    assert_match "gdrive", output
    assert_match "gs", output
    assert_match "http", output
    assert_match "https", output
    assert_match "oss", output
    assert_match "s3", output
    assert_match "ssh", output
    assert_match "webdav", output
    assert_match "webdavs", output
    assert_match "webhdfs", output
  end
end