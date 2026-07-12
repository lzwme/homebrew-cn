class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https://domainaware.github.io/parsedmarc/"
  url "https://files.pythonhosted.org/packages/99/38/1efb0b58a273090fe6a110d90c1dbf2ba1c9823c2a1672df4ed73ba92d89/parsedmarc-10.2.1.tar.gz"
  sha256 "08fc9ce3df6f3d4032df07c89edb36be0d512eea4bb43dc292be6af3cc2cb5ef"
  license "Apache-2.0"
  head "https://github.com/domainaware/parsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ab9fa648fc52f7521055264a01166501697191bcacebc434e4ee908eb76baa9f"
    sha256 cellar: :any, arm64_sequoia: "d08333dfc256722878cf18ebb83233f309286904d545e508d0c55445ffccbfc3"
    sha256 cellar: :any, arm64_sonoma:  "21877db80f2e36f9ea976c022dc37b41eff2bcdb761dc906d837432386bbcabb"
    sha256 cellar: :any, sonoma:        "002597dacc7b319bec39b0e14608e04e6e15d5d5bfada0b6cd0d7a7ccd43bd98"
    sha256 cellar: :any, arm64_linux:   "0f99bbecc5e39b905455667333031bf6730336f4a521f28af5fde695f3fa37e9"
    sha256 cellar: :any, x86_64_linux:  "3781e387cfc199b626fcae94008f60744633a5dcdbdc761557ac862c66d48ac2"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/82/78/8ea7308cac6934de8c74a14f3d5f65d1c89287426688be79538d0e5c013d/aiohttp-3.14.1.tar.gz"
    sha256 "307f2cff90a764d329e77040603fa032db89c5c24fdad50c4c15334cba744035"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/3b/72/5562aabb8dd7181e8e860622a38bea08d17842b99ecd4c91f84ac95251b0/anyio-4.14.1.tar.gz"
    sha256 "8d648a3544c1a700e3ff78615cd679e4c5c3f149904287e73687b2596963629e"
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
    url "https://files.pythonhosted.org/packages/cb/c0/bcbe0a924ed89f8982a87727cd0f88a73397fa423a60df17ae76aa013514/boto3-1.43.45.tar.gz"
    sha256 "65e0ae541a9948ac41b706d5c7165d96ebf155812562b6518b862be027ee7347"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/25/fa/fb07ee4025ec257ff7b45d40411a922c86da3a4eaa98783da74404071d99/botocore-1.43.45.tar.gz"
    sha256 "a2da80ff3caa2873769b9a32ae5f1fb18b3571ab63a981896639955611ca01e6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/d3/f4/561c49bca97af561d34eed27e3e831135eb5cb88e754c1150be41820f5c6/dateparser-1.4.1.tar.gz"
    sha256 "f265df13c0380e2e07543ba74b67c0681aaa1096981ffcd35227e1aa0cb81c7c"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/06/50/220b2d903eccaf6065b4d2d546c06d216e3c8eabcb8d9cd56af691cb712b/elasticsearch-7.13.4.tar.gz"
    sha256 "52dda85f76eeb85ec873bf9ffe0ba6849e544e591f66d4048a5e48016de268e0"
  end

  resource "elasticsearch-dsl" do
    url "https://files.pythonhosted.org/packages/ea/a1/86b304895d346eb5d4c51584f7d3f02ba91131efbe2545e867b62275976b/elasticsearch-dsl-7.4.0.tar.gz"
    sha256 "c4a7b93882918a413b63bed54018a1685d7410ffd8facbc860ee7fd57f214a6d"
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
    url "https://files.pythonhosted.org/packages/c6/22/155cadf1d49272a9cf48f3168c0f3874fa13397297e611a5ea00cd093880/google_api_core-2.31.0.tar.gz"
    sha256 "2be84ee0f584c48e6bde1b36766e23348b361fb7e55e56135fc76ce1c397f9c2"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/6b/53/0cd38e3a29d72ce45e27feba2ce1cd8049d69af9c48cb14fb164f1be9133/google_api_python_client-2.198.0.tar.gz"
    sha256 "dfe3e16fb241af6e9c460a33f65085b3450e05cea09364f6b5d8997fb7e43e2a"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/79/b9/e370d86fea3da13ec0256df30323dd26c0cb9c8c85f0c6ec42ac9df0106b/google_auth-2.55.2.tar.gz"
    sha256 "97ae7790ff740f2bc9db60eb864a7804f4ac19f5f02c38b3d942f2fea6e9b9ae"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/1c/b3/f192c8bc7e41e0ebdbd95afcae4783417a34b6a6af62d22daf22c3fd38fc/google_auth_httplib2-0.4.0.tar.gz"
    sha256 "d5b030a204b7a4b4d553ba9ca701b62481ee2b74419325580be70f7d85ffed35"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/70/18/90c7fac516e63cf2058166fce0c88c353647c677b51cc036c09c49bb5cbb/google_auth_oauthlib-1.4.0.tar.gz"
    sha256 "18b5e28880eb8eba9065c436becdc0ee8e4b59117a73a510679c82f70cd363d2"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/90/bc/656b89387d6f4ed7e0686c7b64c2ae7e554a759aa58122c8e5fb99392c32/grpcio-1.82.1.tar.gz"
    sha256 "707b24abd90fcb1e45bcc080577da1dbf9971d107490589b9539af8e1e77b4b5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/1d/17/afa56379f94ad0fe8defd37d6eb3f89a25404ffc71d4d848893d270325fc/h2-4.3.0.tar.gz"
    sha256 "6c59efe4323fa18b47a632221a1888bd7fde6249819beda254aeca909f221bf1"
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
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "imapclient" do
    url "https://files.pythonhosted.org/packages/58/79/8138f8c91e791f49cf4c2269b1eaaaddb93013d162e92ddc249b84d38105/imapclient-3.1.0.tar.gz"
    sha256 "b0413a516ffcc4b4d69f2c611c0e95da57968edf5a5c78ac82d1bf882305facc"
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
    url "https://files.pythonhosted.org/packages/86/61/c5132aae897587d9135322ca66d46f14f5d4f11fef41b24963f1a5ab43d1/kafka_python-3.0.8.tar.gz"
    sha256 "0e9d89d40ae1cb45eae2f89fa9abff919c49d54299a6b3774b5261d6d6ff11e2"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "mail-parser" do
    url "https://files.pythonhosted.org/packages/9c/6e/2cee08e0d6fbce02a301d5ab72ef5ffe8f47dd59ac3d8ce61324d8a9143a/mail_parser-4.4.0.tar.gz"
    sha256 "82d2c0fa98a138620feaa87a378af2a2643b2941b2e125d7abfc65dd21094b33"
  end

  resource "mailsuite" do
    url "https://files.pythonhosted.org/packages/9c/8f/e0119c739835bc0c7077e8c2f37a167771efbe65de090dbc8c70009f1bce/mailsuite-2.2.2.tar.gz"
    sha256 "d1a45d3539e72022a5ee0966e9deb66924363f6121a3041a963d54725773e103"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/31/83/bcd7f2e7dfcf601258a4eab92155816218e8f8adf6608d5f7d39da7ba863/maxminddb-3.1.1.tar.gz"
    sha256 "b19a938c481518f19a2c534ffdcb3bc59582f0fbbdcf9f81ac9adf912a0af686"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/da/1e/cc7e180dd044fed808663d4433f024f07f9dbf190923324c528101173127/microsoft_kiota_abstractions-1.11.7.tar.gz"
    sha256 "04fc310c3f4d28fc4fe3de56fbe734aa359ff08f28fe20bf1ddd9b71228038dc"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/79/ed/5c9c7ce16070c41b284d22969c1d3738049a0a015703b42e8689fe81d98d/microsoft_kiota_authentication_azure-1.11.7.tar.gz"
    sha256 "1052ea952955475a164ba4486085e0de9fcaa978c7c0b73202bc6a9eabd9b412"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/15/5a/ba9934a75da29a861856ac7aa11d970b04092786bf42bbf8d7ba6b6ac56e/microsoft_kiota_http-1.11.7.tar.gz"
    sha256 "0f6563db3c86ea5bb95798a4eccea50b0233d403af0ac1dc461be6bf6333cecc"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/e9/f0/870b13f491d1dfd710a5c186a5c253f91b15ce62e8108a19ccedfbecc36f/microsoft_kiota_serialization_form-1.11.7.tar.gz"
    sha256 "817899bc08f11287ef27707f2c28b1469ef7fdac285aa94ad88301a1073f4a4e"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/f6/de/ae5f3e18b80a4fe9620d3813f6c2c8c5da7e9ac6fa2cb66029be778bdf30/microsoft_kiota_serialization_json-1.11.7.tar.gz"
    sha256 "73cffbaf784e5626124e9d0a7012c99b4bf2d035d4ed03efbd00d85643642d24"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/a5/f4/54db286be36a7583b77cdf0b13b048bd9449a3a1b910e7ce9ba48f56f21a/microsoft_kiota_serialization_multipart-1.11.7.tar.gz"
    sha256 "f4455a3f8de6329167ee459e454a6d1a13c0d7aea31b597d0b665227e9f01507"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/59/0c/28e7b67dc4541dff0560a64416da7c6d087b8ca34738d6b4b3706592409b/microsoft_kiota_serialization_text-1.11.7.tar.gz"
    sha256 "3def21c2552c886a16db42aff51e6cde10eca82a06edec1ef83f9810eff3bfb9"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/9a/99/d840198ecf6e8057bbc937f129ae940404485d736cda73253bbff9537f01/msal-1.37.0.tar.gz"
    sha256 "1b1672a33ee467c1d70b341bb16cafd51bb3c817147a95b93263794b03971bec"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/b6/92/e74e204ac240a1817817d50074599af1e0331608c5ee58a1836e40f39c2e/msgraph_core-1.4.0.tar.gz"
    sha256 "5f0dee9564a0e20edfb2eb7137fe189d7d204a80a87d6d83d69d31269376e1b1"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/26/94/a7c46a574e01f13421e54186ec68d6fbe92e7a887bf6ba54e28ce4ba5fe1/msgraph_sdk-1.58.0.tar.gz"
    sha256 "beee4dda22dd8e709a33871fd9aadfcac908a1870a2dab9350734616b59403b1"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
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
    url "https://files.pythonhosted.org/packages/ae/cc/e4c9584181f86494df0f6bdec1a4f3280c50db44704dc2a407e994fc87bb/opentelemetry_api-1.43.0.tar.gz"
    sha256 "107d0d03857ea8fc7c5fcbbbd83f800c281f0d560553d61c1d675fccfd1761c1"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/3e/eb/5041074274ac0956b03637cc039d434569112468e875eddfcc9a0674ce06/opentelemetry_sdk-1.43.0.tar.gz"
    sha256 "d8187c81c162df9913e4003dd6485f7390d9a24fc17026ec7387b8b8218b08e9"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/5a/30/5f26df29509eccd86b99b481ac9ffa39da49ba9577cc69071c552ae30447/opentelemetry_semantic_conventions-0.64b0.tar.gz"
    sha256 "72f76fb2d1582d9d033dd1fcd84532e961e6ff3d90d24ba6fabc72975a83864c"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/87/44/767757fd2cdd4a60d7e4440d9f7b491d6131103d313638d2c03e06c268fb/proto_plus-1.28.1.tar.gz"
    sha256 "832e68e7fe064cf90ab153b6e5eb935b27891bb89aaeb68b115e9b702f6cb168"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/da/01/9ef0afd7999eb9badb3a768b4aedd78c86d4c65cfaf1958ab276199e76b4/protobuf-7.35.1.tar.gz"
    sha256 "ce115a26fe0c39a2c29973d914d327e516a6455464489fe3cd1e51a1b354f81a"
  end

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/64/f2/ca8a37d02c8f3bd43dcc39b4be9de5fd212fe76e38593f0d57e518de7cef/publicsuffixlist-1.0.2.20260709.tar.gz"
    sha256 "92fa6d022f56296039eb5e00a7795d10c0085a7efc1e8f719f0781818374e9fd"
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
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f1/05/e4f219230e11e774a6c9987d2ab0d0c6b8573e13a17e143d0015bee710ef/regex-2026.6.28.tar.gz"
    sha256 "3cb4b6c5cb3060cc31efdc1fbb27c25fb9b29044afd87e40601a1c4d9db54342"
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
    url "https://files.pythonhosted.org/packages/f6/94/dcdaeb1713cab9c84def276cfac7388b17c7d9855bbcfe88d77e4dbafd44/s3transfer-0.19.0.tar.gz"
    sha256 "ce436931687addc4c1712d52d40b32f53e88315723f107ffa20ba82b05a0f685"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/90/4e/243b1eecfc555bff2d0724e2f0484c4ebd647aef1cf2d0406ad550f9ec2f/std_uritemplate-2.0.11.tar.gz"
    sha256 "69fa9e524738d511bb4b94b3e2393ca0524aad118e549259c54db367e05d9852"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ae/5f/57ff8b434839e70dab45601284ea413e947a63799891b7553e5960a793a8/tqdm-4.68.4.tar.gz"
    sha256 "19829c9673638f2a0b8617da4cdcb927e831cd88bcfcb6e78d42a4d1af131520"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
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
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  def install
    venv = virtualenv_install_with_resources

    # Workaround if `numpy` is installed based on upstream fix
    # Ref: https://github.com/elastic/elasticsearch-py/commit/aed94d2af193238221f7c247a3f6114084c92992
    inreplace venv.site_packages/"elasticsearch/serializer.py", /\n *np\.float_,$/, ""
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parsedmarc --version")

    touch testpath/"empty.xml"
    output = shell_output("#{bin}/parsedmarc empty.xml 2>&1")
    assert_match "Failed to parse empty.xml", output
  end
end