class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https:domainaware.github.ioparsedmarc"
  url "https:files.pythonhosted.orgpackages36720dfac9b964d4b05be963dcf459392d4ae282d34546acef5784177448245dparsedmarc-8.18.4.tar.gz"
  sha256 "c927ef3e54618ff4b8aea499d49b18345a3f5938538db5f44fabc35cd8d0a94c"
  license "Apache-2.0"
  head "https:github.comdomainawareparsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "084bd3ef23a079eadf21da94d52fd1d088dcc41ad55a6aa82e30dcf4d3cc0b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d6e69b468ea837ea5d8932223f101d0aebac8bbce1a280b53cbc5ce96a23c08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d05ba3d786f4a021f2317b3b970da322138b7d3c92e2760d962b09dd8b918231"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c0ddf6bd87d6bf52529797f9338f74066bac372a13c04033425ef9f8922ba04"
    sha256 cellar: :any_skip_relocation, ventura:       "d9c6402172a300289e8587ee708aa66007169d6af38a937bcc68acce28d4c748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e28897da7bded49d63821536ec361ab90488a29332985a4f0d0debd52605c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2dfdfa4e1f7ce4028c353f48e22e92a7dfd9158d749acf07e00ce350f59bf36"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackageseb6295588e933dfea06a3af0332990bd19f6768f8f37fa4c0fe33fe4c55cf9d0aiohttp-3.12.7.tar.gz"
    sha256 "08bf55b216c779eddb6e41c1841c17d7ddd12776c7d7b36051c0a292a9ca828e"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackagesc929ff7a519a315e41c85bab92a7478c6acd1cf0b14353139a08caee4c691f77azure_core-1.34.0.tar.gz"
    sha256 "bdb544989f246a0ad1c85d72eeb45f2f835afdcbc5b45e43f0dbde7461c81ece"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackages4152458c1be17a5d3796570ae2ed3c6b7b55b134b22d5ef8132b4f97046a9051azure_identity-1.23.0.tar.gz"
    sha256 "d9cdcad39adb49d4bb2953a217f62aec1f65bbb3c63c9076da2be2a47e53dde4"
  end

  resource "azure-monitor-ingestion" do
    url "https:files.pythonhosted.orgpackages7d414faf617e09a90f45c253190e600941bf97f10cfd1a811ec139ae3b54e56bazure-monitor-ingestion-1.0.4.tar.gz"
    sha256 "254d75993a1fe707d198f014aef5a14faa570cee7369b35bb03ae2aa8f99be79"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages47b877a951fdcf732af2982f0f212a9419882163211956069bff9d58e242ce65boto3-1.38.28.tar.gz"
    sha256 "69395075d54be4552719ccadad9f65a3dee5bb3751701e8851d65d71974a791d"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages198c6fb5a271e6da62377fd0e9dc5cff00343ae7c8b83130f14985f7b3924f0cbotocore-1.38.28.tar.gz"
    sha256 "63d5977a10a375c3fc11c8e15e1ae5a4daaf450af135d55c170cc537648edf25"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages6c813747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "dateparser" do
    url "https:files.pythonhosted.orgpackagesbd3fd3207a05f5b6a78c66d86631e60bfba5af163738a599a5b9aa2c2737a09edateparser-1.2.1.tar.gz"
    sha256 "7e4919aeb48481dbfc01ac9683c8e20bfe95bb715a38c1e9f6af889f4f30ccc3"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "elasticsearch" do
    url "https:files.pythonhosted.orgpackages0650220b2d903eccaf6065b4d2d546c06d216e3c8eabcb8d9cd56af691cb712belasticsearch-7.13.4.tar.gz"
    sha256 "52dda85f76eeb85ec873bf9ffe0ba6849e544e591f66d4048a5e48016de268e0"
  end

  resource "elasticsearch-dsl" do
    url "https:files.pythonhosted.orgpackageseaa186b304895d346eb5d4c51584f7d3f02ba91131efbe2545e867b62275976belasticsearch-dsl-7.4.0.tar.gz"
    sha256 "c4a7b93882918a413b63bed54018a1685d7410ffd8facbc860ee7fd57f214a6d"
  end

  resource "events" do
    url "https:files.pythonhosted.orgpackages25ede47dec0626edd468c84c04d97769e7ab4ea6457b7f54dcb3f72b17fcd876Events-0.5-py3-none-any.whl"
    sha256 "a7286af378ba3e46640ac9825156c93bdba7502174dd696090fdfcd4d80a1abd"
  end

  resource "expiringdict" do
    url "https:files.pythonhosted.orgpackagesfc62c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackageseef4d744cba2da59b5c1d88823cf9e8a6c74e4659e2b27604ed973be2a0bf5abfrozenlist-1.6.0.tar.gz"
    sha256 "b99655c32c1c8e06d111e7f41c06c29a5318cb1835df23a45518e02a47c63b68"
  end

  resource "geoip2" do
    url "https:files.pythonhosted.orgpackages0f5f902835f485d1c423aca9097a0e91925d6a706049f64e678ec781b168734dgeoip2-5.1.0.tar.gz"
    sha256 "ee3f87f0ce9325eb6484fe18cbd9771a03d0a2bad1dd156fa3584fafa562d39a"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages98a28176b416ca08106b2ae30cd4a006c8176945f682c3a5b42f141c9173f505google_api_core-2.25.0.tar.gz"
    sha256 "9b548e688702f82a34ed8409fb8a6961166f0b7795032f0be8f48308dff4333a"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackagesdb861bd09aea2664a46bc65713cb7876381ec8949a4b1e71be97dfc359c79781google_api_python_client-2.170.0.tar.gz"
    sha256 "75f3a1856f11418ea3723214e0abc59d9b217fd7ed43dcf743aab7f06ab9e2b1"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages6684f67f53c505a6b2c5da05c988e2a5483f5ba9eee4b1841d2e3ff22f547cd5google_auth-2.40.2.tar.gz"
    sha256 "a33cde547a2134273226fa4b853883559947ebe9207521f7afc707efbf690f58"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackagesfb87e10bf24f7bcffc1421b84d6f9c3377c30ec305d082cd737ddaa6d8f77f7cgoogle_auth_oauthlib-1.2.2.tar.gz"
    sha256 "11046fb8d3348b296302dd939ace8af0a724042e8029c1b872d87fabc9f41684"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages392433db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1agoogleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "html2text" do
    url "https:files.pythonhosted.orgpackagesf827e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107fhtml2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "imapclient" do
    url "https:files.pythonhosted.orgpackagesb6630eea51c9c263c18021cdc5866def55c98393f3bd74bbb8e3053e36f0f81aIMAPClient-3.0.1.zip"
    sha256 "78e6d62fbfbbe233e1f0e0e993160fd665eb1fd35973acddc61c15719b22bc02"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackages544de940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "kafka-python-ng" do
    url "https:files.pythonhosted.orgpackagesce041d65bdf3f0103a08710e226b851de4b357ac702f1cadabf6128bab7518a7kafka_python_ng-2.2.3.tar.gz"
    sha256 "f79f28e10ade9b5a9860b2ec15b7cc8dc510d5702f5a399430478cff5f93a05a"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "mail-parser" do
    url "https:files.pythonhosted.orgpackages428f21059d70e4866dc00284865706d2aec2e06d9bf2eaef11fc8cd153540819mail_parser-4.1.3.tar.gz"
    sha256 "c44a53863a5db1dd266565686169384b1835a9d115d3b50cf1f78fb096090f4c"
  end

  resource "mailsuite" do
    url "https:files.pythonhosted.orgpackages3309b3a97df229007b80187e2571932692911a83c500159e20cf5229c4ae4db0mailsuite-1.10.0.tar.gz"
    sha256 "c58338fcebbdd56b58c22a1b13d8a19581aef1588d4d56d22c51a2f18f723dce"
  end

  resource "maxminddb" do
    url "https:files.pythonhosted.orgpackagesd1107a7cf5219b74b19ea1834b43256e114564e8a845f447446ac821e1b9951emaxminddb-2.7.0.tar.gz"
    sha256 "23a715ed3b3aed07adae4beeed06c51fd582137b5ae13d3c6e5ca4890f70ebbf"
  end

  resource "msal" do
    url "https:files.pythonhosted.orgpackages3f9081dcc50f0be11a8c4dcbae1a9f761a26e5f905231330a7cacc9f04ec4c61msal-1.32.3.tar.gz"
    sha256 "5eea038689c78a5a70ca8ecbe1245458b55a857bd096efb6989c69ba15985d35"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackages01995d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https:files.pythonhosted.orgpackages3594e2a15b577044b6b0e4b610a26fcd4439863d8d21bda419e0fd24580316cdmsgraph-core-0.2.2.tar.gz"
    sha256 "147324246788abe8ed7e05534cd9e4e0ec98b33b30e011693b8d014cebf97f63"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages912fa3470242707058fe856fe59241eee5635d79087100b7042a867368863a27multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opensearch-py" do
    url "https:files.pythonhosted.orgpackages7ce4192c97ca676c81f69e138a22e10fb03f64e14a55633cb2acffb41bf6d061opensearch_py-2.8.0.tar.gz"
    sha256 "6598df0bc7a003294edd0ba88a331e0793acbb8c910c43edf398791e3b2eccda"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackages07c8fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackagesf4ac87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages52f3b9655a711b32c19720253f6f06326faf90580834e2e83f840472d752bc8bprotobuf-6.31.1.tar.gz"
    sha256 "d8cac4c982f0b957a4dc73a80e2ea24fab08e679c0de9deb835f4a12d69aca9a"
  end

  resource "publicsuffix2" do
    url "https:files.pythonhosted.orgpackages5a041759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https:files.pythonhosted.orgpackages8729c3b5e0943cd66b4a0b603151e16105eb62a9bc75ae5a743fe452527d14f2publicsuffixlist-1.0.2.20250529.tar.gz"
    sha256 "d212bd81df675b95950836dcec1aaf062d179f9572b27d304b4f14c0da72637b"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagese9e678ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pygelf" do
    url "https:files.pythonhosted.orgpackagesfed373d1fe74a156f9a0e519bedc87815ed309e64af19c73b94352e4c0959ddbpygelf-0.4.2.tar.gz"
    sha256 "d0bb8f45ff648a9a187713f4a05c09f685fcb8add7b04bb7471f20071bd11aad"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagese746bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackagesf8bfabbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aacpytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesda8a22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesed5d9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191as3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages8b2ec14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackages9860f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese4e86ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392furllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages500551dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958fxmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages6251c0edba5219027f6eab262e139f73e2417b0f4efffa23bf562f6e18f76ca5yarl-1.20.0.tar.gz"
    sha256 "686d51e51ee5dfe62dec86e4866ee0e9ed66df700d55c828a615640adc885307"
  end

  def install
    venv = virtualenv_install_with_resources

    # Workaround if `numpy` is installed based on upstream fix
    # Ref: https:github.comelasticelasticsearch-pycommitaed94d2af193238221f7c247a3f6114084c92992
    inreplace venv.site_packages"elasticsearchserializer.py", \n *np\.float_,$, ""
  end

  test do
    assert_match version.to_s, shell_output("#{bin}parsedmarc --version")

    touch testpath"empty.xml"
    output = shell_output(bin"parsedmarc empty.xml 2>&1")
    assert_match "Failed to parse empty.xml - Not a valid report", output
  end
end