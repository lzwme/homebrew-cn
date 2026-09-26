class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https://domainaware.github.io/parsedmarc/"
  url "https://files.pythonhosted.org/packages/12/a0/d1bcff7569c4ec6d9825bd83e25b0f3563e922b757d95bc75b2e28c10638/parsedmarc-11.0.3.tar.gz"
  sha256 "3e70ffe7e0f7bda24915d51e042f97fdd5f5dfa2df1672c5cd439e679d90e6e6"
  license "Apache-2.0"
  head "https://github.com/domainaware/parsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9a498d2a8140541f05b13c5fc0fc5d00f3902075ec3d0df2c061d8c88ff2ea5b"
    sha256 cellar: :any, arm64_tahoe:       "046e8af7c40be8df44d9b1651b49476e2b502a3144ebe5aecc142d32e500458c"
    sha256 cellar: :any, arm64_sequoia:     "6dac3aa7d94baea40a531c5ae4792c3517328e0da25146d89099ea11d8b189e4"
    sha256 cellar: :any, arm64_linux:       "d093ce2311569022dcdd84668695fcdce3f5b91602463e89fca8d0ff82035f8a"
    sha256 cellar: :any, x86_64_linux:      "e55cb5846b02e26915afe49de99e673665a1b9de0266238cfeefea2a1f8d5930"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:     "parsedmarc[all]",
                exclude_packages: %w[certifi cryptography]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/58/d9/22ce5786ac0c1653ae8b6c23bded02c1686d11f0dbb45b31ce128e0df985/aiohttp-3.14.3.tar.gz"
    sha256 "9491196535a88924a60afd5b5f434b5b203b6cc616250878dbdb223a8f7844bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "authres" do
    url "https://files.pythonhosted.org/packages/6a/29/e28209b5d3d56c102845cca5a4a3abaf2724f79e83476a52b94d775ecce6/authres-1.2.0.tar.gz"
    sha256 "93d1b995ad7ce21e62db649f361048125dd6022563a0ae8a23909465f1fd25b7"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-monitor-ingestion" do
    url "https://files.pythonhosted.org/packages/71/a9/71d9da3ab13db73e3d4f344f9e4a06bc220d7fe7de8f96264d36ae2189d1/azure_monitor_ingestion-1.1.0.tar.gz"
    sha256 "97afee780d9ae3069128cde77027d4cc62fa824fe64d5bac880ac4a64b0a0c4e"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ad/ef/096f1520a4b0cbc794348fcf77ada637e5f98145c3453f219d678c3a0798/boto3-1.43.101.tar.gz"
    sha256 "49f3eb750f70e050df9929a7e9392e67896c97d7d0a448f13ed3354c634268bd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/12/12/e90cc51bd65ecdcd0eedcd522d3c9f102b1d2c601f39f1f1c256695d63a3/botocore-1.43.101.tar.gz"
    sha256 "3bc67fb55046e1e05ce5f2bd0171f37bef1cf54161786ef04ff338614d98169e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "elastic-transport" do
    url "https://files.pythonhosted.org/packages/fc/63/c61700c42f74d70a4ae11394c619cf91b837b500144166e828546f1fdd8d/elastic_transport-8.19.0.tar.gz"
    sha256 "32afed2a70dad80511476c821b2cf823f35a82153289765f6b2e2eb8cb0de099"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/6b/79/365e306017a9fcfbbefab1a3b588d2404bea8806b36766ff0f886509a20e/elasticsearch-8.19.3.tar.gz"
    sha256 "e84dd618a220cac25b962790085045dd27ac72e01c0a5d81bd29a2d47a71f03f"
  end

  resource "events" do
    url "https://files.pythonhosted.org/packages/25/ed/e47dec0626edd468c84c04d97769e7ab4ea6457b7f54dcb3f72b17fcd876/Events-0.5-py3-none-any.whl"
    sha256 "a7286af378ba3e46640ac9825156c93bdba7502174dd696090fdfcd4d80a1abd"
  end

  resource "expiringdict" do
    url "https://files.pythonhosted.org/packages/fc/62/c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7/expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/59/e5/18aeff14213db86267a0f79d869352954394ab4ab3a3866d9b9b0e82dc6a/google_api_core-2.38.0.tar.gz"
    sha256 "31e326eafa31b34f1db7a715f50f61dbca7e6e37277762f252ed90e6ce94c246"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/fd/e5/12024a0ae2fd39a54ff47a3868c47344ffff4ff1cd5edf4dff523c1a9fc1/google_api_python_client-2.200.0.tar.gz"
    sha256 "82aa18b851328ea04867fd51c5a0c8da2e1b86ec45ce08487e902e7726d4ee50"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/ac/ca/f398a483ce5aad18ca2f735646e45ccee2439bd94a41a4ad0cfa646bd495/google_auth-2.58.0.tar.gz"
    sha256 "55e30cf15e737de92c5323d78cda8a83fcd57e7ffbaf900c4600039fd60a80fd"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/d4/74/0c8177b73734dfbd89420c162ac8754257fa0f9007fb49569493d83a17db/google_auth_httplib2-0.4.2.tar.gz"
    sha256 "916225a6367e613c9af44d83f41688a599d3f687777846b8b91bec65085ed1f1"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/dd/fb/e8def92f788410d96d1aff0cadfadb3f044bbffbe3d2560a1ad8fa0d9466/google_auth_oauthlib-1.4.1.tar.gz"
    sha256 "1a83f5f2a8421dedadaa3caf25b3a710dddf85a33a63144be41c2fc79174b106"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/8a/c5/4353a188e2c335aee33269e8b654af228278cca8e5f0b4b5f11e5d0e9adb/googleapis_common_protos-1.75.3.tar.gz"
    sha256 "57c435ac2c68b108999b6db075d9053e4d7a936ba57b4a3d45667b1346f1738a"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/3f/4f/4435c0aae54657258d9cfcba78598f3d9e5fe4c82ff18d78558567b90faf/grpcio-1.84.0.tar.gz"
    sha256 "19aaf172fc2edbefccce3f6e92c5150975dbe56c45744e9e87cf72ebdf85bfbe"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
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

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "imapclient" do
    url "https://files.pythonhosted.org/packages/8d/f7/4e2d2e93313d7d7542a8378200ea931ff4e29b730d9eb5a9d8debafcbc68/imapclient-4.1.0.tar.gz"
    sha256 "b7cefa7c9bf3ec029c007dfade191480b82eb3816fc20ab23ef48e7aec841a7f"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "kafka-python" do
    url "https://files.pythonhosted.org/packages/d5/6a/8a3bfb819b5350652dfa5365409b7c611eed8ae0b37c84f53d0a26ae9513/kafka_python-3.0.11.tar.gz"
    sha256 "a003d927e79c801d6cfd1e59ceaaf78807351e75cdb5b8ee9ce4262586f9780f"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "mail-parser" do
    url "https://files.pythonhosted.org/packages/99/29/e8679edafd8dcb21b5dced06ab6ab3c0c8b2075766a403338c9c1130a0b5/mail_parser-4.6.5.tar.gz"
    sha256 "184100c23e136bd167b490791d4089f6294893cda5d5a88c5dd4999f559a4123"
  end

  resource "mailsuite" do
    url "https://files.pythonhosted.org/packages/10/93/2c5c89ca06c0274247d4de076ea73a5476c117b08dc7f31430c8f653faae/mailsuite-2.3.2.tar.gz"
    sha256 "ff415d2619bebaef77bfdbb2648656f3ae504e65e99fe8e7df3c3201cecec1da"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/b9/34/0923a42cce579398890058775ea145214acf80dd3340c26cfb0f16989300/maxminddb-3.2.0.tar.gz"
    sha256 "d28e0073fd1dd637c8b95947bc864b5625eca9f8f2db1538145e33b2a1cd4b92"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/cc/f1/106e5522a196257d67f6c349617b41a9f3a636efe5ac1027f2e154366450/microsoft_kiota_abstractions-1.14.0.tar.gz"
    sha256 "620bee999233b7a5e3c09c61be2f934b94028fa17e9357882423677954e81e24"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/c5/81/d3f3ef77609c2693c01c53e2cf6dc9b76bd0ca93c0c0f68a363444d65182/microsoft_kiota_authentication_azure-1.14.0.tar.gz"
    sha256 "7a1f7934d51d564ed28dff61426305db190d634ff2e57a5e6384777f68b4e35f"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/93/8b/6a222510f5121794c6e223001c3a504fb6a2b289329c6f526fd9461842a9/microsoft_kiota_http-1.14.0.tar.gz"
    sha256 "40f2a72570eb3bd09c3b7134bcc476cb0c19478077712770d0844b11078b83e0"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/c9/2e/6bb8637e095862dfe43bb9bf6fcae2358fa781ee483155360bbb7661df92/microsoft_kiota_serialization_form-1.14.0.tar.gz"
    sha256 "156f9329c68e518b1f6e69629cb0231df17d3a8fbb0b2a7d5b544842b4c40796"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/15/c6/2496a7d438dc3a8631d7d155c0cfb9888f841838f2dd5c16d1a724f8157d/microsoft_kiota_serialization_json-1.14.0.tar.gz"
    sha256 "e4f4a97cfdbfafaefcc76b7a55952385293d8b588b9fe82a7c1853fff8f14cf8"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/c1/97/f048894a5a65987429dff615bfe28d3fe371a2dc6e2f7287104fbf5c3879/microsoft_kiota_serialization_multipart-1.14.0.tar.gz"
    sha256 "f2f7c596afa86a9236717e8822cf200fbd06e54508f819adecf083145991185f"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/c4/13/e6f4d0cc5a8eb566b6c1fdbb83286b6f930f007d8b0ad65f3e96d3c29e1d/microsoft_kiota_serialization_text-1.14.0.tar.gz"
    sha256 "51b7fbc368ac2ed095e8f9eef5b9c25a83bdf7dad5787bf674db6526673dcebc"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/85/747d28986a44b715cc51cf57aa021c8fd94e9614064261ceec77320e8b0b/msal-1.39.0.tar.gz"
    sha256 "6ab7de335e6d7f5717e2c7e1dbf86e4dda2f6acf3c56773b78dc53ebc6395b5f"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/ec/99/702da0cb467040e754ad5342a7ee6e799aacf8d0f4161dd25ad3b1e7be76/msgraph_core-1.5.1.tar.gz"
    sha256 "1eecc9089ead63ab9cfca4cfb0751fc664088d6a53fc9ee1fc0574eddfba030b"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/77/b1/51df7e47ffe1bc7c8dcfca33a6e17569df217cb05120d29087a7affbbd64/msgraph_sdk-1.63.0.tar.gz"
    sha256 "ce722c38dfce971e39c576a878f4f25abeda14a1b3de3b2891da081a8d9a0a79"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/99/1d4d69c3512d0ddbfa3a1b69cfd9a151012ab2eb4eabbb096201b1f0b7d8/multidict-6.9.1.tar.gz"
    sha256 "0f06e60fa190aa7abd0914c2a766736fdc8e9f34878c4346338534b73d1b20e2"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "opensearch-protobufs" do
    url "https://files.pythonhosted.org/packages/d8/2f/e0cc165af7bb7b44cb00023b9fcaa01a28d1755a059ede28d0cd970c3cec/opensearch_protobufs-1.2.0-py3-none-any.whl"
    sha256 "e806730894d0a0c8cdaa3cdbe07e4b7c46e1823f453777b36caf39e9cba28e2c"
  end

  resource "opensearch-py" do
    url "https://files.pythonhosted.org/packages/82/9e/e77844cb2d625ca32331bfdd28930113b3778399c01dd5f1c350ceb55e65/opensearch_py-3.2.0.tar.gz"
    sha256 "f40fb3a295275422df2ad6d9459f667af94472d5a9e567072e9ecf163eb22613"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/ee/8b/aa9e2d8b8dfa7c946f7dec5d1f8f6ba8eca062f43509a06bdb5ce93d26c0/opentelemetry_api-1.44.0.tar.gz"
    sha256 "67647e5e9566edcf421166fdf022b3537f818635daa852b289e34604dc6fb33a"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/5d/77/a6592cbc7c8d9bcc9d6757a9df45e04a7c585e3e6e7a13456da522b21109/opentelemetry_sdk-1.44.0.tar.gz"
    sha256 "cebe7f65dc12f26ead75c6064de12fd2a9052e5060c0272d402cfa203aae123b"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/8f/73/0cbdebcb4cf545fdd328da14f5137e37d0770c3f26185e478b0d15d94f50/opentelemetry_semantic_conventions-0.65b0.tar.gz"
    sha256 "f9b2b81e9d5b64f11bc952075e7e9c7fb0aab075c7fd1c46d597f1b919852d60"
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

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/e0/2b/4233b6022599eb25a11bb5e0613de2efe9f2a8d2919b02e024a9e383e5ea/publicsuffixlist-1.0.2.20260922.tar.gz"
    sha256 "f471784adb84337d9b96e9d237faa7f0bf9497bd7f44cc4fe52140a834fd0035"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pygelf" do
    url "https://files.pythonhosted.org/packages/49/91/ac1605bb40092ae41fbb833ee55447f72e19ce5459efa6bd3beecc67e971/pygelf-0.4.3.tar.gz"
    sha256 "8ed972563be3c8f168483f01dbf522b6bc697959c97a3f4881324b3f79638911"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/02/a5/5197bfd06417837ac079921c66fa6393f1dea3557272a263cebfef69e432/pyjwt-2.15.0.tar.gz"
    sha256 "b11c5f9791d7bf51c2b39a81ed669f6b2dbbd669df2942f6c60167e9e3d1abe4"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/7a/f8/8f2b708394a6371e9b0e1cabdaf1be314f6b28c3697786a0a7e5f31ee9bf/std_uritemplate-2.0.12.tar.gz"
    sha256 "c245e6d9c6804e435c45fa94ee4a3c8a57e08aeeb45af261101cb0d513964534"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parsedmarc --version")

    touch testpath/"empty.xml"
    output = shell_output("#{bin}/parsedmarc empty.xml 2>&1")
    assert_match "Failed to parse empty.xml", output
  end
end