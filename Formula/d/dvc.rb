class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https:dvc.org"
  url "https:files.pythonhosted.orgpackagesd72c6810082eb751ea50303346aa611ec74f22423e78dc4a62761538014c05dbdvc-3.36.1.tar.gz"
  sha256 "920bb66da21a8a0eccc805a984c4083beb5f156878f5276492de64e0c9c75b40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "703263e72b45bd1ab8b31c42e5154f1e305e3f996da1fd6c1f204abc7f3ddf25"
    sha256 cellar: :any,                 arm64_ventura:  "3b7f97d49edb6030537d6365f31d074462a0c1928ca1180e20bd9f088c96dc2e"
    sha256 cellar: :any,                 arm64_monterey: "70be2f674d14f4adc60691ad30a273c14b6012c0ebed5c2e502e66b9ad61da41"
    sha256 cellar: :any,                 sonoma:         "a2515ae1dc8b32ae611626f33b8189dd9dd4be67ac565fdcde3e8c1c36809554"
    sha256 cellar: :any,                 ventura:        "0483d6475a6f8dab121366e779dbb0a186e4046ae996df3031a55b5bec90c5ef"
    sha256 cellar: :any,                 monterey:       "cfe019a423f62a51f12921901d16c9963f725d1ea6c4d5045873cf0b1bb9d00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906dae01c8139d1efbc210343912a93a9ea087b0632ebbb6d66b0fe984a35858"
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
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adlfs" do
    url "https:files.pythonhosted.orgpackages565091e53e992040026ddd747698564669865718c1ab21b7bfce4791c0fb7b12adlfs-2023.12.0.tar.gz"
    sha256 "a590694ed9f5a45741e82bff8bcf88c30a790da949310817330b5e7992b8a9e9"
  end

  resource "aiobotocore" do
    url "https:files.pythonhosted.orgpackages7bea5ee4b3d4dd6d6f7debc5aece4714915b0d3cd1988fb423151bf10d7ae5ceaiobotocore-2.9.0.tar.gz"
    sha256 "4dc1e20da4561ae662219ca95b20f923328c3106764a741bec00e98eb6680f7e"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages54079467d3f8dae29b14f423b414d9e67512a76743c5bb7686fb05fe10c9cc3eaiohttp-3.9.1.tar.gz"
    sha256 "8fc49a87ac269d4529da45871e2ffb6874e87779c3d0e2ccd813c0899221239d"
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
    url "https:files.pythonhosted.orgpackages34e49434bf112c1f869719edb71a5fe08f2661670a628409721e5ed7df124181aiooss2-0.2.8.tar.gz"
    sha256 "64fe56efb74edeb643f37adb75100d202d81e3d500a5cb969d693d587ecdf106"
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
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackagesad78a1aeb8f80306101112810263e74ec81a99cdd50ecca1f03819716c1aedb3azure-core-1.29.6.tar.gz"
    sha256 "13b485252ecd9384ae624894fe51cfa6220966207264c360beada239f88b738a"
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
    url "https:files.pythonhosted.orgpackages7869c59934d07fb581e0e6cfbc7598e72e528893b38f946addb7f7eca41b4525boto3-1.33.13.tar.gz"
    sha256 "0e966b8a475ecb06cc0846304454b8da2473d4c8198a45dfb2c5304871986883"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesf418daf6799ca51e8ab2d5fe10e1e1bd05e156a14228ac1bf9f402e0599892eebotocore-1.33.13.tar.gz"
    sha256 "fb577f4cb175605527458b04571451db1bd1a2036976b626206036acd4496617"
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
    url "https:files.pythonhosted.orgpackages4b89eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
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
    url "https:files.pythonhosted.orgpackagesbd9525503d8ccd5c45e5aaec0f034ca5900972f4f91454c423d99d3a8b36e698dvc-azure-3.0.1.tar.gz"
    sha256 "4c1ef26396f6016045b7cf809f1c8ac8fea1a178ba71d1d58ed7df6a94557c77"
  end

  resource "dvc-data" do
    url "https:files.pythonhosted.orgpackagescbcbac0b1467270f1f7700adb7f23ef71e6cb78ebe73e4b3c793e37bdb5ca028dvc-data-3.3.0.tar.gz"
    sha256 "c0c747fbdf238b9ffeebb66f48dd1cd43ab282201599f25642519018f9a2aa86"
  end

  resource "dvc-gdrive" do
    url "https:files.pythonhosted.orgpackagescdb09071b2d3bbf392e6f78bed8a3a42abbb13ec58da59987e589a054e2944dddvc-gdrive-3.0.0.tar.gz"
    sha256 "9334f9153530eb4ebc9b59ce9738cd592c5506999e4d2372df3dab733d279d96"
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
    url "https:files.pythonhosted.orgpackages4d7800e5868f277349abe64d8e9d9a6bb6043b4e1c9ed7bbdba7b76150e5c2f1dvc-objects-3.0.0.tar.gz"
    sha256 "fe6412d365d88b8f50e42aa3ed571b316f50e3466e9a83dbf99988e0802537ce"
  end

  resource "dvc-oss" do
    url "https:files.pythonhosted.orgpackagesc23208789c1aa80da525fd7bd0fbef4c11431aabf32cc9446e28a589daf9fa2edvc-oss-3.0.0.tar.gz"
    sha256 "1047f734022fcd2b96d32b06bf6e0921cd0a65810f7fc1e9b0fac29a147b6a9a"
  end

  resource "dvc-render" do
    url "https:files.pythonhosted.orgpackages5c369fc411bdb829b4f65ea3b9809e922ea9c5fa98880650fff8dd9753210a5advc-render-1.0.0.tar.gz"
    sha256 "64be22457a92d7c7983de89cb5c4da2d27e289d10f4ee5d4c51ba885ad1c7762"
  end

  resource "dvc-s3" do
    url "https:files.pythonhosted.orgpackages89a5fd9057fe138bedaaab8ef5b8613a915dbd8e8f123f81de5044d3ecd70199dvc-s3-3.0.1.tar.gz"
    sha256 "6b1d96b237efbb886817df5e0cf4f6b1b161977d30b98b46744a276020a424c6"
  end

  resource "dvc-ssh" do
    url "https:files.pythonhosted.orgpackagesaa7fdb3905b8246f9229a78cf521e2c09e4301bf2a07caca76c7e0fcc94cedb6dvc-ssh-3.0.0.tar.gz"
    sha256 "5e56dabf49a4fbcfd54e04b530289d7bbe905bc5a195f97335743b60ce0de22c"
  end

  resource "dvc-studio-client" do
    url "https:files.pythonhosted.orgpackages7db14600f3522923c176be945329599c9f64cb8621b1c8462861188385ed11ebdvc-studio-client-0.18.0.tar.gz"
    sha256 "41d2ee96bfb3784fad2d71508938197b0917445946090b3bb5ad53354fa35fcc"
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
    url "https:files.pythonhosted.orgpackages177d707b095c5fb58e06f417191a0bf6e66f1ed8df2bd9342e0cb947bf753de3dvc-webhdfs-3.0.0.tar.gz"
    sha256 "a9541b6438c441e943c712231e944efebde6a823e1315ce75a477414f677ccc9"
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
    url "https:files.pythonhosted.orgpackagesfa08cac914ff6ff46c4500fc4323a939dbe7a0f528cca04e7fd3e859611dea41fsspec-2023.12.2.tar.gz"
    sha256 "8548d39e8810b59c38014934f6b31e57f40c1b20f911f4cc2b85389c7e9bf0cb"
  end

  resource "funcy" do
    url "https:files.pythonhosted.orgpackages70b8c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https:files.pythonhosted.orgpackagesa884af4c72f2c5baede340fdffa08538f0855d196fab709a22054b028b21f60dgcsfs-2023.12.2.post1.tar.gz"
    sha256 "e38b7e59580a1e490d62d55a47cba33b49a941b01917c3d6f6cfd2563371ab7b"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackages0db237265877ae607a2cbf9a471f4581dbf5ed13a501b90cb4c773f9ccfff3eaGitPython-3.1.40.tar.gz"
    sha256 "22b126e9ffb671fdd0c129796343a02bf67bf2994b35449ffc9321aa755e18a4"
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
    url "https:files.pythonhosted.orgpackages057784608894384e02f3b0b2621b09ecb0b85e57ba368f13eecbbc43cd1b8719google-auth-2.25.2.tar.gz"
    sha256 "42f707937feb4f5e5a39e6c4f343a17300a459aaf03141457ba505812841cc40"
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
    url "https:files.pythonhosted.orgpackagesbfc111ae026fe939f13c2688b156f50bbad4ef5c3ac34c60248a2a246bdc005bgto-1.6.1.tar.gz"
    sha256 "176562699c26e79e535c0aa9df3b7c5db4453f43051f53da93cf177d6dc9df4f"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages185678a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
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
    url "https:files.pythonhosted.orgpackagesf124f88282626d5f5b720fed5a8d1a609a504569b93465cbbfe8e7c049fba54ekombu-5.3.4.tar.gz"
    sha256 "0bb2e278644d11dea6272c17974a3dbb9688a949f3bb60aeb5b791329c44fadc"
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
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
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
    url "https:files.pythonhosted.orgpackages7275642688bf5d99131fe8cf603f4ef9f26e4b1c6ed8f7f5c7e6fb31def54fb7orjson-3.9.10.tar.gz"
    sha256 "9ebbdbd6a046c304b1845e96fbcc5559cd296b4dfd3ad2509e33c4d9ce07d6a1"
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
    url "https:files.pythonhosted.orgpackages1a72acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025bpycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesaa3f56142232152145ecbee663d70a19a45d078180633321efb3847d2562b490pydantic-2.5.3.tar.gz"
    sha256 "b3ef57c62535b0941697cce638c08900d87fcb67e29cfa99e8a68f747f393f7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesb27d8304d8471cfe4288f95a3065ebda56f9790d087edc356ad5bd83c89e2d79pydantic_core-2.14.6.tar.gz"
    sha256 "1fd0c1d395372843fba13a51c28e3bb9d59bd7aebfeb17358ffaaa1e4dbbe948"
  end

  resource "pydot" do
    url "https:files.pythonhosted.orgpackages136e916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "pydrive2" do
    url "https:files.pythonhosted.orgpackagesd1fb809d215b100232d3253162061b1ffa55089b158d7f5f6d4e97cc757104efPyDrive2-1.18.1.tar.gz"
    sha256 "49dca8842f7c3d63fd35ab55492af2a8b5b39f1cc811042fe37ffbed1c48303f"
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
    url "https:files.pythonhosted.orgpackagesbfa0e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610epyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
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
    url "https:files.pythonhosted.orgpackages8243fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782cruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3fs" do
    url "https:files.pythonhosted.orgpackagescdefdbee238c6c78275f433742feae2a717df2e7ed151d5e9dc953fc3b075cc6s3fs-2023.12.2.tar.gz"
    sha256 "b5ec07062481bbb45cb061b31984c7188d106e292c27033039e024e4ba5740dc"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages5fcc7e3b8305e22d7dcb383d4e1a30126cfac3d54aea2bbd2dfd147e2eff4988s3transfer-0.8.2.tar.gz"
    sha256 "368ac6876a9e9ed91f6bc86581e319be08188dc60d50e0d56308ed5765446283"
  end

  resource "scmrepo" do
    url "https:files.pythonhosted.orgpackages3ea4aa08ce0f092b9b1a4d59540f767a70b9c567ec31484af89ed719765659b7scmrepo-2.0.2.tar.gz"
    sha256 "17e75b6b8d730d84e0e0479f4b4e15fce7f191c54ee9604164004041cf0f07de"
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
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackages5b4939f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
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

  resource "vine" do
    url "https:files.pythonhosted.orgpackagesbde4d07b5f29d283596b9727dd5275ccbceb63c44a1a82aa9e4bfd20426762acvine-5.1.0.tar.gz"
    sha256 "8b62e981d35c41049211cf62a0a1242d8c1ee9bd15bb196ce38aefd6799e61e0"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackagesd83398b8032d580525c04e0691f4df9a74b0cfb327661823e32fe6d00bed55a4voluptuous-0.14.1.tar.gz"
    sha256 "7b6e5f7553ce02461cce17fedb0e3603195496eb260ece9aca86cc4cc6625218"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackagesd71263deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
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