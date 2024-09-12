class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https:domainaware.github.ioparsedmarc"
  url "https:files.pythonhosted.orgpackages299524f5d01195312127ee1c31799987d041c74fdce49f512122b216d465ed61parsedmarc-8.15.0.tar.gz"
  sha256 "676285f23bff0ff4afc1059dd4f19296c01fa3099839de42bef702e2456e2e8b"
  license "Apache-2.0"
  head "https:github.comdomainawareparsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "564fa88726540ae30c6d4506cec438b8f98971e9241f7f5687e494f1e1602100"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bc70c6d85188e9d7fcd7ae56f79e502f65dc04a4bd33fd5c7d0d59cbc7d42d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b07a41df1767ccfe9ef4a6c30805702133780c19f88d0f8ba059616e0167eee"
    sha256 cellar: :any,                 arm64_monterey: "562771a203c97da5f498d8d9f0b488ae21ec1d0d7b506eac34f847e6155b0a9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6780a92ff4df923efbc53825b4bdae819ffdca84beb7c3b9d7ac2dcae7d64ec7"
    sha256 cellar: :any_skip_relocation, ventura:        "9b194965d1ef710b8855eb570bf2efbffa930b5e059091952a265b4fd3eca7d6"
    sha256 cellar: :any,                 monterey:       "693b0c58f374af87f353bd895db562e2f48be01f0ebc88d40be0d52c91e4ed4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8d6b1b9d82d1e3eab92f32cf6730a4c5db0df0eeb91938e1bfbf527f110c8d"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2df722bba300a16fd1cad99da1a23793fe43963ee326d012fdf852d0b4035955aiohappyeyeballs-2.4.0.tar.gz"
    sha256 "55a1714f084e63d49639800f95716da97a1f173d46a16dfcfda0016abb93b6b2"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesca28ca549838018140b92a19001a8628578b0f2a3b38c16826212cc6f706e6d4aiohttp-3.10.5.tar.gz"
    sha256 "f071854b47d39591ce9a17981c46790acb30518e2f83dfca8db2dfa091178691"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackages99d41f469fa246f554b86fb5cebc30eef1b2a38b7af7a2c2791bce0a4c6e4604azure-core-1.30.2.tar.gz"
    sha256 "a14dc210efcd608821aa472d9fb8e8d035d29b68993819147bc290a8ac224472"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackages51c9f7e3926686a89670ce641b360bd2da9a2d7a12b3e532403462d99f81e9d5azure-identity-1.17.1.tar.gz"
    sha256 "32ecc67cc73f4bd0595e4f64b1ca65cd05186f4fe6f98ed2ae9f1aa32646efea"
  end

  resource "azure-monitor-ingestion" do
    url "https:files.pythonhosted.orgpackages7d414faf617e09a90f45c253190e600941bf97f10cfd1a811ec139ae3b54e56bazure-monitor-ingestion-1.0.4.tar.gz"
    sha256 "254d75993a1fe707d198f014aef5a14faa570cee7369b35bb03ae2aa8f99be79"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages02c3ce78127d99b9f64ac3b77c8a9a626150b32bac96c150a2005bf589cf0a50boto3-1.35.12.tar.gz"
    sha256 "b32faab174f6f9b75fada27bcf054ab3e8846bd410ed9817d0b511109326b6b1"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesff3a05ad5df2f4e058ddb75cfc9c5ebb8bcc3d1baf3f06bf6e02e0ab746a218fbotocore-1.35.12.tar.gz"
    sha256 "a8f8230032d090225a93763675a73c208d121bb63ed99f41ee6ad3d51b74b80d"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
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

  resource "events" do
    url "https:files.pythonhosted.orgpackages25ede47dec0626edd468c84c04d97769e7ab4ea6457b7f54dcb3f72b17fcd876Events-0.5-py3-none-any.whl"
    sha256 "a7286af378ba3e46640ac9825156c93bdba7502174dd696090fdfcd4d80a1abd"
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
    url "https:files.pythonhosted.orgpackages781499c2514b3ccc5aad1e0776f0ae8295c9f7153aead4f41d07dd126cecdc14google_api_core-2.19.2.tar.gz"
    sha256 "ca07de7e8aa1c98a8bfca9321890ad2340ef7f2eb136e558cee68f24b94b0a8f"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages99c2efec3de62b53d3ac9709aa4f4e1c475041e973578e0c448fb76355b72c27google_api_python_client-2.143.0.tar.gz"
    sha256 "6a75441f9078e6e2fcdf4946a153fda1e2cc81b5e9c8d6e8c0750c85c7f8a566"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages0fae634dafb151366d91eb848a25846a780dbce4326906ef005d199723fbbca0google_auth-2.34.0.tar.gz"
    sha256 "8eb87396435c19b20d32abd2f984e31c191a15284af72eb922f10e5bde9c04cc"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackagescc0f1772edb8d75ecf6280f1c7f51cbcebe274e8b17878b382f63738fd96cee5google_auth_oauthlib-1.2.1.tar.gz"
    sha256 "afd0cad092a2eaa53cd8e8298557d6de1034c6cb4a740500b5357b648af97263"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages533b1599ceafa875ffb951480c8c74f4b77646a6b80e80970698f2aa93c216cegoogleapis_common_protos-1.65.0.tar.gz"
    sha256 "334a29d07cddc3aa01dee4988f9afd9b2916ee2ff49d6b757155dc0d197852c0"
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
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
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
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "mail-parser" do
    url "https:files.pythonhosted.orgpackages2b3d7f096230c4b61857c7682dc5497000a987b5f7e8376f54f0a5ed73e2cc3dmail-parser-3.15.0.tar.gz"
    sha256 "d66638acf0633dfd8a718e1e3646a6d58f8e9d75080c94638c7b267b4b0d6c86"
  end

  resource "mailsuite" do
    url "https:files.pythonhosted.orgpackages68d18efed4a533dd71587b5484200d88cc0c0aa7daf930b5a5803de773431bd0mailsuite-1.9.16.tar.gz"
    sha256 "adf6af38e8afb6d5d799d03f365de35265c8510ae3c430d9f1c1dc3482502fa5"
  end

  resource "maxminddb" do
    url "https:files.pythonhosted.orgpackages9f9e7806bf76d917182a4f4a08325f66eee6f32fe1123398789ba2547b5d3f3emaxminddb-2.6.2.tar.gz"
    sha256 "7d842d32e2620abc894b7d79a5a1007a69df2c6cf279a06b94c9c3913f66f264"
  end

  resource "msal" do
    url "https:files.pythonhosted.orgpackages03ce45b9af8f43fbbf34d15162e1e39ce34b675c234c56638277cc05562b6dbfmsal-1.30.0.tar.gz"
    sha256 "b4bf00850092e465157d814efa24a18f788284c9a479491024d62903085ea2fb"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackages2d38ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5ebmsal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
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
    url "https:files.pythonhosted.orgpackagesc4ca5be52de5c69ecd327c16f3fc0dba82b7ffda5bbd0c0e215bdf23a4d12b12opensearch_py-2.7.1.tar.gz"
    sha256 "67ab76e9373669bc71da417096df59827c08369ac3795d5438c9a8be21cbd759"
  end

  resource "portalocker" do
    url "https:files.pythonhosted.orgpackagesedd3c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackages3efce9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages5fd7331ee1f3b798c34d2257c79d5426ecbe95d46d2b40ba808a29da6947f6d8protobuf-5.28.0.tar.gz"
    sha256 "dde74af0fa774fa98892209992295adbfb91da3fa98c8f67a88afe8f5a349add"
  end

  resource "publicsuffix2" do
    url "https:files.pythonhosted.orgpackages5a041759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https:files.pythonhosted.orgpackages3da2b94aa8b2df8cc2c2c8020b824824dc8f14cc53e10351bc76180652c1c8c3publicsuffixlist-1.0.2.20240903.tar.gz"
    sha256 "99c7f35974ef30a5dbe57739736a7078e16e304f0a520b7234fa11b2cc5fec40"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pygelf" do
    url "https:files.pythonhosted.orgpackagesfed373d1fe74a156f9a0e519bedc87815ed309e64af19c73b94352e4c0959ddbpygelf-0.4.2.tar.gz"
    sha256 "d0bb8f45ff648a9a187713f4a05c09f685fcb8add7b04bb7471f20071bd11aad"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagesfb68ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020epyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages830813f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043apyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
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
    url "https:files.pythonhosted.orgpackages3f5164256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
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
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27cbe754933c1ca726b0d99980612dc9da2886e76c83968c246cfb50f491a96bsetuptools-74.1.1.tar.gz"
    sha256 "2353af060c06388be1cecbf5953dcdb1f38362f87a2356c480b6b4d5fcfc8847"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackages3d29085111f19717f865eceaf0d4397bf3e76b08d60428b076b64e2a1903706dsimplejson-3.19.3.tar.gz"
    sha256 "8e086896c36210ab6050f2f9f095a5f1e03c83fa0e7f296d6cba425411364680"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
    url "https:files.pythonhosted.orgpackagese4e86ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392furllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages390d40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7fxmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages656683c99ba8c134f1e0e40df559614f4f9272360e1e9c549003e8c5ff3e4fc7yarl-1.9.9.tar.gz"
    sha256 "d58a26cbc785a0fb6ad2e733422631c7f45c364a40dbd0cabb9f0dfcdbb4940b"
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