class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https:dvc.org"
  url "https:files.pythonhosted.orgpackagescefe30d8a9733f1edddd356766f0ec167e950e26a4717ec6f0c397da25f9510fdvc-3.55.2.tar.gz"
  sha256 "2fbb38385753d51b25967c80e672cf9dea046bdac182c159a2c1d1f246d15ce0"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "081402479420933e5c52f3fe0c8bc5108d981fa45eae34208be6840c54b755af"
    sha256 cellar: :any,                 arm64_sonoma:  "1654c2fecf29e235c46a74a2b869755666c0a0c84002955ba5c6b03f7abbcdbf"
    sha256 cellar: :any,                 arm64_ventura: "00255b05a5df5df29c8384f02e073342b19385245910dab861197b2dd7373553"
    sha256 cellar: :any,                 sonoma:        "e2b4a2e5541eeccb8e799adb69e4dace9983e8d44736fe9157ac17bf7f26f76a"
    sha256 cellar: :any,                 ventura:       "8d5208b0c48467d3e65356fedf1e5fa73bfe311d3a17becac59dad3dba9733d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e87aacac453a8a33289a809ec1813dc61e2e6924aac01cc492a727d8584082"
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
    url "https:files.pythonhosted.orgpackagesb41e6d5146676044247af566fa5843b335b1a647e6446070cec9c8b61c31b369adlfs-2024.7.0.tar.gz"
    sha256 "106995b91f0eb5e775bcd5957d180d9a14faef3271a063b1f65c66fd5ab05ddf"
  end

  resource "aiobotocore" do
    url "https:files.pythonhosted.orgpackagesd74e5a4f10fe0f61dc4e59fcedcfcbf0ee997003d1fded0cfcb14fbd1851905baiobotocore-2.15.1.tar.gz"
    sha256 "1f9f16eec2a3da32df162b5db12da779ec6d6c6311715c936cad511f436efa74"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2df722bba300a16fd1cad99da1a23793fe43963ee326d012fdf852d0b4035955aiohappyeyeballs-2.4.0.tar.gz"
    sha256 "55a1714f084e63d49639800f95716da97a1f173d46a16dfcfda0016abb93b6b2"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesca28ca549838018140b92a19001a8628578b0f2a3b38c16826212cc6f706e6d4aiohttp-3.10.5.tar.gz"
    sha256 "f071854b47d39591ce9a17981c46790acb30518e2f83dfca8db2dfa091178691"
  end

  resource "aiohttp-retry" do
    url "https:files.pythonhosted.orgpackages01c1d57818a0ed5b0313ad8c620638225ddd44094d0d606ee33f3df5105572cdaiohttp_retry-2.8.3.tar.gz"
    sha256 "9a8e637e31682ad36e1ff9f8bcba912fcfc7d7041722bc901a4b948da4d71ea9"
  end

  resource "aioitertools" do
    url "https:files.pythonhosted.orgpackages06de38491a84ab323b47c7f86e94d2830e748780525f7a10c8600b67ead7e9eaaioitertools-0.12.0.tar.gz"
    sha256 "c2a9055b4fbb7705f561b9d86053e8af5d10cc845d22c32008c43490b2d8dd6b"
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
    url "https:files.pythonhosted.orgpackagesa743f1a1876b04c45ba0b63852795102199c0356b1ddbed24dde7db7c89e1607aliyun-python-sdk-core-2.15.2.tar.gz"
    sha256 "54f66a53e193c61c5e16ea4505a0cab43543f8ad2ef22833f69c4d5e5151c17d"
  end

  resource "aliyun-python-sdk-kms" do
    url "https:files.pythonhosted.orgpackagesa82c9877d0e6b18ecf246df671ac65a5d1d9fecbf85bdcb5d43efbde0d4662ebaliyun-python-sdk-kms-2.16.5.tar.gz"
    sha256 "f328a8a19d83ecbb965ffce0ec1e9930755216d104638cd95ecd362753b813b3"
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
    url "https:files.pythonhosted.orgpackages7849f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7533a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "asyncssh" do
    url "https:files.pythonhosted.orgpackages3234007ba4c65dc15ad394ff50d6ce272bcc028a8824ab1658c5fe5c480be515asyncssh-2.17.0.tar.gz"
    sha256 "3b159c105aa388c1e2245c4faf483f540ada8cad99402281119100166e5edb3c"
  end

  resource "atpublic" do
    url "https:files.pythonhosted.orgpackages5d18b1d247792440378abeeb0853f9daa2a127284b68776af6815990be7fcdb0atpublic-5.0.tar.gz"
    sha256 "d5cb6cbabf00ec1d34e282e8ce7cbc9b74ba4cb732e766c24e2d78d1ad7f723f"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackages037af79ad135a276a37e61168495697c14ba1721a52c3eab4dae2941929c79f8azure_core-1.31.0.tar.gz"
    sha256 "656a0dd61e1869b1506b7c6a3b31d62f15984b1a573d6326f6aa2f3e4123284b"
  end

  resource "azure-datalake-store" do
    url "https:files.pythonhosted.orgpackages22ff61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackagesb35d1c7da35dd640b4a95a38f980bb6b0b56c4e91d5b3d518ac11a2c4ebf5f62azure_identity-1.18.0.tar.gz"
    sha256 "f567579a65d8932fa913c76eddf3305101a15e5727a5e4aa5df649a0f553d4c3"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackages6b64eb0fbd7865463d9551bcfd6a92947d235f2128aa0b12b6f0254959aa31ebazure_storage_blob-12.23.0.tar.gz"
    sha256 "2fadbceda1d99c4a72dfd32e0122d7bca8b5e8d2563f5c624d634aeaff49c9df"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagese47ed95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "billiard" do
    url "https:files.pythonhosted.orgpackages7c581546c970afcd2a2428b1bfafecf2371d8951cc34b46701bea73f4280989ebilliard-4.2.1.tar.gz"
    sha256 "12b641b0c539073fc8d3f5b8b7be998956665c4233c7c1fcd66a7e677c4fb36f"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages0931aa8f565871e00264874bf220ab9913a168fe8acf8b19f7c1a344d1623104boto3-1.35.23.tar.gz"
    sha256 "3fbf1d5b749c92ed43aa190650979dff9f83790a42522e1e9eefa54c8e44bc4b"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages9a7a1c9a1b478c4cdafae166572d5dc2aff93cd34c04fdfbfb0772cf1fccfcfabotocore-1.35.23.tar.gz"
    sha256 "25b17a9ccba6ad32bb5bf7ba4f52656aa03c1cb29f6b4e438050ee4ad1967a3b"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
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
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
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
    url "https:files.pythonhosted.orgpackages454b1596df13967be20dcb1ef0de5ee8554ce53ecc45ddc196d400edc5afd0e8dvc_data-3.16.5.tar.gz"
    sha256 "ba0d9ac53a1809622f59ff86b24d07639fce7c98d0c26ef9406eed309d04c856"
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
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "flatten-dict" do
    url "https:files.pythonhosted.orgpackages89c65fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl-lock" do
    url "https:files.pythonhosted.orgpackagesa9fa885c58f9716063e2ac099f773d0420f20bb834b19538066a2e0d5b848ba4flufl_lock-8.1.0.tar.gz"
    sha256 "d88302005692a63d98b60080158faf089be5ecae6969f706409da8276fdce7cb"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "fsspec" do
    url "https:files.pythonhosted.orgpackages627c12b0943011daaaa9c35c2a2e22e5eb929ac90002f08f1259d69aedad84defsspec-2024.9.0.tar.gz"
    sha256 "4b0afb90c2f21832df142f292649035d80b421f60a9e1c027802e5a0da2b04e8"
  end

  resource "funcy" do
    url "https:files.pythonhosted.orgpackages70b8c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https:files.pythonhosted.orgpackagesd99d64fa09b9c392ee79ffaa4b26d0481d2d775ffe03969b38a4ade77bd72d15gcsfs-2024.9.0.post1.tar.gz"
    sha256 "7ca70ee9d7c7dbce1a3e36b4883e14102c2d7b4284f49e242843a437bc684684"
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
    url "https:files.pythonhosted.orgpackagesc85c31c1742a53b79c8a0c4757b5fae2e8ab9c519cbd7b98c587d4294e1d2d16google_api_core-2.20.0.tar.gz"
    sha256 "f74dff1889ba291a4b76c5079df0711810e2d9da81abfdc99957bc961c1eb28f"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackagesf36829fae04dbe58befbc2313fa03c43448c17d237047e83701272f54d83ac4agoogle_api_python_client-2.146.0.tar.gz"
    sha256 "41f671be10fa077ee5143ee9f0903c14006d39dc644564f4e044ae96b380bf68"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackagesa137c854a8b1b1020cf042db3d67577c6f84cd1e8ff6515e4f5498ae9e444ea5google_auth-2.35.0.tar.gz"
    sha256 "f4c64ed4e01e8e8b646ef34c018f8bf3338df0c8e37d8b3bba40e7f574a3278a"
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
    url "https:files.pythonhosted.orgpackagesd6b71554cdeb55d9626a4b8720746cba8119af35527b12e1780164f9ba0f659agoogle_cloud_storage-2.18.2.tar.gz"
    sha256 "aaf7acd70cdad9f274d29332673fcab98708d0e1f4dceb5a5356aaef06af4d99"
  end

  resource "google-crc32c" do
    url "https:files.pythonhosted.orgpackages6772c3298da1a3773102359c5a78f20dae8925f5ea876e37354415f68594a6fbgoogle_crc32c-1.6.0.tar.gz"
    sha256 "6eceb6ad197656a1ff49ebfbbfa870678c75be4344feb35ac1edf694309413dc"
  end

  resource "google-resumable-media" do
    url "https:files.pythonhosted.orgpackages585a0efdc02665dca14e0837b62c8a1a93132c264bd02054a15abb2218afe0aegoogle_resumable_media-2.7.2.tar.gz"
    sha256 "5280aed4629f2b60b847b0d42f9857fd4935c11af266744df33d8074cae92fe0"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages533b1599ceafa875ffb951480c8c74f4b77646a6b80e80970698f2aa93c216cegoogleapis_common_protos-1.65.0.tar.gz"
    sha256 "334a29d07cddc3aa01dee4988f9afd9b2916ee2ff49d6b757155dc0d197852c0"
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
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
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
    url "https:files.pythonhosted.orgpackagesdb7ac0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1afisodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "iterative-telemetry" do
    url "https:files.pythonhosted.orgpackagesc7c90c7ec6cfe9d0384bcfbab05f0570878f6859151ef3ce69a8762693b84c03iterative_telemetry-0.0.9.tar.gz"
    sha256 "53686c3e912a33e8bf6975b878fd4bd0a7d589c8bad0a6a5573714af9e731dc2"
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
    url "https:files.pythonhosted.orgpackages384db93fcb353d279839cc35d0012bee805ed0cf61c07587916bfc35dbfddaf1kombu-5.4.2.tar.gz"
    sha256 "eef572dd2fd9fc614b37580e3caeafdd5af46c1eff31e7fba89138cdb406f2cf"
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
    url "https:files.pythonhosted.orgpackages59048d7aa5c671a26ca5612257fd419f97380ba89cdd231b2eb67df58483796dmsal-1.31.0.tar.gz"
    sha256 "2c4f189cf9cc8f00c80045f66d39b7c0f3ed45873fd3d1f2af9f22db2e12ff4b"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackages2d38ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5ebmsal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
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
    url "https:files.pythonhosted.orgpackages9e03821c8197d0515e46ea19439f5c5d5fd9a9889f76800613cfac947b5d7845orjson-3.10.7.tar.gz"
    sha256 "75ef0640403f945f3a1f9f6400686560dbfb0fb5b16589ad62cd477043c4eee3"
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
    url "https:files.pythonhosted.orgpackagesb1a44579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages18c78c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pyarrow" do
    url "https:files.pythonhosted.orgpackages274eea6d43f324169f8aec0e57569443a38bab4b398d09769ca64f7b4d467de3pyarrow-17.0.0.tar.gz"
    sha256 "4beca9521ed2c0921c1023e68d097d0299b62c362639ea315572a58f3f50fd28"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages1d676afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesa9b7d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese2aa6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pydot" do
    url "https:files.pythonhosted.orgpackages2caa4cf0b17a070fb57798e8e0f5b1665abf5b2f19ee8ea47957aec2c37b9cedpydot-3.0.1.tar.gz"
    sha256 "e18cf7f287c497d77b536a3d20a46284568fea390776dface6eabbdf1b1b5efc"
  end

  resource "pydrive2" do
    url "https:files.pythonhosted.orgpackages12aff065e829aa5a4e9caa24a7a5dcb00c229bf5c61957cbc56edbe9a910bf5cpydrive2-1.20.0.tar.gz"
    sha256 "168ba6eb6d83c9b082f05bc8cb95ee93ce62389db3b559ff0e769b5bb8b2b10a"
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
    url "https:files.pythonhosted.orgpackagesfb68ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020epyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages5d70ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages830813f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043apyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages927640f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
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
    url "https:files.pythonhosted.orgpackagese3de1dbadd86b81a587d9d6cce18512ab130062d386edf0e368a1ff7c2e2f462s3fs-2024.9.0.tar.gz"
    sha256 "6493705abb50374d6b7994f9616d27adbdd8a219c8635100bdc286382efd91f5"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "scmrepo" do
    url "https:files.pythonhosted.orgpackages1f8bcecf019d43f6cc54737835c8c4eb9146f19b9c5e56a19f59a773a7f72debscmrepo-3.3.7.tar.gz"
    sha256 "8ca01563c27cf0f8b07fb51fe757c7d975d61aa9f2f2ed13a29e5e308c891c07"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
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
    url "https:files.pythonhosted.orgpackages160315df5398fcfe8b5f7fa704a85b44d2bb679c825b22a5cd5592d4cfb11b0bsqltrie-0.11.1.tar.gz"
    sha256 "56963921dec494881b048e968d5556a90ed273b5dba1ea0aaac462f3b9815d21"
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
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagesc558a79003b91ac2c6890fc5d90145c662fd5771c6f11447f116b63300436bc9typer-0.12.5.tar.gz"
    sha256 "f592f089bedcc8ec1b974125d64851029c3b1af145f04aca64d69410f0c9b722"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
    url "https:files.pythonhosted.orgpackagese43d4924f9ed49698bac5f112bc9b40aa007bbdcd702462c1df3d2e1383fb158yarl-1.11.1.tar.gz"
    sha256 "1bb2d9e212fb7449b8fb73bc461b51eaa17cc8430b4a87d87be7b25052d92f53"
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