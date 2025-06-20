class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https:dvc.org"
  url "https:files.pythonhosted.orgpackages4a9c15060558c132a05d973fc8cb94a31eabb319c43d050945f2917c75ede3e1dvc-3.60.1.tar.gz"
  sha256 "fe126823d22d0e51115ba695ccbbfac66a4163ff582a2541d7f4599464056ece"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b21d7463e073b0e8710bfde891237fde8920fe54e3004691aa3d0365607fd844"
    sha256 cellar: :any,                 arm64_sonoma:  "9520371c352994c6cac6d31ec47742b7d45926893538545d8870adaaa3294e09"
    sha256 cellar: :any,                 arm64_ventura: "62ee05618d1adbdd714c2c59cfbb01e8ec327bc23b83d636641bd604da3ed222"
    sha256 cellar: :any,                 sonoma:        "da2bc146acf1d0f82ef2c0f8443745256f715526c8b330d413b8e44aa98eaa12"
    sha256 cellar: :any,                 ventura:       "caf3b5cfd28ec14b78017f1027686f5103509ff3d483397c9ca23c95a9297ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0299a6e3399e278adcc575f8cc85d18becf3bef45c05de747827a195402a617f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ce9d304bf7c16c44c6debc5d6e5a598aac1ce5e11c27a4aecc5b54750eb653"
  end

  depends_on "cmake" => :build # for pyarrow
  depends_on "ninja" => :build # for pyarrow
  depends_on "openjdk" => :build # for hydra-core
  depends_on "rust" => :build # for bcrypt
  depends_on "apache-arrow"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pygit2"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  resource "adlfs" do
    url "https:files.pythonhosted.orgpackages7682e30891af574fb358449fb9436aac53569814452cb88b0cba4f488171b8dcadlfs-2024.12.0.tar.gz"
    sha256 "04582bf7461a57365766d01a295a0a88b2b8c42c4fea06e2d673f62675cac5c6"
  end

  resource "aiobotocore" do
    url "https:files.pythonhosted.orgpackages9d254b06ea1214ddf020a28df27dc7136ac9dfaf87929d51e6f6044dd350ed67aiobotocore-2.23.0.tar.gz"
    sha256 "0333931365a6c7053aee292fe6ef50c74690c4ae06bb019afdf706cb6f2f5e32"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages426eab88e7cb2a4058bed2f7870276454f85a7c56cd6da79349eb314fc7bbcaaaiohttp-3.12.13.tar.gz"
    sha256 "47e2da578528264a12e4e3dd8dd72a7289e5f812758fe086473fab037a10fcce"
  end

  resource "aiohttp-retry" do
    url "https:files.pythonhosted.orgpackages9d61ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
  end

  resource "aioitertools" do
    url "https:files.pythonhosted.orgpackages06de38491a84ab323b47c7f86e94d2830e748780525f7a10c8600b67ead7e9eaaioitertools-0.12.0.tar.gz"
    sha256 "c2a9055b4fbb7705f561b9d86053e8af5d10cc845d22c32008c43490b2d8dd6b"
  end

  resource "aiooss2" do
    url "https:files.pythonhosted.orgpackages74c5d704b3943f1cb5cbd8f0bffe597411312b15309917e891712d5bf62fb638aiooss2-0.2.11.tar.gz"
    sha256 "6409e0f7ab66bed364a1c9639b657437175534de160f330d0103a445a2e89a59"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "aliyun-python-sdk-core" do
    url "https:files.pythonhosted.orgpackages3e09da9f58eb38b4fdb97ba6523274fbf445ef6a06be64b433693da8307b4becaliyun-python-sdk-core-2.16.0.tar.gz"
    sha256 "651caad597eb39d4fad6cf85133dffe92837d53bdf62db9d8f37dab6508bb8f9"
  end

  resource "aliyun-python-sdk-kms" do
    url "https:files.pythonhosted.orgpackagesa82c9877d0e6b18ecf246df671ac65a5d1d9fecbf85bdcb5d43efbde0d4662ebaliyun-python-sdk-kms-2.16.5.tar.gz"
    sha256 "f328a8a19d83ecbb965ffce0ec1e9930755216d104638cd95ecd362753b813b3"
  end

  resource "amqp" do
    url "https:files.pythonhosted.orgpackages79fcec94a357dfc6683d8c86f8b4cfa5416a4c36b28052ec8260c77aca96a443amqp-5.3.1.tar.gz"
    sha256 "cddc00c725449522023bad949f70fff7b48f0b1ade74d170a6f10ab044739432"
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
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages160f861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "asyncssh" do
    url "https:files.pythonhosted.orgpackagese8d6823ed5a227f7da70b33681e49eec4a36fae31b9296b27a8d6aead2bd3f77asyncssh-2.21.0.tar.gz"
    sha256 "450fe13bb8d86a8f4e7d7b5fafce7791181ca3e7c92e15bbc45dfb25866e48b3"
  end

  resource "atpublic" do
    url "https:files.pythonhosted.orgpackages2040e686038a07af08e8462a71dc9201867ffdde408b4d93be90a4ad0fbc83efatpublic-6.0.1.tar.gz"
    sha256 "718932844f5bdfdf5d80ad4c64e13964f22274b4f8937d54a8d3811d6bc5dc05"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackagesc929ff7a519a315e41c85bab92a7478c6acd1cf0b14353139a08caee4c691f77azure_core-1.34.0.tar.gz"
    sha256 "bdb544989f246a0ad1c85d72eeb45f2f835afdcbc5b45e43f0dbde7461c81ece"
  end

  resource "azure-datalake-store" do
    url "https:files.pythonhosted.orgpackages22ff61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackages4152458c1be17a5d3796570ae2ed3c6b7b55b134b22d5ef8132b4f97046a9051azure_identity-1.23.0.tar.gz"
    sha256 "d9cdcad39adb49d4bb2953a217f62aec1f65bbb3c63c9076da2be2a47e53dde4"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackages8bf3f764536c25cc3829d36857167f03933ce9aee2262293179075439f3cd3adazure_storage_blob-12.25.1.tar.gz"
    sha256 "4f294ddc9bc47909ac66b8934bd26b50d2000278b10ad82cc109764fdc6e0e3b"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagesbb5d6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77bbcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "billiard" do
    url "https:files.pythonhosted.orgpackages7c581546c970afcd2a2428b1bfafecf2371d8951cc34b46701bea73f4280989ebilliard-4.2.1.tar.gz"
    sha256 "12b641b0c539073fc8d3f5b8b7be998956665c4233c7c1fcd66a7e677c4fb36f"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagese796fc74d8521d2369dd8c412438401ff12e1350a1cd3eab5c758ed3dd5e5f82boto3-1.38.27.tar.gz"
    sha256 "94bd7fdd92d5701b362d4df100d21e28f8307a67ff56b6a8b0398119cf22f859"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages365e67899214ad57f7f26af5bd776ac5eb583dc4ecf5c1e52e2cbfdc200e487abotocore-1.38.27.tar.gz"
    sha256 "9788f7efe974328a38cbade64cc0b1e67d27944b899f88cb786ae362973133b6"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages6c813747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "celery" do
    url "https:files.pythonhosted.orgpackagesbb7d6c289f407d219ba36d8b384b42489ebdd0c84ce9c413875a8aae0c85f35bcelery-5.5.3.tar.gz"
    sha256 "6c972ae7968c2b5281227f01c3a3f984037d21c5129d07bf3550cc2afc6b10a5"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
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
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "crcmod" do
    url "https:files.pythonhosted.orgpackages6bb0e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5bcrcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages43fa6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6bdecorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
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
    url "https:files.pythonhosted.orgpackagesd48b0f2de00c0c0d5881dc39be147ec2918725fb3628deeeb1f27d1c6cf6d9f4dulwich-0.22.8.tar.gz"
    sha256 "701547310415de300269331abe29cb5717aa1ea377af826bf513d0adfb1c209b"
  end

  resource "dvc-azure" do
    url "https:files.pythonhosted.orgpackagesb1cd5cf47247c82e7b8eba42890a23e6700f4baade329d24722140d290c32dc3dvc-azure-3.1.0.tar.gz"
    sha256 "52cbc70d5414b50219b3db0a16f68ad25daba76e3f220aebe4e49b3c6498ae20"
  end

  resource "dvc-data" do
    url "https:files.pythonhosted.orgpackagesda64459483623d867d2161e3aacecc5f9f172e8a57438cfcfc029e00be5fb594dvc_data-3.16.10.tar.gz"
    sha256 "abca33f2169eabc70d1966e2ef3cd290127ebdf141fb0e84db3d37fef49205c6"
  end

  resource "dvc-gdrive" do
    url "https:files.pythonhosted.orgpackagesb5ab278694dd93e8657d590408e37e440ead5ca809af6c265ca248df10942270dvc-gdrive-3.0.1.tar.gz"
    sha256 "ad7c9cd044083745150a57649eb4ef9240348f054bed5a8f8aa5f1820c6384ec"
  end

  resource "dvc-gs" do
    url "https:files.pythonhosted.orgpackages994b6303f29c76458a3c44da47b76cb5c230de545812fe3d58971b91ba8d02fadvc_gs-3.0.2.tar.gz"
    sha256 "739693c0d8250a39074ba16c7dce752bb5a7ff934442d6081ffcfd7ed9313b9a"
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
    url "https:files.pythonhosted.orgpackagesb53668d3c92565d5fa7a6302d825965a1fedbc6e784d4d4ccaf6d536fae2124fdvc_objects-5.1.1.tar.gz"
    sha256 "9e308f2a33486aa44bd2ea42b6ec4a9bd6da5b69ac8127955e506c31d12fbdaa"
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
    url "https:files.pythonhosted.orgpackages247244033cb2e85a7e68ac0bf8d96ece272f6818a28135678090fc8d03ef54b8dvc_s3-3.2.2.tar.gz"
    sha256 "0ea72c9b6b000dfea1a834d4106733b6cdc745d0a6ee1d5c0a5b8c8344671716"
  end

  resource "dvc-ssh" do
    url "https:files.pythonhosted.orgpackages2d847cb9ee1eb82bd384f36eabc3afd18a659d9a669c16e3c78d947e6e0be7c1dvc_ssh-4.2.1.tar.gz"
    sha256 "95deae680200fbc9472bf4e32adae3b6618a8f9f38ed204c618bca28df8c912e"
  end

  resource "dvc-studio-client" do
    url "https:files.pythonhosted.orgpackages870813cf5bb8bf0855d47325467a5948848bcea51780e2212349034f5e4701e6dvc_studio_client-0.21.0.tar.gz"
    sha256 "db212ff5cf73dce886d0713a5d2bf4bc0bbfb499f3ca8548705ca98aab5addd1"
  end

  resource "dvc-task" do
    url "https:files.pythonhosted.orgpackages19efda712c4d9c7d6cacac27d7b2779e6a97c3381ef2c963c33719d39113b6a3dvc_task-0.40.2.tar.gz"
    sha256 "909af541bf5fde83439da56c4c0ebac592af178a59b702708fadaacfd6e7b704"
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
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "flatten-dict" do
    url "https:files.pythonhosted.orgpackages89c65fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl-lock" do
    url "https:files.pythonhosted.orgpackages907880f98f67deb8ba9b67e00a91ceb1ded5a7b8eb2b7801b89625d3396fc9d4flufl_lock-8.2.0.tar.gz"
    sha256 "15b333c35fab1a36b223840057258aeb4cd79f0fbaf82c144f23cdf6cf14d5e3"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages79b1b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "fsspec" do
    url "https:files.pythonhosted.orgpackages00f727f15d41f0ed38e8fcc488584b57e902b331da7f7c6dcda53721b15838fcfsspec-2025.5.1.tar.gz"
    sha256 "2e55e47a540b91843b755e83ded97c6e897fa0942b11490113f09e9c443c2475"
  end

  resource "funcy" do
    url "https:files.pythonhosted.orgpackages70b8c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https:files.pythonhosted.orgpackagesd84a47ad326cc74ccfd97e125c0087a36d516ed74c61f53e458067737378d0f2gcsfs-2025.5.1.tar.gz"
    sha256 "ba945530cf4857cd9d599ccb3ae729c65c39088880b11c4df1fecac30df5f3e3"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages729463b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320agitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackagesdc21e9d043e88222317afdbdb567165fdbc3b0aad90064c7e0c9eb0ad9955ad8google_api_core-2.25.1.tar.gz"
    sha256 "d2aaa0b13c78c61cb3f4282c464c046e45fbd75755683c9c525e6e8f7ed0a5e8"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages0269c0cec6be5878d4de161f64096edb3d4a2d1a838f036b8425ea8358d0dfb3google_api_python_client-2.172.0.tar.gz"
    sha256 "dcb3b7e067154b2aa41f1776cf86584a5739c0ac74e6ff46fc665790dca0e6a6"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages9e9be92ef23b84fa10a64ce4831390b7a4c2e53c0132568d99d4ae61d04c8855google_auth-2.40.3.tar.gz"
    sha256 "500c3a29adedeb36ea9cf24b8d10858e152f2412e3ca37829b3fa18e33d63b77"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackagesfb87e10bf24f7bcffc1421b84d6f9c3377c30ec305d082cd737ddaa6d8f77f7cgoogle_auth_oauthlib-1.2.2.tar.gz"
    sha256 "11046fb8d3348b296302dd939ace8af0a724042e8029c1b872d87fabc9f41684"
  end

  resource "google-cloud-core" do
    url "https:files.pythonhosted.orgpackagesd6b82b53838d2acd6ec6168fd284a990c76695e84c65deee79c9f3a4276f6b4fgoogle_cloud_core-2.4.3.tar.gz"
    sha256 "1fab62d7102844b278fe6dead3af32408b1df3eb06f5c7e8634cbd40edc4da53"
  end

  resource "google-cloud-storage" do
    url "https:files.pythonhosted.orgpackages27846afc2ffdf31f6247a6bab6ba070e073fb05e0fda56adf59ce52ac591a033google_cloud_storage-3.1.1.tar.gz"
    sha256 "f9c8f965cafd1d38509f8e2b070339e0e9e5bf050774653bf36213d4ea6104c0"
  end

  resource "google-crc32c" do
    url "https:files.pythonhosted.orgpackages19ae87802e6d9f9d69adfaedfcfd599266bf386a54d0be058b532d04c794f76dgoogle_crc32c-1.7.1.tar.gz"
    sha256 "2bff2305f98846f3e825dbeec9ee406f89da7962accdb29356e4eadc251bd472"
  end

  resource "google-resumable-media" do
    url "https:files.pythonhosted.orgpackages585a0efdc02665dca14e0837b62c8a1a93132c264bd02054a15abb2218afe0aegoogle_resumable_media-2.7.2.tar.gz"
    sha256 "5280aed4629f2b60b847b0d42f9857fd4935c11af266744df33d8074cae92fe0"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages392433db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1agoogleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "grandalf" do
    url "https:files.pythonhosted.orgpackages950e4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "gto" do
    url "https:files.pythonhosted.orgpackagesd6eaea6267da29ac54a53944106e46337e3e8e43eaa24bb6b7cf5da18043758cgto-1.7.2.tar.gz"
    sha256 "98994f43d02ef6d4e77c4087b1c0c70a038e4a753a5583c23116246d33b89742"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages069482699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cbhttpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hydra-core" do
    url "https:files.pythonhosted.orgpackages6d8e07e42bc434a847154083b315779b0a81d567154504624e181caf2c71cd98hydra-core-1.3.2.tar.gz"
    sha256 "8a878ed67216997c3e9d88a8e72e7b4767e81af37afb4ea3334b269a4390a824"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackages544de940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "iterative-telemetry" do
    url "https:files.pythonhosted.orgpackagesd2b6f17d6e80252b7be6ca4d9463db226ce7863d26287f16f1347e981cd2f3d8iterative_telemetry-0.0.10.tar.gz"
    sha256 "7fde6111de6fa4acf5a95a6190cc9cc5d17d835a815f0a18ece201f6031f4ed6"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages3c563f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https:files.pythonhosted.orgpackagesbbeb1f26c9112a4ee84cfa4a0a81bdf844207496a476fa026cfc98545bb702dbknack-0.12.0.tar.gz"
    sha256 "71f2a6b42ae9a302e43243320fa05edb09b19339fcf1f331f5b6d07bf97f5291"
  end

  resource "kombu" do
    url "https:files.pythonhosted.orgpackages0fd35ff936d8319ac86b9c409f1501b07c426e6ad41966fedace9ef1b966e23fkombu-5.5.4.tar.gz"
    sha256 "886600168275ebeada93b888e831352fe578168342f0d1d5833d88ba0d847363"
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
    url "https:files.pythonhosted.orgpackages3f9081dcc50f0be11a8c4dcbae1a9f761a26e5f905231330a7cacc9f04ec4c61msal-1.32.3.tar.gz"
    sha256 "5eea038689c78a5a70ca8ecbe1245458b55a857bd096efb6989c69ba15985d35"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackages01995d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages46b559f27b4ce9951a4bce56b88ba5ff5159486797ab18863f2b4c1c5e8465bdmultidict-6.5.0.tar.gz"
    sha256 "942bd8002492ba819426a8d7aefde3189c1b87099cdf18aaaefefcf7f3f7b6d2"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages6c4fccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96anetworkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "oauth2client" do
    url "https:files.pythonhosted.orgpackagesa67b17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages988a6ea75ff7acf89f43afb157604429af4661a9840b1f2cece602b6a13c1893oauthlib-3.3.0.tar.gz"
    sha256 "4e707cf88d7dfc22a8cce22ca736a2eef9967c1dd3845efc0703fc922353eeb2"
  end

  resource "omegaconf" do
    url "https:files.pythonhosted.orgpackages09486388f1bb9da707110532cb70ec4d2822858ddfb44f1cdf1233c20a80ea4bomegaconf-2.3.0.tar.gz"
    sha256 "d5d4b6d29955cc50ad50c46dc269bcd92c6e00f5f90d23ab5fee7bfca4ba4cc7"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages810bfea456a3ffe74e70ba30e01ec183a9b26bec4d497f61dcfce1b601059c60orjson-3.10.18.tar.gz"
    sha256 "e8da3947d92123eda795b68228cafe2724815621fe35e8e320a9e9593a4bcd53"
  end

  resource "oss2" do
    url "https:files.pythonhosted.orgpackagesd563b6c355af7f04a8a1d5759fa6fc47539e25ef8e6f2745372a242fdadcac65oss2-2.18.4.tar.gz"
    sha256 "be1e7a871a8cc267726367333017d78333ee8fae88c727ad61396f59c1c0e4d0"
  end

  resource "ossfs" do
    url "https:files.pythonhosted.orgpackagesb18ad0ca844e613d0b8d4b80f8098528a599f2fbf05c3853a75d27d3e645928eossfs-2025.5.0.tar.gz"
    sha256 "722e7044fbcd84cc992e5cd6821d5f19bed334216c140d6e46ffb21979d49ce0"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa61643264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackagesf4ac87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages52f3b9655a711b32c19720253f6f06326faf90580834e2e83f840472d752bc8bprotobuf-6.31.1.tar.gz"
    sha256 "d8cac4c982f0b957a4dc73a80e2ea24fab08e679c0de9deb835f4a12d69aca9a"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyarrow" do
    url "https:files.pythonhosted.orgpackagesa2eea7810cb9f3d6e9238e61d312076a9859bf3668fd21c69744de9532383912pyarrow-20.0.0.tar.gz"
    sha256 "febc4a913592573c8d5805091a6c2b5064c8bd6e002131f01061797d91c783c1"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagese9e678ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages8ea68452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages00dd4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8cpydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydot" do
    url "https:files.pythonhosted.orgpackages5035b17cb89ff865484c6a20ef46bf9d95a5f07328292578de0b295f4a6beec2pydot-4.0.1.tar.gz"
    sha256 "c2148f681c4a33e08bf0e26a9e5f8e4099a82e0e2a068098f32ce86577364ad5"
  end

  resource "pydrive2" do
    url "https:files.pythonhosted.orgpackages3fdc92b0beba58f09441219bb6720bebdb895317632db4778cfe1d21532d27e5pydrive2-1.21.3.tar.gz"
    sha256 "649b84d60c637bc7146485039535aa8f1254ad156423739f07e5d32507447c13"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pygtrie" do
    url "https:files.pythonhosted.orgpackagesb91355deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5fpygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagese746bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages5d70ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesda8a22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages39876da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages208480203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "s3fs" do
    url "https:files.pythonhosted.orgpackages7f6fd0ee452580d7d0643a1a776b95dfef2144023f3fc077038e07d651995d34s3fs-2025.5.1.tar.gz"
    sha256 "84beffa231b8ed94f8d667e93387b38351e1c4447aedea5c2c19dd88b7fcb658"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesed5d9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191as3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "scmrepo" do
    url "https:files.pythonhosted.orgpackages25c9a05b8ce93ce8470e44f430f664396396b6b183cbe899407e8cd286a29165scmrepo-3.3.11.tar.gz"
    sha256 "eb25424a7cc1290e3e0aeaa8a39bb8347b9abc5fab33356e8a70db530d7d06b6"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages72d1d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    url "https:files.pythonhosted.orgpackages5a3e837067b970c1d2ffa936c72f384a63fdec4e186b74da781e921354a94024shtab-1.7.2.tar.gz"
    sha256 "8c16673ade76a2d42417f03e57acf239bfb5968e842204c17990cae357d07d6f"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqltrie" do
    url "https:files.pythonhosted.orgpackages8ae6f3832264bcd98b9e71c93c579ab6b39eb1db659cab305e59f8f7c1adc777sqltrie-0.11.2.tar.gz"
    sha256 "4df47089b3abfe347bcf81044e633b8c7737ebda4ce1fec8b636a85954ac36da"
  end

  resource "sshfs" do
    url "https:files.pythonhosted.orgpackages5ae674b6119fdaf81cadc4b404f6abf681836209a9d22f7f0c1b08760460e5c5sshfs-2025.2.0.tar.gz"
    sha256 "1a60b872062078cfb9d954d9c728f3e72e5bc81aa913dc0f91e687305a005fe1"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagescc180bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagesc58c7d682431efca5fd290017663ea4588bf6f2c6aad085c7f108c5dbc316e70typer-0.16.0.tar.gz"
    sha256 "af377ffaee1dbe37ae9440cb4e8f11686ea5ce4e9bae01b84ae7c63b87f1dd3b"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages95321a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackages9860f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
    url "https:files.pythonhosted.orgpackagesc3fce91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcefwrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages3cfbefaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  resource "zc-lockfile" do
    url "https:files.pythonhosted.orgpackages5b83a5432aa08312fc834ea594473385c005525e6a80d768a2ad246e78877afdzc.lockfile-3.0.post1.tar.gz"
    sha256 "adb2ee6d9e6a2333c91178dcb2c9b96a5744c78edb7712dc784a7d75648e81ec"
  end

  def install
    if DevelopmentTools.clang_build_version >= 1500
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