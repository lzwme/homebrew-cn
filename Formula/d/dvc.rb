class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https:dvc.org"
  url "https:files.pythonhosted.orgpackages9b26051261435dac8d583546a181eca0b0a84eb699b02d065318a9993554c513dvc-3.45.0.tar.gz"
  sha256 "3d3bb4868cd88cafe6829b046baf98611d8c0f77f08e2c271462e5ab2a7dab7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da708be9bdfed523f93ddd9440e00e286d9d8c4f21f05c5cfcf48097a384b147"
    sha256 cellar: :any,                 arm64_ventura:  "242ed0a1ab5afa3eab5167bfc51d7349a9ca6c0caf67c881f9a7085099e98e93"
    sha256 cellar: :any,                 arm64_monterey: "1af8d3dd6a7f0b258c6f8036b710ee88920c6a79ad468b07c4e947749db8d89b"
    sha256 cellar: :any,                 sonoma:         "510a661c101ecd7c4c924f17fb8a84488350cedc882a0661672f390f5b688820"
    sha256 cellar: :any,                 ventura:        "c816889cc3169fc199102cf90c247a31b74035ab3f9f8d25942c7c917ce20d4f"
    sha256 cellar: :any,                 monterey:       "83db8d4f8be8d06fab772be771828202d7bdee580d65919c55911984e59932ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb08271922b4a46546ea6948651a21e28ac2c09e9c1bc4cd5112820fc612b2e"
  end

  depends_on "openjdk" => :build # for hydra-core
  depends_on "rust" => :build # for bcrypt
  depends_on "apache-arrow"
  depends_on "cffi"
  depends_on "numpy"
  depends_on "protobuf"
  depends_on "pycparser"
  depends_on "pygit2"
  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-pyparsing"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adlfs" do
    url "https:files.pythonhosted.orgpackages8bd06b9e786f870dcdc5a5765f6ae46579913aef8d7aed72a190fab7a51164c6adlfs-2024.2.0.tar.gz"
    sha256 "860f5ddbd7f3c2553d84a101717dc5736e823305e0d51e8c0058bc85a7fa304d"
  end

  resource "aiobotocore" do
    url "https:files.pythonhosted.orgpackagesb5906f7b0ae33270ad58009d69b1b73e804b13d076389384d1bafe0d2580d360aiobotocore-2.11.2.tar.gz"
    sha256 "6dd7352248e3523019c5a54a395d2b1c31080697fc80a9ad2672de4eec8c7abd"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages18931f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258baiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
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
    url "https:files.pythonhosted.orgpackagesc4413eb8126661844a4d507fbfec92d26101a5191b1e1e7388f53f8ccf1f9577aiooss2-0.2.9.tar.gz"
    sha256 "aa1ab2526bfbe320604228e08a2d1eb4b0cb3a4e8b92a5353df820fa30f4656a"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aliyun-python-sdk-core" do
    url "https:files.pythonhosted.orgpackages1ee38623c0305022610466ded2b0010a7221e9585046116263dd27cb2e56df36aliyun-python-sdk-core-2.14.0.tar.gz"
    sha256 "c806815a48ffdb894cc5bce15b8259b9a3012cc0cda01be2f3dfbb844f3f4f21"
  end

  resource "aliyun-python-sdk-kms" do
    url "https:files.pythonhosted.orgpackagescb87f0004243da50bb102715fdc92e2fbff92b039bfbd16400c57a7dba572308aliyun-python-sdk-kms-2.16.2.tar.gz"
    sha256 "f87234a8b64d457ca2338f87650db18a3ce7f7dbc9bfef71efe8f2894aded3d6"
  end

  resource "amqp" do
    url "https:files.pythonhosted.orgpackages322c6eb09fbdeb3c060b37bd33f8873832897a83e7a428afe01aad333fc405ecamqp-5.2.0.tar.gz"
    sha256 "a1ecff425ad063ad42a486c902807d1482311481c8ad95a72694b2975e75f7fd"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "antlr4-python3-runtime" do
    url "https:files.pythonhosted.orgpackages3e387859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5eantlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages2db87333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "asyncssh" do
    url "https:files.pythonhosted.orgpackages6cf9849f158fe50cdb0b1bf75009861865c9a30c3b5a0d62ad43bb5e00b10febasyncssh-2.14.2.tar.gz"
    sha256 "e956bf8988d07a06ba3305f6604e261f4ca014c4a232f0873f1c7692fbe3cfc2"
  end

  resource "atpublic" do
    url "https:files.pythonhosted.orgpackages4fc822e1e6e2fe2cbe7a789a30d6288db3c1dbdbbe06af0d61277a97e4960b9eatpublic-4.0.tar.gz"
    sha256 "0f40433219e124edf115c6c363808ca6f0e1cfa7d160d86b2fb94793086d1294"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackagesb138ecb085532b46ca3893732d2dafa8b75a1754164b1c0e757e7c53c4250714azure-core-1.30.0.tar.gz"
    sha256 "6f3a7883ef184722f6bd997262eddaf80cfe7e5b3e0caaaf8db1695695893d35"
  end

  resource "azure-datalake-store" do
    url "https:files.pythonhosted.orgpackages22ff61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackages7402a0545eaa3fb83a6b6c413de4a65e06a02ce887f874a2e74a1240b2169140azure-identity-1.15.0.tar.gz"
    sha256 "4c28fc246b7f9265610eb5261d65931183d019a23d4b0e99357facb2e6c227c8"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackagesfdf859c209132b3b2993402df6b7e79728726927b53168624e917cd9daaffea8azure-storage-blob-12.19.0.tar.gz"
    sha256 "26c0a4320a34a3c2a1b74528ba6812ebcb632a04cd67b1c7377232c4b01a5897"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages72076a6f2047a9dc9d012b7b977e4041d37d078b76b44b7ee4daf331c1e6fb35bcrypt-4.1.2.tar.gz"
    sha256 "33313a1200a3ae90b75587ceac502b048b840fc69e7f7a0905b5f87fac7a1258"
  end

  resource "billiard" do
    url "https:files.pythonhosted.orgpackages0952f10d74fd56e73b430c37417658158ad8386202b069b70ff97d945c3ab67abilliard-4.2.0.tar.gz"
    sha256 "9a3c3184cb275aa17a732f93f65b20c525d3d9f253722d26a82194803ade5a2c"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages50a0f332de5bc770ddbcbddc244a9ced5476ac2d105a14fbd867c62f702a73eeboto3-1.34.34.tar.gz"
    sha256 "b2f321e20966f021ec800b7f2c01287a3dd04fc5965acdfbaa9c505a24ca45d1"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages1858b38387dda6dae1db663c716f7184a728941367d039830a073a30c3a28d3cbotocore-1.34.34.tar.gz"
    sha256 "54093dc97372bb7683f5c61a279aa8240408abf3b2cc494ae82a9a90c1b784b5"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages10211b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "celery" do
    url "https:files.pythonhosted.orgpackages997245a2d2f9b45ccc6e80e2168ce169d17bf06a98711c192d7b53d5a8accf77celery-5.3.6.tar.gz"
    sha256 "870cc71d737c0200c397290d730344cc991d13a057534353d124c9380267aab9"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click-didyoumean" do
    url "https:files.pythonhosted.orgpackages2fa7822fbc659be70dcb75a91fb91fec718b653326697d0e9907f4f90114b34fclick-didyoumean-0.3.0.tar.gz"
    sha256 "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035"
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
    url "https:files.pythonhosted.orgpackages0a81044f03129b6006fc594654bb26c22a9417346037261c767ac6e0773ca1dddpath-2.1.6.tar.gz"
    sha256 "f1e07c72e8605c6a9e80b64bc8f42714de08a789c7de417e49c3f87a19692e47"
  end

  resource "dulwich" do
    url "https:files.pythonhosted.orgpackages2be2788910715b4910d08725d480278f625e315c3c011eb74b093213363042e0dulwich-0.21.7.tar.gz"
    sha256 "a9e9c66833cea580c3ac12927e4b9711985d76afca98da971405d414de60e968"
  end

  resource "dvc-azure" do
    url "https:files.pythonhosted.orgpackagesb1cd5cf47247c82e7b8eba42890a23e6700f4baade329d24722140d290c32dc3dvc-azure-3.1.0.tar.gz"
    sha256 "52cbc70d5414b50219b3db0a16f68ad25daba76e3f220aebe4e49b3c6498ae20"
  end

  resource "dvc-data" do
    url "https:files.pythonhosted.orgpackages7b34db82dcf518636c3b325629ae51864f55c14a017317de803d05b0a581531cdvc-data-3.13.0.tar.gz"
    sha256 "692850b771bc1cffd1908463037797dd6ea5091750925ad9b915a4cc24bee3b9"
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
    url "https:files.pythonhosted.orgpackagesec74ea4e47ba3cff55fe873963eb0e0113edc55b1b0295f3dbd2e048cb1c469cdvc-objects-5.0.0.tar.gz"
    sha256 "2b008d972acbac797e6290c529627e74d257935d7870da20f7da091c74027014"
  end

  resource "dvc-oss" do
    url "https:files.pythonhosted.orgpackagesc23208789c1aa80da525fd7bd0fbef4c11431aabf32cc9446e28a589daf9fa2edvc-oss-3.0.0.tar.gz"
    sha256 "1047f734022fcd2b96d32b06bf6e0921cd0a65810f7fc1e9b0fac29a147b6a9a"
  end

  resource "dvc-render" do
    url "https:files.pythonhosted.orgpackagesa0b9e0bac130955611d6c1ec19f135b50905759127718b6e6a8b0aefd819e600dvc-render-1.0.1.tar.gz"
    sha256 "d7296869ea64c18ead9c99c46062ff116503b77a8d6e5c988f2d24716ea01d4a"
  end

  resource "dvc-s3" do
    url "https:files.pythonhosted.orgpackages89a5fd9057fe138bedaaab8ef5b8613a915dbd8e8f123f81de5044d3ecd70199dvc-s3-3.0.1.tar.gz"
    sha256 "6b1d96b237efbb886817df5e0cf4f6b1b161977d30b98b46744a276020a424c6"
  end

  resource "dvc-ssh" do
    url "https:files.pythonhosted.orgpackages36457f2f9ce55fd5b583696148153505fd131d32863ae215a483202f8f719ea1dvc-ssh-4.0.0.tar.gz"
    sha256 "59a59ca162976ae347651143b7e327aa91568f1cf26bec80a344d13505115620"
  end

  resource "dvc-studio-client" do
    url "https:files.pythonhosted.orgpackages1eab4b8e4f6ae7a2592ba2f35b2f1a8a94e4faca9a7ea325405a5367bc1cdd12dvc-studio-client-0.19.0.tar.gz"
    sha256 "bd4d9c07d2347c689dcc882e26dae633fd5fe75120e2b89637d6c88a077bded0"
  end

  resource "dvc-task" do
    url "https:files.pythonhosted.orgpackages0270a65126b40d43b9c53406d88a95d5e2b32083453f4739ea2bb854ba4b87c1dvc-task-0.3.0.tar.gz"
    sha256 "6ab288bfbbc4a2df8ef145c543bb979d6cb8fb49037fec821a59ad6e1dfdddce"
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
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
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
    url "https:files.pythonhosted.orgpackages28d3c2e0403c735548abf991bba3f45ba39194dff4569f76a99fbe77078ba7c5fsspec-2024.2.0.tar.gz"
    sha256 "b6ad1a679f760dda52b1168c859d01b7b80648ea6f7f7c7f5a8a91dc3f3ecb84"
  end

  resource "funcy" do
    url "https:files.pythonhosted.orgpackages70b8c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https:files.pythonhosted.orgpackages53ef4d68b78fb50e5f28494fede47d58381ec7939fa33e11544939afe11a41a1gcsfs-2024.2.0.tar.gz"
    sha256 "f7cffd7cae2fb50c56ef883f8aef9792be045b5059f06c1902c3a6151509f506"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackages8f1271a40ffce4aae431c69c45a191e5f03aca2304639264faf5666c2767acc4GitPython-3.1.42.tar.gz"
    sha256 "2d99869e0fef71a73cbd242528105af1d6c1b108c60dfabd994bf292f76c3ceb"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages58e2c2ce7bf379a7200ecab7de2cbf17dcbb3fe2ab5085925dfe6797e263a475google-api-core-2.17.1.tar.gz"
    sha256 "9df18a1f87ee0df0bc4eea2770ebc4228392d8cc4066655b320e2cfccb15db95"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackagese46c6258d89feb950462d44a868b0aa58034f5cd00a10bd99fc1f379ef9494fbgoogle-api-python-client-2.118.0.tar.gz"
    sha256 "ebf4927a3f5184096647be8f705d090e7f06d48ad82b0fa431a2fe80c2cbe182"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages221d65514adf8e2fc3546f4fc7025afe00828597eb98c414ef3327867dc263c6google-auth-2.28.0.tar.gz"
    sha256 "3cfc1b6e4e64797584fb53fc9bd0b7afa9b7c0dba2004fa7dcc9349e58cc3195"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackages44777433818d44cadd1964473b1d9ab5ecea36e6f951cf2b5188e08f7ebd5dabgoogle-auth-oauthlib-1.2.0.tar.gz"
    sha256 "292d2d3783349f2b0734a0a0207b1e1e322ac193c2c09d8f7c613fb7cc501ea8"
  end

  resource "google-cloud-core" do
    url "https:files.pythonhosted.orgpackagesb81f9d1e0ba6919668608570418a9a51e47070ac15aeff64261fb092d8be94c0google-cloud-core-2.4.1.tar.gz"
    sha256 "9b7749272a812bde58fff28868d0c5e2f585b82f37e09a1f6ed2d4d10f134073"
  end

  resource "google-cloud-storage" do
    url "https:files.pythonhosted.orgpackages1688fc34f8c177ad56408d42f4b54c10402366d309737fae206d59fa16a4a27agoogle-cloud-storage-2.14.0.tar.gz"
    sha256 "2d23fcf59b55e7b45336729c148bb1c464468c69d5efbaee30f7201dd90eb97e"
  end

  resource "google-crc32c" do
    url "https:files.pythonhosted.orgpackagesd3a54bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https:files.pythonhosted.orgpackagesc178638c9ab69571db4f7ec022383ce13ff8d0cea5b8afc168a51bb0e9353c10google-resumable-media-2.7.0.tar.gz"
    sha256 "5f18f5fa9836f4b083162064a1c2c98c17239bfda9ca50ad970ccf905f3e625b"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages4a5feb12d721b45d20a977289d674e179995a0ddab1684d2c61b29a63d43a5f1googleapis-common-protos-1.62.0.tar.gz"
    sha256 "83f0ece9f94e5672cced82f592d2a5edf527a96ed1794f0bab36d5735c996277"
  end

  resource "grandalf" do
    url "https:files.pythonhosted.orgpackages950e4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "gto" do
    url "https:files.pythonhosted.orgpackages39765a8e524dc76d90ce00b82b59bb615fe151caf7d85c0ecb66276429242518gto-1.7.0.tar.gz"
    sha256 "363511279f5d8d19f8df7ff78299104579fd1d3efd1ea3d1fe3e689770798d03"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages94f147528a2f465b09c71caad95f5de1d7225e438cf3d1068d278362a4a6bc6ahttpcore-1.0.3.tar.gz"
    sha256 "5c0f9546ad17dac4d0772b0808856eb616eb8b48ce94f49ed819fd6982a8a544"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesbd262dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "hydra-core" do
    url "https:files.pythonhosted.orgpackages6d8e07e42bc434a847154083b315779b0a81d567154504624e181caf2c71cd98hydra-core-1.3.2.tar.gz"
    sha256 "8a878ed67216997c3e9d88a8e72e7b4767e81af37afb4ea3334b269a4390a824"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https:files.pythonhosted.orgpackages55610b91085837d446570ea12f63f79463e5a74b449956b1ca9d1946a6f584c2kombu-5.3.5.tar.gz"
    sha256 "30e470f1a6b49c70dc6f6d13c3e4cc4e178aa6c469ceb6bcd55645385fc84b93"
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
    url "https:files.pythonhosted.orgpackagesbb45c4dfbe24dd546d141287fa26476ce3206d461d8e4a24be77c84b835e647dmsal-1.26.0.tar.gz"
    sha256 "224756079fe338be838737682b49f8ebc20a87c1c5eeaf590daae4532b83de15"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackagescbba618771542cdc4bc5314c395076c397d67e2bdcd88564c6ca712a2497d1c6msal-extensions-1.1.0.tar.gz"
    sha256 "6ab357867062db7b253d0bd2df6d411c7891a0ee7308d54d1e4317c1d1c54252"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesc480a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3canetworkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
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
    url "https:files.pythonhosted.orgpackagesbb924280f93e3e1826b57a34a12de1b4a9d68bd850a34f528954c1cea0f49b14orjson-3.9.14.tar.gz"
    sha256 "06fb40f8e49088ecaa02f1162581d39e2cf3fd9dbbfe411eb2284147c99bad79"
  end

  resource "oss2" do
    url "https:files.pythonhosted.orgpackages4ae708b90651a435acde68c537eebff970011422f61c465f6d1c88c4b3af6774oss2-2.18.1.tar.gz"
    sha256 "5a901f6c0f3ac42f792e16a1e1c04e60f34e6cc9eb2bc4c0c3ce6e7bda2da4cc"
  end

  resource "ossfs" do
    url "https:files.pythonhosted.orgpackagesd2424cdce6e1ff4ce53c33cdc0dc1d212207181af3037d0a3a789367da42a266ossfs-2023.12.0.tar.gz"
    sha256 "f99eb2d74717d22551b1f32ec9434587962627a816a64536dc47d68470536110"
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
    url "https:files.pythonhosted.orgpackages35000f230921ba852226275762ea3974b87eeca36e941a13cd691ed296d279e5portalocker-2.8.2.tar.gz"
    sha256 "2b035aa7828e46c58e9b31390ee1f169b98e1066ab10b9a6a861fe7e25ee4f33"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagescedc996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages3be47dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070fpyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages7327a17cc261bb974e929aa3b3365577e43c1c71c3dcd8669250613a7135cb8fpydantic-2.6.1.tar.gz"
    sha256 "4fd5c182a2488dc63e6d32737ff19937888001e2a6d86e94b3f233104a5d1fa9"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages0d7264550ef171432f97d046118a9869ad774925c2f442589d5f6164b8288e85pydantic_core-2.16.2.tar.gz"
    sha256 "0ba503850d8b8dcc18391f10de896ae51d37fe5fe43dbfb6a35c5c5cad271a06"
  end

  resource "pydot" do
    url "https:files.pythonhosted.orgpackagesd72f482fcbc389e180e7f8d7e7cb06bc5a7c37be6c57939dfb950951d97f2722pydot-2.0.0.tar.gz"
    sha256 "60246af215123fa062f21cd791be67dda23a6f280df09f68919e637a1e4f3235"
  end

  resource "pydrive2" do
    url "https:files.pythonhosted.orgpackagesbd37f256fce47c0bd63af9e8c63253e144f26e22ad5969dc83dfa59282ff11cbPyDrive2-1.19.0.tar.gz"
    sha256 "21aea7da27635c2c3f7050e020206191f3b0305c6550315e6e8e3dd526f8b531"
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
    url "https:files.pythonhosted.orgpackageseb81022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577dpyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages9552531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49frequests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
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
    url "https:files.pythonhosted.orgpackages20cda19cde20bb132dcef0bb50a3cfe1edadbb1dee8a8b936e725280aada0bbfs3fs-2024.2.0.tar.gz"
    sha256 "f8064f522ad088b56b043047c825734847c0269df19f2613c956d4c20de15b62"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "scmrepo" do
    url "https:files.pythonhosted.orgpackages9a8fe78c145db2acce1f06aef753b9495f6affd804b7fd1e73935021c9cdacbescmrepo-3.1.0.tar.gz"
    sha256 "9b91f3afe52cfe5707d7b4d4af9ff0403a4200152d2a4ea1388b325071ded8a9"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "shortuuid" do
    url "https:files.pythonhosted.orgpackages1ec6ba2dd56e3996a1919984645ca0aaf20c4879cc1227c50a4be08f52b19ad0shortuuid-1.0.11.tar.gz"
    sha256 "fc75f2615914815a8e4cb1501b3a513745cb66ef0fd5fc6fb9f8c3fa3481f789"
  end

  resource "shtab" do
    url "https:files.pythonhosted.orgpackages140ece211daf7b28fe685b1c9a21d943b3a1c4f300a07e6c59d8765c5f22eb06shtab-1.6.5.tar.gz"
    sha256 "cf4ab120183e84cce041abeb6f620f9560739741dfc31dd466315550c08be9ec"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sqltrie" do
    url "https:files.pythonhosted.orgpackages129877359c328ee9bf71bb1cc444a15c394a98aeaa38860c41f655117cc888b0sqltrie-0.11.0.tar.gz"
    sha256 "e613a74843e2b55ce1d20d333100d6a41127a1d6c12f835915f58fbd13944a82"
  end

  resource "sshfs" do
    url "https:files.pythonhosted.orgpackages90b92c6a1238d70ba1bc6487b92ec5f3eba9a905ff34da31dab15e419d57e32csshfs-2023.10.0.tar.gz"
    sha256 "8f63f83dd05511552f3ac9590212888dff70dfd43645615b5c030190d2fe3a2b"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesdffc1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackages5b4939f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
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

  resource "vine" do
    url "https:files.pythonhosted.orgpackagesbde4d07b5f29d283596b9727dd5275ccbceb63c44a1a82aa9e4bfd20426762acvine-5.1.0.tar.gz"
    sha256 "8b62e981d35c41049211cf62a0a1242d8c1ee9bd15bb196ce38aefd6799e61e0"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackagesa1ce0733e4d6f870a0e5f4dbb00766b36b71ee0d25f8de33d27fb662f29154b1voluptuous-0.14.2.tar.gz"
    sha256 "533e36175967a310f1b73170d091232bf881403e4ebe52a9b4ade8404d151f5d"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webdav4" do
    url "https:files.pythonhosted.orgpackagesbecc172a99d6bee59597063e8a920ca5c7aeeced8f624453110490deba46819bwebdav4-0.9.8.tar.gz"
    sha256 "fc7748df33a375de13ddb5f4594f5799f9f3dc13c005b7b9c45c120aad745694"
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