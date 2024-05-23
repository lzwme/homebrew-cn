class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https:domainaware.github.ioparsedmarc"
  url "https:files.pythonhosted.orgpackages4f64920c9a6bacd2bf967c19faeb121639c0662501c6d9b95908a1b16c87585aparsedmarc-8.12.0.tar.gz"
  sha256 "9ac71cdd344c62e693aabaf118f09554a6b67e0e6c5f02bf0609696ef2d76cb7"
  license "Apache-2.0"
  head "https:github.comdomainawareparsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6cb544f8361e608c7de45954491bc30e063c68990613e1c1e4fa94ecbd32f1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4108189b6e5b480a9d76d08e03495714e0b2744461d1bff0faf40e4685e0603f"
    sha256 cellar: :any,                 arm64_monterey: "5936998d3ab2b4dc8da65444d474673767556b0914b109b48314729ca9298aa3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d1eeede10259930fabbf77635655397991d67d58ba32b215e646ac99791e9c7"
    sha256 cellar: :any_skip_relocation, ventura:        "c09c755719f1d51e33dbe719771eb4f69a18f8018f234782d2c28577e2dfd4cd"
    sha256 cellar: :any,                 monterey:       "87624454fb83c52e378847f29b83e10465a664827170b281f5c5b84289913ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d32249f7df843d9886bfbf4055ea9f9b3865e8909badd95b24325b0558e5ee82"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages04a4e3679773ea7eb5b37a2c998e25b017cc5349edf6ba2739d1f32855cfb11baiohttp-3.9.5.tar.gz"
    sha256 "edea7d15772ceeb29db4aff55e482d4bcfb6ae160ce144f2682de02f6d693551"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackages510db76383f028aa3570419edf97ab504cb84b839e3cbc8c8b2048f16bbea2d3azure-core-1.30.1.tar.gz"
    sha256 "26273a254131f84269e8ea4464f3560c731f29c0c1f69ac99010845f239c1a8f"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackagescdf125cba0d1f4ba1f9b9c799c4755400a3e577adcb1470cf5760fcd730b88e1azure-identity-1.16.0.tar.gz"
    sha256 "6ff1d667cdcd81da1ceab42f80a0be63ca846629f518a922f7317a7e3c844e1b"
  end

  resource "azure-monitor-ingestion" do
    url "https:files.pythonhosted.orgpackagesf63a1a4773028d675ef783edede09fe735ff946f8597cdbaf463698597c05b55azure-monitor-ingestion-1.0.3.tar.gz"
    sha256 "89d004a8ff87699b3fd1fcf205aa8ef1e9d34f24a0f3cc374d221471e898743b"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesf209fe22f1a2704edbf370ffa0093e23ffb3fb78704f2e65989d0ba79a41687dboto3-1.34.110.tar.gz"
    sha256 "83ffe2273da7bdfdb480d85b0705f04e95bd110e9741f23328b7c76c03e6d53c"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages68213186c501d87a83dcc1b3df12c9112ee494033c1ed7c051e72414ba6a3212botocore-1.34.110.tar.gz"
    sha256 "b2c98c40ecf0b1facb9e61ceb7dfa28e61ae2456490554a16c8dbf99f20d6a18"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesb34d27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5bcachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dateparser" do
    url "https:files.pythonhosted.orgpackages1ab2f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00fdateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "elasticsearch" do
    url "https:files.pythonhosted.orgpackages0650220b2d903eccaf6065b4d2d546c06d216e3c8eabcb8d9cd56af691cb712belasticsearch-7.13.4.tar.gz"
    sha256 "52dda85f76eeb85ec873bf9ffe0ba6849e544e591f66d4048a5e48016de268e0"
  end

  resource "elasticsearch-dsl" do
    url "https:files.pythonhosted.orgpackageseaa186b304895d346eb5d4c51584f7d3f02ba91131efbe2545e867b62275976belasticsearch-dsl-7.4.0.tar.gz"
    sha256 "c4a7b93882918a413b63bed54018a1685d7410ffd8facbc860ee7fd57f214a6d"
  end

  resource "expiringdict" do
    url "https:files.pythonhosted.orgpackagesfc62c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "geoip2" do
    url "https:files.pythonhosted.orgpackagesa7ae892642e21881f95bdcb058580e74aaa3de0ee5ee4f76ccec02745f2a3abegeoip2-4.8.0.tar.gz"
    sha256 "dd9cc180b7d41724240ea481d5d539149e65b234f64282b231b9170794a9ac35"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages31c6460b83c297c91c4f62d69aa9f04f3c5f8139a4f41c4b747c014939d5a802google-api-core-2.19.0.tar.gz"
    sha256 "cf1b7c2694047886d2af1128a03ae99e391108a08804f87cfd35970e49c9cd10"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackagesc29756b0c6661e0b60e9d743a2eed018329a5265bd37d1b14969ef53cd06239bgoogle-api-python-client-2.129.0.tar.gz"
    sha256 "984cc8cc8eb4923468b1926d2b8effc5b459a4dda3c845896eb87c153b28ef84"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages18b2f14129111cfd61793609643a07ecb03651a71dd65c6974f63b0310ff4b45google-auth-2.29.0.tar.gz"
    sha256 "672dff332d073227550ffc7457868ac4218d6c500b155fe6cc17d2b13602c360"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackages44777433818d44cadd1964473b1d9ab5ecea36e6f951cf2b5188e08f7ebd5dabgoogle-auth-oauthlib-1.2.0.tar.gz"
    sha256 "292d2d3783349f2b0734a0a0207b1e1e322ac193c2c09d8f7c613fb7cc501ea8"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackagesd2dc291cebf3c73e108ef8210f19cb83d671691354f4f7dd956445560d778715googleapis-common-protos-1.63.0.tar.gz"
    sha256 "17ad01b11d5f1d0171c06d3ba5c04c54474e883b66b949722b4938ee2694ef4e"
  end

  resource "html2text" do
    url "https:files.pythonhosted.orgpackages1a43e1d53588561e533212117750ee79ad0ba02a41f52a08c1df3396bd466c05html2text-2024.2.26.tar.gz"
    sha256 "05f8e367d15aaabc96415376776cdd11afd5127a77fce6e36afc60c563ca2c32"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "imapclient" do
    url "https:files.pythonhosted.orgpackagesb6630eea51c9c263c18021cdc5866def55c98393f3bd74bbb8e3053e36f0f81aIMAPClient-3.0.1.zip"
    sha256 "78e6d62fbfbbe233e1f0e0e993160fd665eb1fd35973acddc61c15719b22bc02"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackagesdb7ac0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1afisodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "kafka-python-ng" do
    url "https:files.pythonhosted.orgpackages9f19e4a236b7504ef39ebca780c6a11481a3d2db759f9878cb0a4fbc8b08b243kafka-python-ng-2.2.2.tar.gz"
    sha256 "87ad3a766e2c0bec71d9b99bdd9e9c5cda62d96cfda61a8ca16510484d6ad7d4"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "mail-parser" do
    url "https:files.pythonhosted.orgpackages2b3d7f096230c4b61857c7682dc5497000a987b5f7e8376f54f0a5ed73e2cc3dmail-parser-3.15.0.tar.gz"
    sha256 "d66638acf0633dfd8a718e1e3646a6d58f8e9d75080c94638c7b267b4b0d6c86"
  end

  resource "mailsuite" do
    url "https:files.pythonhosted.orgpackages76c99819d416b6eae6332a26390198f7d20cd240b673608612bd01310802f8a4mailsuite-1.9.15.tar.gz"
    sha256 "4789c0a61c9d6a66688d047ba6ba396377598379d82b4f97e6514130952909fc"
  end

  resource "maxminddb" do
    url "https:files.pythonhosted.orgpackages51a0515e51f564a7d0323316296ce43a796c92a60246ffdbab8bb6d2e548b4d1maxminddb-2.6.1.tar.gz"
    sha256 "6c5d591f625e03b0a34df0c7ff81580676397b8335e13ece130c6e39e4a3afb9"
  end

  resource "msal" do
    url "https:files.pythonhosted.orgpackagesb32a76e64e6a5f0d3d12f4b3ab2cfc8b5e4fcb6982d15213aad9c8e6b20ebeaemsal-1.28.0.tar.gz"
    sha256 "80bbabe34567cb734efd2ec1869b2d98195c927455369d8077b3c542088c5c9d"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackagescbba618771542cdc4bc5314c395076c397d67e2bdcd88564c6ca712a2497d1c6msal-extensions-1.1.0.tar.gz"
    sha256 "6ab357867062db7b253d0bd2df6d411c7891a0ee7308d54d1e4317c1d1c54252"
  end

  resource "msgraph-core" do
    url "https:files.pythonhosted.orgpackages3594e2a15b577044b6b0e4b610a26fcd4439863d8d21bda419e0fd24580316cdmsgraph-core-0.2.2.tar.gz"
    sha256 "147324246788abe8ed7e05534cd9e4e0ec98b33b30e011693b8d014cebf97f63"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opensearch-py" do
    url "https:files.pythonhosted.orgpackages192b8acc5612590d7687a2a838e37c1259e3df1b26ea49aae7f3895121a21c1bopensearch-py-2.5.0.tar.gz"
    sha256 "0dde4ac7158a717d92a8cd81964cb99705a4b80bcf9258ba195b9a9f23f5226d"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "portalocker" do
    url "https:files.pythonhosted.orgpackages35000f230921ba852226275762ea3974b87eeca36e941a13cd691ed296d279e5portalocker-2.8.2.tar.gz"
    sha256 "2b035aa7828e46c58e9b31390ee1f169b98e1066ab10b9a6a861fe7e25ee4f33"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackages912d8c7fa3011928b024b10b80878160bf4e374eccb822a5d090f3ebcf175f6aproto-plus-1.23.0.tar.gz"
    sha256 "89075171ef11988b3fa157f5dbd8b9cf09d65fffee97e29ce403cd8defba19d2"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages5ed865adb47d921ce828ba319d6587aa8758da022de509c3862a70177a958844protobuf-4.25.3.tar.gz"
    sha256 "25b5d0b42fd000320bd7830b349e3b696435f3b329810427a6bcce6a5492cc5c"
  end

  resource "publicsuffix2" do
    url "https:files.pythonhosted.orgpackages5a041759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https:files.pythonhosted.orgpackages34be78f21c540b536e6e0fa3f29b3d996dd2ca6e48a406a8124e9b4c1ac8e717publicsuffixlist-0.10.0.20240515.tar.gz"
    sha256 "d0195ba9e7d80e3611216bf95208d34489c3d76975c06a7e9e7c09044e6f6d7b"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages7adb5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49bregex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages86ec535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392dbrequests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesaa605db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackages79793ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afasimplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages5ac0b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages04d3c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackagesd25a4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000ebauritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages390d40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7fxmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}parsedmarc --version")

    touch testpath"empty.xml"
    output = shell_output(bin"parsedmarc empty.xml 2>&1")
    assert_match "Failed to parse empty.xml - Not a valid report", output
  end
end