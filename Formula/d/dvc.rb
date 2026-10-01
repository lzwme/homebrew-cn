class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/13/1e/957a50eab8af18a5837bf47f148b90dac36650150faca840d5c020272098/dvc-3.67.1.tar.gz"
  sha256 "0a941016a10ac8c99b5342e5a964c9bff29c191f7b3539ff3e04910d828f82ab"
  license "Apache-2.0"
  revision 16

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "752b0e2e7d59c46301f1d3b809df6c175d4401711a7ce3530cf05c346ed78b9a"
    sha256 cellar: :any, arm64_tahoe:       "1758bed48fae5320ffeeae35974401c43ab4cc9a69cfc2ab834e24fce720c331"
    sha256 cellar: :any, arm64_sequoia:     "23f674ea4622b21d3957d1b83f2cbf407885f6fa2e421caf42cb732225e596c9"
    sha256 cellar: :any, arm64_linux:       "3fa8c9fe700f6bc94ee2dabb82bc9835d5323cdd7ce8c1b801076387b3d807a5"
    sha256 cellar: :any, x86_64_linux:      "63203d00de8f5ef427a6cf376154f5e213e43c59697e53e37e9faee4ac73e57b"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "cmake" => :build # for pyarrow
  depends_on "ninja" => :build # for pyarrow
  depends_on "openjdk" => :build # for hydra-core
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "apache-arrow"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pydantic" => :no_linkage
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages package_name:     "dvc[all]",
                exclude_packages: %w[certifi cryptography numpy pydantic pygit2],
                extra_packages:   "boto3" # https://github.com/treeverse/dvc/issues/10966

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/f4/29/9937905acfaf3e4826d7782f8efab845bb11eaa2e24749a16eeab32e7fa0/adlfs-2026.8.0.tar.gz"
    sha256 "b78a01bd892c2a99f461b2b2ef4592c2eb45934e728f318472291ccaa6378e06"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/a4/0d/98230a1320e78f2c35277ca194c494690dce3161ad05200556417ab9e816/aiobotocore-3.9.1.tar.gz"
    sha256 "617d4a78da5adb6ae7d532835727ad388f73555f2ef129b9de1b1add73a43ee6"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/58/d9/22ce5786ac0c1653ae8b6c23bded02c1686d11f0dbb45b31ce128e0df985/aiohttp-3.14.3.tar.gz"
    sha256 "9491196535a88924a60afd5b5f434b5b203b6cc616250878dbdb223a8f7844bc"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/9d/61/ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033/aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/fd/3c/53c4a17a05fb9ea2313ee1777ff53f5e001aefd5cc85aa2f4c2d982e1e38/aioitertools-0.13.0.tar.gz"
    sha256 "620bd241acc0bbb9ec819f1ab215866871b4bbd1f73836a55f799200ee86950c"
  end

  resource "aiooss2" do
    url "https://files.pythonhosted.org/packages/74/c5/d704b3943f1cb5cbd8f0bffe597411312b15309917e891712d5bf62fb638/aiooss2-0.2.11.tar.gz"
    sha256 "6409e0f7ab66bed364a1c9639b657437175534de160f330d0103a445a2e89a59"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/ea/38/eb3be49159d6442e68189f21a2205a199b51ca46cf42a3f874e695ff0ba9/aliyun_python_sdk_core-2.16.1-py3-none-any.whl"
    sha256 "0f25a6e8ec1ea29c76610278cff81cbff85149a6e692bf2398a6f9b77e5e7424"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/a8/2c/9877d0e6b18ecf246df671ac65a5d1d9fecbf85bdcb5d43efbde0d4662eb/aliyun-python-sdk-kms-2.16.5.tar.gz"
    sha256 "f328a8a19d83ecbb965ffce0ec1e9930755216d104638cd95ecd362753b813b3"
  end

  resource "amqp" do
    url "https://files.pythonhosted.org/packages/b2/a7/787f067b237d4b3bfefa8d67ead64a7d807feafe85ad516afb284fb1587f/amqp-5.4.0.tar.gz"
    sha256 "aaa33987dcb6a7893955d3b4f537c5d4755addce1009929e63e5d18c1b51a0a7"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/dd/7f/2d79247bacc562104f312d27efe541673aa177feac89de291bd61bca52be/asyncssh-2.24.0.tar.gz"
    sha256 "4064c590e59ce2e8d82a2f66d35f3120d765828b4df5e3dbfb07b4a8c24686c9"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/c2/da/105fb4e9e966f61eedef4cee081a99a8bf18792ad56aa64467618e8b23c0/atpublic-8.0.1.tar.gz"
    sha256 "4cc00a2b8ea5645a268edc310667302fe1de2b91aba88d0bd634c0e6564f6ef4"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/c6/f0/3fb4ec2d4b3798e3bb8fefb1096d5728f2501c2ed52e0cb729a2c956cf00/azure_storage_blob-12.30.3.tar.gz"
    sha256 "31760221ceff36b7ceed741ba0093d08ec857911b92294dce3e4efe8fa40245e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/60/a9/b1c91c6866717e68b12331222f294e20df4b7674f58c14639ecd0166549c/billiard-4.3.0.tar.gz"
    sha256 "3ddeaf82c0373e076c7b450c2fdc7ded6d73981bcfd931da1cdd0c0a03468dc5"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b1/dd/b93be617dd5d1c6a3a248066030a450e62d211c0af0f49ed3a0d761383c9/boto3-1.43.75.tar.gz"
    sha256 "86da93d3d5b46a58b03fa51b598ffa4aeaff485a3000affacf78491c105e44f0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a3/80/5e39eda5dfb66df691d71212799a9f9d35aa9e447511604030447a00e9d6/botocore-1.43.75.tar.gz"
    sha256 "e8ed6b0f3cd398dfb9e08d7ca3a0b964152166a317a04e89c45ec91003327ffe"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/e8/b4/a1233943ab5c8ea05fb877a88a0a0622bf47444b99e4991a8045ac37ea1d/celery-5.6.3.tar.gz"
    sha256 "177006bd2054b882e9f01be59abd8529e88879ef50d7918a7050c5a9f4e12912"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/c3/a4/34847b59150da33690a36da3681d6bbc2ec14ee9a846bc30a6746e5984e4/click_plugins-1.1.1.2.tar.gz"
    sha256 "d7af3984a99d243c131aa1a828331e7630f4a88a9741fd05c927b204bcf92261"
  end

  resource "click-repl" do
    url "https://files.pythonhosted.org/packages/8e/f5/19bce5e62ee97138752eeef0b91bfa46d880725cc8ec00aa00daa2685410/click_repl-0.4.0.tar.gz"
    sha256 "52f8962ff0fdae8105d568123b144951257b6bfcfb44ff6f043379c307d0a8ac"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/0c/31/84b2b2113c2c972431582bffd74f0d04b5efd9126538127b766275580950/dictdiffer-0.10.0.tar.gz"
    sha256 "0b912acf663949d73b820d3ed59362140a188ab742c94efe13c762dbd24cbbd3"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/b5/ce/e1fd64d36e4a5717bd5e6b2ad188f5eaa2e902fde871ea73a79875793fc9/dpath-2.2.0.tar.gz"
    sha256 "34f7e630dc55ea3f219e555726f5da4b4b25f2200319c8e6902c394258dd6a3e"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/63/b9/5b68d879282190b0429c815d582dc1f212d4910aa22ac7c1aff39675a719/dulwich-1.2.15.tar.gz"
    sha256 "e98f775601846fb4d44a384003e93c53c42b0c9796c8fe0cc3128b8e2e0bbf88"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/d0/12/c22ff8bbae5939bb31d773b6dba1d4dc93292a2d65e40e18b35927e0539f/dvc_azure-3.1.1.tar.gz"
    sha256 "db2f9b069e68d1bbae67f953a373ebde42d404d6c7e894d95d597c8ad753a660"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/c3/2f/e00e933d10512ca7ec4f3f2f450d915e6bed4c01cf666d50a1a8f9b033ff/dvc_data-3.18.3.tar.gz"
    sha256 "61c8085a7c5b5e3ecaa86d63c3f22dc7c951a5dc55bd0a1bb5afa15377a25b1a"
  end

  resource "dvc-gdrive" do
    url "https://files.pythonhosted.org/packages/b5/ab/278694dd93e8657d590408e37e440ead5ca809af6c265ca248df10942270/dvc-gdrive-3.0.1.tar.gz"
    sha256 "ad7c9cd044083745150a57649eb4ef9240348f054bed5a8f8aa5f1820c6384ec"
  end

  resource "dvc-gs" do
    url "https://files.pythonhosted.org/packages/00/b6/69fb69f52333854460779eda1d2a3516176c4c5335f713555aa4080e6eda/dvc_gs-3.1.0.tar.gz"
    sha256 "4218560ff1d5196fd0c79162655cd79c5134fa61ebe34a3a507faf0749226eee"
  end

  resource "dvc-hdfs" do
    url "https://files.pythonhosted.org/packages/ea/b5/42a2a3b3897f6e7c0b77c1408ed27e472ffdf61c5a1fec91d396177da275/dvc-hdfs-3.0.0.tar.gz"
    sha256 "286443cb2c107ad53e73d8d6c4af8524b6e3b6b88b1543c8bc0544738aeb9fee"
  end

  resource "dvc-http" do
    url "https://files.pythonhosted.org/packages/33/e6/4fb38ab911a9d90fbe2c7759c430814fe2253760304a9de0d3ebd6e27c20/dvc-http-2.32.0.tar.gz"
    sha256 "f714f8435634aab943c625f659ddac1188c6ddaf3ff161b39715b83ff39637fc"
  end

  resource "dvc-objects" do
    url "https://files.pythonhosted.org/packages/f5/3a/90c765395fe282132aac3fb4fb8ba2839437c459125a38af0c4865b7b963/dvc_objects-5.2.0.tar.gz"
    sha256 "969bc19847b76604327631ce0ad0f287efa549d87bac028b5c2eb17a0d610984"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/c2/32/08789c1aa80da525fd7bd0fbef4c11431aabf32cc9446e28a589daf9fa2e/dvc-oss-3.0.0.tar.gz"
    sha256 "1047f734022fcd2b96d32b06bf6e0921cd0a65810f7fc1e9b0fac29a147b6a9a"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/be/15/605312dbdc0931547987ee25a9a3f6fcabf48ca1436039abcd524156b8e2/dvc-render-1.0.2.tar.gz"
    sha256 "40d1cd81760daf34b48fa8362b5002fcbe415e3cdbcf42369b6347d01497ffc0"
  end

  resource "dvc-s3" do
    url "https://files.pythonhosted.org/packages/9b/79/204d9b9f811d67f972339e4f0cf7cfa1f76928b998c662e0d07fc16064be/dvc_s3-3.3.0.tar.gz"
    sha256 "f1d718a44dcee5191beb46e44adf4bb22882cb8e9ccdd8f2640078abc56457d4"
  end

  resource "dvc-ssh" do
    url "https://files.pythonhosted.org/packages/cc/31/d8c8340ab605cb0d5427be7911da0baa6d1471a43611f54100aa456ce2c8/dvc_ssh-4.3.0.tar.gz"
    sha256 "3607f31195b95a60da3fce5aa5138cbc84f2e78e421ec7bdcfde310bf270f4e0"
  end

  resource "dvc-studio-client" do
    url "https://files.pythonhosted.org/packages/cd/ee/c3c2901383633a2bd622a931948649a001a9836c803bb63580adeaa28299/dvc_studio_client-0.23.0.tar.gz"
    sha256 "cd5582fcf9dc281a00cceb56b6dd6d7503052b0661285dac3315bbb5d3add240"
  end

  resource "dvc-task" do
    url "https://files.pythonhosted.org/packages/19/ef/da712c4d9c7d6cacac27d7b2779e6a97c3381ef2c963c33719d39113b6a3/dvc_task-0.40.2.tar.gz"
    sha256 "909af541bf5fde83439da56c4c0ebac592af178a59b702708fadaacfd6e7b704"
  end

  resource "dvc-webdav" do
    url "https://files.pythonhosted.org/packages/a0/12/71c963fa0f1c1200983c40ab54978ba36e2a459a646c7266248c8594dd37/dvc_webdav-3.0.1.tar.gz"
    sha256 "3c0d04afb0985a2c156f0b719f4b9437ce4acd346647d8f6fee043b5e917c76e"
  end

  resource "dvc-webhdfs" do
    url "https://files.pythonhosted.org/packages/36/f5/249f881b2e035d6c7362733986b5545fa8c88fed451972be5d0fedae5fab/dvc-webhdfs-3.1.0.tar.gz"
    sha256 "6e894843d15ce766a05c616deda9d9bc361248e93bf9ea338b996e6e51ea0fea"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/ea/8d/a7121ffe5f402dc015277d2d31eb82d2187334503a011c18f2e78ecbb9b2/entrypoints-0.4.tar.gz"
    sha256 "b706eddaa9218a19ebcd67b56818f05bb27589b1ca9e8d797b74affad4ccacd4"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/2b/2d/5cb7a5ac017031e96a63173f3d57a8a5162ce36f9ff461e62bc6da4d88ab/filelock-4.0.6.tar.gz"
    sha256 "323fab3b2fb22d889b29fa83774f60029addddb4b6a1bcfa1e73066eabffb5f2"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/0b/d0/34bf1bafa4d54e4ec20ca40856e991ffe7fdfd53831a2a36a7eb356508c8/flatten_dict-0.5.0.tar.gz"
    sha256 "ca89664d0bc9552d525ee756726b5a755c17f65b5bf23d0a1f07841f181428b7"
  end

  resource "flufl-lock" do
    url "https://files.pythonhosted.org/packages/82/c5/a2970cea7d0c0369da6c22b6fc6c6f04c06bd71bfc25e417157c0d4f60d2/flufl_lock-9.1.0.tar.gz"
    sha256 "8d73c88cab7c98b7926710299c1162bec7ce253f9b9c5f0a2ca8037f9f240234"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/03/2c/c704bc76973088cb17b663a467aab7e2d46a999d647116db145daa2121ed/funcy-2.1.tar.gz"
    sha256 "8979feb3de7120afd1d00e5a8eae810c1942e4bfbc91697151e9ee1e49f79284"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/d0/08/cb32ace6483b8016e8954f009f133799d299dc1bb35b310ced04bd46a925/gcsfs-2026.8.1.tar.gz"
    sha256 "738da7dcc74817c7668d032f932598482a23cce1b061c537e54278be44d2fff8"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e0/db/3ca813cbacb23ab6fe46ff38a9b5ef8e73e970c8051f2ce903aacafe0446/gitpython-3.1.62.tar.gz"
    sha256 "1791de66309bc0c7cfca40bf8d2e3de7ca091cbf94e6051be1ad0722c61062af"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/44/8d/cbdc715cdfb7acd7ccf1ce2869b103734c6a3cf124afd021f56c10c17522/google_api_core-2.39.0.tar.gz"
    sha256 "824ee414a10adefefae33fc5e2ba28dc6f0f7089d011c9cc98ea9178e61299e9"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/fd/e5/12024a0ae2fd39a54ff47a3868c47344ffff4ff1cd5edf4dff523c1a9fc1/google_api_python_client-2.200.0.tar.gz"
    sha256 "82aa18b851328ea04867fd51c5a0c8da2e1b86ec45ce08487e902e7726d4ee50"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/3b/0b/9b4e806ebcd29701b5193a162dd9906c4c5a16cbde8476461622d2bfa70e/google_auth-2.59.0.tar.gz"
    sha256 "eb32f44f89f6b577947ebee5887c1db46e6b1a278889ba369a88179643f32240"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/d4/74/0c8177b73734dfbd89420c162ac8754257fa0f9007fb49569493d83a17db/google_auth_httplib2-0.4.2.tar.gz"
    sha256 "916225a6367e613c9af44d83f41688a599d3f687777846b8b91bec65085ed1f1"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/dd/fb/e8def92f788410d96d1aff0cadfadb3f044bbffbe3d2560a1ad8fa0d9466/google_auth_oauthlib-1.4.1.tar.gz"
    sha256 "1a83f5f2a8421dedadaa3caf25b3a710dddf85a33a63144be41c2fc79174b106"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/f9/54/790548b190cff9cf07225c811d2668eacd8f2cbf04114475cbe3e5738752/google_cloud_core-2.7.0.tar.gz"
    sha256 "874aaf89765db87a9b911b7a2ca7c5068554868eed9e75c7766affe342a2913d"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/5c/b9/de4f0a218485bdbac839ad337166997171471a29c7d28c03b41b37830379/google_cloud_storage-3.15.0.tar.gz"
    sha256 "110041ee1cb566114015aa7c2492f1ff18c92af528588386663f4b41b6279989"
  end

  resource "google-cloud-storage-control" do
    url "https://files.pythonhosted.org/packages/b0/b1/95f5bd878537dffa80c96d67d4a87b4bd273630e1e52f84a40602206448c/google_cloud_storage_control-1.15.0.tar.gz"
    sha256 "e3d50276f0aed0c33ebcf3c6221e933889e042df70a56886ddffe59c66889183"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/fa/25/9cb0c1c31c45b893eb8f11ae70b3f4309432d59b5acaebca5dbe791729a4/google_crc32c-1.9.0.tar.gz"
    sha256 "7b8c84c3d159ab6817fe3f74e6e6cef099c3f95dcec3abc0d8afb1404642efbe"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/17/4b/44e128cd7b0e72cd26da4a3052cd8a9ef1b5a890be7c611558067ea0b354/google_resumable_media-2.10.2.tar.gz"
    sha256 "1de441703cd298d75a419bfdc0066e9fc7b0a1de630df96eea8ce8f5c759358c"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/4b/13/f83676de1dce4f8106bcba91725b3f3f4baf6ca1977685102b008b8e0097/googleapis_common_protos-1.75.4.tar.gz"
    sha256 "4587babdc82a8d7e5a3d4f5a6697e064bf44a598b4d08341c212b68185eadbcd"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/95/0e/4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659/grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/d2/d0/fa5bdd5f3f421bb68dc6dc162e9caaf942897ca41ce7255b524723c80f0b/grpc_google_iam_v1-0.14.5.tar.gz"
    sha256 "07fd3a9fafb586588e771831fbfc8f6597050181d0c3b45e039d18b8fdc1aab5"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/3f/4f/4435c0aae54657258d9cfcba78598f3d9e5fe4c82ff18d78558567b90faf/grpcio-1.84.0.tar.gz"
    sha256 "19aaf172fc2edbefccce3f6e92c5150975dbe56c45744e9e87cf72ebdf85bfbe"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/52/45/f80309cdb6a7dbf8f65e2082dd2ddc9797ba7180516a73c54d966ba632c4/grpcio_status-1.84.0.tar.gz"
    sha256 "5caf28ba7184b81f618b5f7f094859fd2541bf429d2189bbbcd715c9c2cdcee2"
  end

  resource "gto" do
    url "https://files.pythonhosted.org/packages/66/9c/cf74e391f76ff2afd7aee9bdd0f1b191c0522ba8190439bfa3b2672f222a/gto-1.10.1.tar.gz"
    sha256 "e2a008650e7be42b7e3dd65e2eef360d466553e3b41d8f37dae38328d84fd224"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/84/f5/ccf58de92d61e3ad921119668f54ed36ca1d0cf5dcc5c1657dfb164fd78b/httplib2-0.32.0.tar.gz"
    sha256 "48a0ef30a42db65d8f3399045e1d09ab0ba66e3b9efc360d07f80ea55d286025"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hydra-core" do
    url "https://files.pythonhosted.org/packages/5c/a9/fe2c936f36881e3197a8800f5bfba078d7846d54eb5d009b445eda1ee281/hydra_core-1.3.7.tar.gz"
    sha256 "d4ff629c7e23b64a9db5fe5b027cf7c55b633b737f03be51ef41b77ed016f75e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "iterative-telemetry" do
    url "https://files.pythonhosted.org/packages/d2/b6/f17d6e80252b7be6ca4d9463db226ce7863d26287f16f1347e981cd2f3d8/iterative_telemetry-0.0.10.tar.gz"
    sha256 "7fde6111de6fa4acf5a95a6190cc9cc5d17d835a815f0a18ece201f6031f4ed6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/58/ce/0e9597a4b2348dade473d3e177ce32ca570f67b479ab9a292a90cb88f892/knack-0.14.0.tar.gz"
    sha256 "2ddd32fd6343ec9b6ed0da729b212362d0e6b1208c0162633c90cb6f94a05877"
  end

  resource "kombu" do
    url "https://files.pythonhosted.org/packages/b6/a5/607e533ed6c83ae1a696969b8e1c137dfebd5759a2e9682e26ff1b97740b/kombu-5.6.2.tar.gz"
    sha256 "8060497058066c6f5aed7c26d7cd0d3b574990b09de842a8c5aaed0b92cc5a55"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/85/747d28986a44b715cc51cf57aa021c8fd94e9614064261ceec77320e8b0b/msal-1.39.0.tar.gz"
    sha256 "6ab7de335e6d7f5717e2c7e1dbf86e4dda2f6acf3c56773b78dc53ebc6395b5f"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/99/1d4d69c3512d0ddbfa3a1b69cfd9a151012ab2eb4eabbb096201b1f0b7d8/multidict-6.9.1.tar.gz"
    sha256 "0f06e60fa190aa7abd0914c2a766736fdc8e9f34878c4346338534b73d1b20e2"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/7a/d8/a1bcc8ba112a627f8ffbdc212a78ce18d3ac07e91a5ca65d27918eee25a1/oauthlib-4.0.0.tar.gz"
    sha256 "efb274799819440f95b4ab3b818869f1ce9ae26c5beacba0201d1a1b76b54f86"
  end

  resource "omegaconf" do
    url "https://files.pythonhosted.org/packages/ce/3d/e4b57b8d9008c6ebe0d5eff901f91d5700cf7bdb8c8863df817463a7fd5e/omegaconf-2.3.1.tar.gz"
    sha256 "e5e7de64aeebeddaf8e6d3f7a783b32ac2a01c0fbd9c878012caecb891a1f42a"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/1f/dc/e12c1fe1ed8a7b7149777127b1a0e12ce5bd5a81d97408bedc2128c260f5/opentelemetry_api-1.45.0.tar.gz"
    sha256 "711ede81773c8025c2c03dac0450bc89f3d30aea6eabcc815c570d4e35a963f7"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/0f/f3/742fb1f62b825f2c010697eaf4e828004bc2a81e7e806666989c132c7c42/orjson-3.12.0.tar.gz"
    sha256 "d14203fb1aae2ad9b3d52f8a0e82aeb10197ef1c9bc61da7f358bd70b00123d5"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/d5/63/b6c355af7f04a8a1d5759fa6fc47539e25ef8e6f2745372a242fdadcac65/oss2-2.18.4.tar.gz"
    sha256 "be1e7a871a8cc267726367333017d78333ee8fae88c727ad61396f59c1c0e4d0"
  end

  resource "ossfs" do
    url "https://files.pythonhosted.org/packages/b1/8a/d0ca844e613d0b8d4b80f8098528a599f2fbf05c3853a75d27d3e645928e/ossfs-2025.5.0.tar.gz"
    sha256 "722e7044fbcd84cc992e5cd6821d5f19bed334216c140d6e46ffb21979d49ce0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/c3/8a/84ef03c1c83eacd7cc4540b05428a93b5cd4e42f62fb0b98ac2cb6ed3a6d/platformdirs-4.12.1.tar.gz"
    sha256 "38da801a4af303033cbffccb39030db22bf0473e6414309b02acebeee7ca8bf1"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/40/a6/4fbadcc2044034449b3f8f0ce82dcf3005d53f37c136642103fd4836a31c/proto_plus-1.28.4.tar.gz"
    sha256 "5ff7ecad828e032a491fcb86947801768e32237f99dd049b649965b892ae9a63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/3d/e3/27f57f80141379d60defe6703eb50a707325706f07fedfd1312c7a751995/pyarrow-25.0.1.tar.gz"
    sha256 "9150a83248bfed9813ea3c3af74c3856c1984d444aa28e58bf7733b9750ddf6a"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/ca/31c57507b13119d7d3cfa1576dad2911a4861e3be07b579395f4e9d393f9/pydantic_settings-2.15.0.tar.gz"
    sha256 "694b793e84f766ba76a90ebdefc01d0a9a045dab0382bee70393da93712ad117"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/50/35/b17cb89ff865484c6a20ef46bf9d95a5f07328292578de0b295f4a6beec2/pydot-4.0.1.tar.gz"
    sha256 "c2148f681c4a33e08bf0e26a9e5f8e4099a82e0e2a068098f32ce86577364ad5"
  end

  resource "pydrive2" do
    url "https://files.pythonhosted.org/packages/fa/e2/67534dd1e644f170c750546b899963f5fb5f40d9719273eb1ec42a29d44d/pydrive2-1.21.2.tar.gz"
    sha256 "2a21c8319a225943c70e7566eb13a1524d1d7193621de1eb8e5f95e037641508"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/ff/06/31cf0821ada10cb65be108388ddf08d6c6990af90369db26b86776c3e86c/pygtrie-2.6.2.tar.gz"
    sha256 "879264597743ef52bf80f2dff085364088c0848ae22544db95dad2bf52e06471"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/35/d3/d6a9610f19d943e198df502ae660c6b5acf84cc3bc421a2aa3c0fb6b21d1/pyOpenSSL-22.0.0.tar.gz"
    sha256 "660b1b1425aac4a1bea1d94168a85d99f0b3144c869dd4390d27629d0087f1bf"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/f7/fe/ab89ab94cc1293849bc1a60876b589007bdd43f59a06ca309e717bd45dc7/s3fs-2026.9.0.tar.gz"
    sha256 "ec078ff0122d28fd21d36ea4987794e4f42ecd6e8785eeaa083208771c1464e5"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/90/d5/62ab01546616c42d05e11fe133ce80e1d5c5c601bfc391de41f52e32ce66/scmrepo-3.6.2.tar.gz"
    sha256 "750741af151e4c602dbf1456b49c7a1d27844527ba94db1e0c580b167cbd9316"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/92/f5/e1dfe8e1d91c54ce212fd93916eb01fd1c590f413be0a0978c39a97aa1bb/semver-3.1.0.tar.gz"
    sha256 "14bc073439513d7773662a338f4db9829cf16c12b74b9568e2d2689975fbd7fc"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/8c/e2/bcf761f3bff95856203f9559baf3741c416071dd200c0fc19fad7f078f86/shortuuid-1.0.13.tar.gz"
    sha256 "3bb9cf07f606260584b1df46399c0b87dd84773e7b25912b7e391e30797c5e72"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/ef/71/ddb3c0a7a86db44d2fb3f9cbac162f7ddbcbf563b4a174963ba2b3d4d819/shtab-1.12.1.tar.gz"
    sha256 "0637338723a8fc08ed1c2fd826d8432229924649c26e3247bb48c53d60ca3bf9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sqltrie" do
    url "https://files.pythonhosted.org/packages/60/63/ff6509fa8f06bbaa8cffdba4dd9c01bfd9c6af3dc40c95d7669a09d2f659/sqltrie-0.11.3.tar.gz"
    sha256 "358fb71b236311c74598616e071b43b38fc74921e5724c4659e47998e8b27e95"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/b2/70/0f5b8a8b2ba771102fe24f01436626f77d906f3c8338e40e02466a5bee08/sshfs-2026.8.0.tar.gz"
    sha256 "1a52db45dce437c62d4a47cb8b4f72bc230300acda536a6d3bac984795262917"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/e4/31/3d74fa778a63b98b7374323befcc0be5ab3bd94afd4096a0124e7379152c/tzdata-2026.4.tar.gz"
    sha256 "f1b8bd365d8d210c55353f4d7f8d6d8561c0ba50d704b700d195a9424bba0d79"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "vine" do
    url "https://files.pythonhosted.org/packages/bd/e4/d07b5f29d283596b9727dd5275ccbceb63c44a1a82aa9e4bfd20426762ac/vine-5.1.0.tar.gz"
    sha256 "8b62e981d35c41049211cf62a0a1242d8c1ee9bd15bb196ce38aefd6799e61e0"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/92/f4/0738e6849858deae22218be3bbb8207ba83a96e9d0ec7e8e8cd67b30e5ca/voluptuous-0.16.0.tar.gz"
    sha256 "006535e22fed944aec17bef6e8725472476194743c87bd233e912eb463f8ff05"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/dc/ac/3a943d2792c9bb368aaa8b50121c0f778460ba2d7fbdc0a0366201d9e761/wcwidth-0.9.1.tar.gz"
    sha256 "5823209b0d43af322ce698c689380d7c15ca31fa8e6e3be8459f27031bef0af5"
  end

  resource "webdav4" do
    url "https://files.pythonhosted.org/packages/bb/2d/3d20527d81b25ef039ac92c15f4b9c8760b099e4e0fbf2b1d5d24ef78c3f/webdav4-0.11.0.tar.gz"
    sha256 "7062c6640e0520bfbd49862bdd335db839e519bf2ca02cd4f89957069ed600ea"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/3e/d2/a254a26d8ceaea87e0eee2e89fcfe53ddc1858418647493bb2937549ab6f/wrapt-2.5.0.tar.gz"
    sha256 "c48cdb6c904dca76d9915a579e4a5fab6b0c25f650c1019ce78a78effaf7a345"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/10/9a/2fef89272d98b799e4daa50201c5582ec76bdd4e92a1a7e3deb74c52b7fa/zc_lockfile-4.0.tar.gz"
    sha256 "d3ab0f53974296a806db3219b9191ba0e6d5cbbd1daa2e0d17208cb9b29d2102"
  end

  def install
    # dvc-hdfs uses fsspec.implementations.arrow.HadoopFileSystem which is
    # a wrapper on top of pyarrow.fs.HadoopFileSystem.
    ENV["PYARROW_WITH_HDFS"] = "1"

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/3.0.0/scripts/build.py#L23
    File.write("dvc/_build.py", "PKG = \"brew\"")

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dvc", "completion", "-s", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/dvc doctor 2>&1")
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