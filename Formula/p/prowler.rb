class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Tool for cloud security assessments, audits, incident response, and more"
  homepage "https:prowler.com"
  url "https:files.pythonhosted.orgpackagesa33951b40c8d682686db97ccd031aa5c9d943dcd029499841fb45a9a927dcec9prowler-5.2.0.tar.gz"
  sha256 "d5d57752ff2c8a7baa3179bc258078a6dea43d5344c1a9ad2487bc2e11ed7e37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "add225854121145b09cd879f65879e90242fe389739f87561343d93cca8cb16d"
    sha256 cellar: :any,                 arm64_sonoma:  "aaccc8a36c752a81a1ab637dfeea28138291d9430f0b68b7b25dcb04ce6d9b72"
    sha256 cellar: :any,                 arm64_ventura: "90046b66fb28ad0e9be7cb98e15583d44b6c92ec45da466139ae9d4ff9ad3887"
    sha256 cellar: :any,                 sonoma:        "aa57e4fab099dac1702405e71b26ea44bb177d4e1fadb23682afd92d447cfd76"
    sha256 cellar: :any,                 ventura:       "51a934bf9e1cfab8490eafc53f8063928abb17dac084922ab41b741601422a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "320feb1c9a1d485fb228275860d00d4b4e768c4df92546a87d9d4ac57c22d72e"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.12" # https:github.comprowler-cloudprowlerblobmasterpyproject.toml#L68

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "about-time" do
    url "https:files.pythonhosted.orgpackages1c3fccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0aabout-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages7f55e4373e888fdacb15563ef6fa9fa8c8252476ea071e96fb46defac9f18bf2aiohappyeyeballs-2.4.4.tar.gz"
    sha256 "5fdd7d87889c63183afc18ce9271f9b0a7d32c2303e394468dd45d514a757745"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesfeedf26db39d29cd3cb2f5a3374304c713fe5ab5a0e4c8ee25a0c45cc6adf844aiohttp-3.11.11.tar.gz"
    sha256 "bb49c7f1e6ebf3821a42d81d494f538107610c3a705987f53068546b0e90303e"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "alive-progress" do
    url "https:files.pythonhosted.orgpackages2866c2c1e6674b3b7202ce529cf7d9971c93031e843b8e0c86a85f693e6185b8alive-progress-3.2.0.tar.gz"
    sha256 "ede29d046ff454fe56b941f686f89dd9389430c4a5b7658e445cb0b80e0e4deb"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesa373199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cdeanyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages48c86260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "awsipranges" do
    url "https:files.pythonhosted.orgpackages192e6efa95f995369da828715f41705686cd214b9259ed758266942553d40441awsipranges-0.3.3.tar.gz"
    sha256 "4f0b3f22a9dc1163c85b513bed812b6c92bdacd674e6a7b68252a3c25b99e2c0"
  end

  resource "azure-common" do
    url "https:files.pythonhosted.orgpackages3e71f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccacazure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackagesccee668328306a9e963a5ad9f152cd98c7adad86c822729fd1d2a01613ad1e67azure_core-1.32.0.tar.gz"
    sha256 "22b3c35d6b2dae14990f6c1be2912bf23ffe50b220e708a28ab1bb92b1c730e5"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackagesaa91cbaeff9eb0b838f0d35b4607ac1c6195c735c8eb17db235f8f60e622934cazure_identity-1.19.0.tar.gz"
    sha256 "500144dc18197d7019b81501165d4fa92225f03778f17d7ca8a2a180129a9c83"
  end

  resource "azure-keyvault-keys" do
    url "https:files.pythonhosted.orgpackages56f985c95072c4f396126a8ae145ffb45fb3e7bea660b6cb8ff8b2f702944a57azure_keyvault_keys-4.10.0.tar.gz"
    sha256 "511206ae90aec1726a4d6ff5a92d754bd0c0f1e8751891368d30fb70b62955f1"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https:files.pythonhosted.orgpackages893765811225c0611bedc784f8fd954eeb5a0e4cf58dc9f46860b33444391589azure-mgmt-applicationinsights-4.0.0.zip"
    sha256 "50c3db05573e0cc2d56314a0556fb346ef05ec489ac000f4d720d92c6b647e06"
  end

  resource "azure-mgmt-authorization" do
    url "https:files.pythonhosted.orgpackages9eabe79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73dazure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https:files.pythonhosted.orgpackagesfe3f72e09a6f9a12d8afed8f56c929e8e142de21be9c19c27e4b2b94d60eb73aazure_mgmt_compute-34.0.0.tar.gz"
    sha256 "58cd01d025efa02870b84dbfb69834a3b23501a135658c03854d2434e8dfee1e"
  end

  resource "azure-mgmt-containerregistry" do
    url "https:files.pythonhosted.orgpackagesa9df97427d1bc1bb7307c7bfa73fdb8feb1ab6f74c3a2e67e8a9223abfa4b4ddazure-mgmt-containerregistry-10.3.0.tar.gz"
    sha256 "ae21651855dfb19c42d91d6b3a965c6c611e23f8bc4bf7138835e652d2f918e3"
  end

  resource "azure-mgmt-containerservice" do
    url "https:files.pythonhosted.orgpackagesa3efb4c360e207db8a61b9ca09a84a1a65f8dbf1f0e2932571766c775b9151f2azure_mgmt_containerservice-34.0.0.tar.gz"
    sha256 "822d07828b746a5ea5408a8b3770f41dc424d6c4c28de53c29611b62bef8aea3"
  end

  resource "azure-mgmt-core" do
    url "https:files.pythonhosted.orgpackages489a9bdc35295a16fe9139a1f99c13d9915563cbc4f30b479efaa40f8694eaf7azure_mgmt_core-1.5.0.tar.gz"
    sha256 "380ae3dfa3639f4a5c246a7db7ed2d08374e88230fd0da3eb899f7c11e5c441a"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https:files.pythonhosted.orgpackages742a3240e83aff38443d334a17467d32a46bab269164ab9477bb17d2277b32f8azure_mgmt_cosmosdb-9.7.0.tar.gz"
    sha256 "b5072d319f11953d8f12e22459aded1912d5f27e442e1d8b49596a85005410a1"
  end

  resource "azure-mgmt-keyvault" do
    url "https:files.pythonhosted.orgpackages6fc9c9cd047729de3996656da854e361636dafa4f5e9b35af449abe23ec75582azure-mgmt-keyvault-10.3.1.tar.gz"
    sha256 "34b92956aefbdd571cae5a03f7078e037d8087b2c00cfa6748835dc73abb5a30"
  end

  resource "azure-mgmt-monitor" do
    url "https:files.pythonhosted.orgpackagese431ebabafe0be1a177428880a8ec0fc44d681ac9dc1ae66a70d859cb5c7fbc3azure-mgmt-monitor-6.0.2.tar.gz"
    sha256 "5ffbf500e499ab7912b1ba6d26cef26480d9ae411532019bb78d72562196e07b"
  end

  resource "azure-mgmt-network" do
    url "https:files.pythonhosted.orgpackages19a38d2fa6e33107354c8cd2abcca4e0f02138bda4c6024984ae5fce5cf23b27azure_mgmt_network-28.1.0.tar.gz"
    sha256 "8c84bffb5ec75c6e0244e58ecf07c00d5fc421d616b0cb369c6fe585af33cf87"
  end

  resource "azure-mgmt-rdbms" do
    url "https:files.pythonhosted.orgpackages513cc1e03a11cf3dc2567ba947cc196d695d125d0d0e86af6731a7c067c5404aazure-mgmt-rdbms-10.1.0.zip"
    sha256 "a87d401c876c84734cdd4888af551e4a1461b4b328d9816af60cb8ac5979f035"
  end

  resource "azure-mgmt-resource" do
    url "https:files.pythonhosted.orgpackages71e9cafb7076283db9f21e05e54fa0536b16d790e43f30691e80d6eac4603789azure_mgmt_resource-23.2.0.tar.gz"
    sha256 "747b750df7af23ab30e53d3f36247ab0c16de1e267d666b1a5077c39a4292529"
  end

  resource "azure-mgmt-search" do
    url "https:files.pythonhosted.orgpackages63b7b9431f1ab621f83849f3ace5ba9d2820c731409fce8466b5f06d330d19f4azure-mgmt-search-9.1.0.tar.gz"
    sha256 "53bc6eeadb0974d21f120bb21bb5e6827df6d650e17347460fd83e2d68883599"
  end

  resource "azure-mgmt-security" do
    url "https:files.pythonhosted.orgpackages3d9013186657355452bdce44f27db6b194b99f78f8c185301b47624fff6d9531azure-mgmt-security-7.0.0.tar.gz"
    sha256 "5912eed7e9d3758fdca8d26e1dc26b41943dc4703208a1184266e2c252e1ad66"
  end

  resource "azure-mgmt-sql" do
    url "https:files.pythonhosted.orgpackages3faf398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https:files.pythonhosted.orgpackagesb99b0542c8081fe6ff808b04986892861e88775c3900c391657f796d69643f13azure-mgmt-storage-21.2.1.tar.gz"
    sha256 "503a7ff9c31254092b0656445f5728bfdfda2d09d46a82e97019eaa9a1ecec64"
  end

  resource "azure-mgmt-subscription" do
    url "https:files.pythonhosted.orgpackages846714b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-mgmt-web" do
    url "https:files.pythonhosted.orgpackages7fa4a47081049ae17378b920518db566587c5691ed52c15802a2b418912081adazure-mgmt-web-7.3.1.tar.gz"
    sha256 "87b771436bc99a7a8df59d0ad185b96879a06dce14764a06b3fc3dafa8fcb56b"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackagesfef65a94fa935933c8483bf27af0140e09640bd4ee5b2f346e71eee06c197482azure_storage_blob-12.24.0.tar.gz"
    sha256 "eaaaa1507c8c363d6e1d1342bd549938fdf1adec9b1ada8658c8f5bf3aea844e"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages21289b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ceblinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesf7993e8b48f15580672eda20f33439fc1622bd611f6238b6d05407320e1fb98cboto3-1.35.99.tar.gz"
    sha256 "e0abd794a7a591d90558e92e29a9f8837d25ece8e3c120e530526fe27eba5fca"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages7c9c1df6deceee17c88f7170bad8325aa91452529d683486273928eecfd946d8botocore-1.35.99.tar.gz"
    sha256 "1eab44e969c39c5f3d9a3104a0836c24715579a455f12b3979a31d7cde51b3c3"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesd97457df1ab0ce6bc5f6fa868e08de20df8ac58f9c44330c7671ad922d2bbeaecachetools-5.5.1.tar.gz"
    sha256 "70f238fbba50383ef62e55c6aff6d9673175fe59f7c6782c7a0b9e38f4a9df95"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dash" do
    url "https:files.pythonhosted.orgpackagescfaedfd8c42c83cad1b903e4e3e7be7042074d5d7d16be97eaede6656b8ead95dash-2.18.2.tar.gz"
    sha256 "20e8404f73d0fe88ce2eae33c25bbc513cbe52f30d23a401fa5f24dbb44296c8"
  end

  resource "dash-bootstrap-components" do
    url "https:files.pythonhosted.orgpackagesa61e59da44351adaaa2a747eb00993c498cadbe0f642b44ced7e7aabf368eaf6dash_bootstrap_components-1.6.0.tar.gz"
    sha256 "960a1ec9397574792f49a8241024fa3cecde0f5930c971a3fc81f016cbeb1095"
  end

  resource "dash-core-components" do
    url "https:files.pythonhosted.orgpackages4155ad4a2cf9b7d4134779bd8d3a7e5b5f8cc757f421809e07c3e73bb374fdd7dash_core_components-2.0.0.tar.gz"
    sha256 "c6733874af975e552f95a1398a16c2ee7df14ce43fa60bb3718a3c6e0b63ffee"
  end

  resource "dash-html-components" do
    url "https:files.pythonhosted.orgpackages14c6957d5e83b620473eb3c8557a253fb01c6a817b10ca43d3ff9d31796f32a6dash_html_components-2.0.0.tar.gz"
    sha256 "8703a601080f02619a6390998e0b3da4a5daabe97a1fd7a9cebc09d015f26e50"
  end

  resource "dash-table" do
    url "https:files.pythonhosted.orgpackages3a8134983fa0c67125d7fff9d55e5d1a065127bde7ca49ca32d04dedd55f9f35dash_table-5.0.0.tar.gz"
    sha256 "18624d693d4c8ef2ddec99a6f167593437a7ea0bf153aa20f318c170c5bc7308"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages2ea353e7d78a6850ffdd394d7048a31a6f14e44900adedf190f9a165f6b69439deprecated-1.2.15.tar.gz"
    sha256 "683e561a90de76239796e6b6feac66b99030d2dd3fcf61ef996330f14bbb9b0d"
  end

  resource "detect-secrets" do
    url "https:files.pythonhosted.orgpackages6967382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7ddetect_secrets-1.5.0.tar.gz"
    sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "durationpy" do
    url "https:files.pythonhosted.orgpackages31e9f49c4e7fccb77fa5c43c2480e09a857a78b41e7331a75e128ed5df45c56bdurationpy-0.9.tar.gz"
    sha256 "fd3feb0a69a0057d582ef643c355c40d2fa1c942191f914d12203b1a01ac722a"
  end

  resource "email-validator" do
    url "https:files.pythonhosted.orgpackages48ce13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagesdc9c0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackages41e1d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829aflask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8fed0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages8156d70d66ed1b5ab5f6c27bf80ec889585ad8f865ff32acbafd3b2ef0bfb5d0google_api_core-2.24.0.tar.gz"
    sha256 "e255640547a597a4da010876d333208ddac417d60add22b6851a0c66a831fcaf"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages5a9f12b58cca5a93d63fd6a7abed570423bdf2db4349eb9361ac5214d42ed7d6google_api_python_client-2.159.0.tar.gz"
    sha256 "55197f430f25c907394b44fa078545ffef89d33fd4dca501b7db9f0d8e224bd6"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackagesc6ebd504ba1daf190af6b204a9d4714d457462b486043744901a6eeea711f913google_auth-2.38.0.tar.gz"
    sha256 "8285113607d3b80a3f1543b75962447ba8a09fe85783432a784fdeef6ac094c4"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackagesffa78e9cccdb1c49870de6faea2a2764fa23f627dd290633103540209f03524cgoogleapis_common_protos-1.66.0.tar.gz"
    sha256 "c3e7b33d15fdca5374cc0a7346dd92ffa847425cc4ea941d970f13680052ec8c"
  end

  resource "grapheme" do
    url "https:files.pythonhosted.orgpackagescee7bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bfgrapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "h2" do
    url "https:files.pythonhosted.orgpackages2a32fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https:files.pythonhosted.orgpackages2c4871de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages6a41d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hyperframe" do
    url "https:files.pythonhosted.orgpackages02e794f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagescd1233e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1bimportlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackages544de940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "kubernetes" do
    url "https:files.pythonhosted.orgpackages7ebdffcd3104155b467347cd9b3a64eb24182e459579845196b3a200569c8912kubernetes-31.0.0.tar.gz"
    sha256 "28945de906c8c259c1ebe62703b56a03b714049372196f854105afe4e6d014c0"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "microsoft-kiota-abstractions" do
    url "https:files.pythonhosted.orgpackagesc932bdfe0385ef258117bf8b32e28e6cb912c15ee2a612abe23f3b6d07bd89fdmicrosoft_kiota_abstractions-1.6.8.tar.gz"
    sha256 "7070affabfa7182841646a0c8491cbb240af366aff2b9132f0caa45c4837dd78"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https:files.pythonhosted.orgpackagesab944560deae92905fc1c653f7b6a5cee039791c61a15ba0a3a7ba5c22245ea7microsoft_kiota_authentication_azure-1.6.8.tar.gz"
    sha256 "fef23f43cd4d3b9ef839c8b3d1f675ec4a1120c150f963d8c4551c5e19ac3b36"
  end

  resource "microsoft-kiota-http" do
    url "https:files.pythonhosted.orgpackages4a2d4a28482e21258a509a9a079e28c67f2aea5a6d3297f0ff14a4bfeee69e4dmicrosoft_kiota_http-1.6.8.tar.gz"
    sha256 "67242690b79a30c0cadf823675249269e4bc020283e3d65b33af7d771df64df8"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https:files.pythonhosted.orgpackages3ca7499cf5c82798f42336df4616837e6ffceada9dd51f685be10b5467d470efmicrosoft_kiota_serialization_form-1.6.8.tar.gz"
    sha256 "bb9eb98b3abf596b4bfe208014dff948361ff48a757316ac58e19c31ab8d640a"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https:files.pythonhosted.orgpackages1b05dbdde6f370d0403d8b37fd61e80f2c0fa00f2ec4cd396f10d57d17ada207microsoft_kiota_serialization_json-1.6.8.tar.gz"
    sha256 "89e2dd0eb4eaaa6ab74fa89ab5d84c5a53464e73b85eb7085f0aa4560a2b8183"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https:files.pythonhosted.orgpackages0d43a1e07c6487ca548cfbe2917c5d95be20a04402f8481155e8128efc81dbc8microsoft_kiota_serialization_multipart-1.6.8.tar.gz"
    sha256 "3d95c6d7186588af7a1d3aa852ce42077f80487b8b3c60e36fe109a8b4918c03"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https:files.pythonhosted.orgpackagesce976255ff9a3c0e113d244272821fa548dd784981b9e8505e3c3f7a0414b0e1microsoft_kiota_serialization_text-1.6.8.tar.gz"
    sha256 "687d4858337eaf4f351b12ed1c6c934d869560f54ee3855bfdde589660e07208"
  end

  resource "msal" do
    url "https:files.pythonhosted.orgpackages3ff3cdf2681e83a73c3355883c2884b6ff2f2d2aadfc399c28e9ac4edc3994fdmsal-1.31.1.tar.gz"
    sha256 "11b5e6a3f802ffd3a72107203e20c4eac6ef53401961b880af2835b723d80578"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackages2d38ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5ebmsal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "msgraph-core" do
    url "https:files.pythonhosted.orgpackages85c82b06bdb135691102bdced91b5c715e37fbe153b19c11355f0b9158601c1amsgraph_core-1.2.0.tar.gz"
    sha256 "a4e42f692e664c60d63359e610bbf990f57b42d8080417261ff7042bbd59c98b"
  end

  resource "msgraph-sdk" do
    url "https:files.pythonhosted.orgpackages680b08734ffa5941fab67278ade7a9c9cd5dae89a266bf8eb08af51a11e6a519msgraph_sdk-1.17.0.tar.gz"
    sha256 "577e41942b0f794b8cf2f54db030bc039a750a81b515dcd0ba1d66fd961fa7bf"
  end

  resource "msrest" do
    url "https:files.pythonhosted.orgpackages68778397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "nest-asyncio" do
    url "https:files.pythonhosted.orgpackages83f851569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefenest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https:files.pythonhosted.orgpackagesbc8eb886a5e9861afa188d1fe671fb96ff9a1d90a23d57799331e137cc95d573opentelemetry_api-1.29.0.tar.gz"
    sha256 "d04a6cf78aad09614f52964ecb38021e248f5714dc32c2e0d8fd99517b4d69cf"
  end

  resource "opentelemetry-sdk" do
    url "https:files.pythonhosted.orgpackages0c5a1ed4c3cf6c09f80565fc085f7e8efa0c222712fd2a9412d07424705dcf72opentelemetry_sdk-1.29.0.tar.gz"
    sha256 "b0787ce6aade6ab84315302e72bd7a7f2f014b0fb1b7c3295b88afe014ed0643"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https:files.pythonhosted.orgpackagese74ed7c7c91ff47cd96fe4095dd7231701aec7347426fd66872ff320d6cd1fccopentelemetry_semantic_conventions-0.50b0.tar.gz"
    sha256 "02dc6dbcb62f082de9b877ff19a3f1ffaa3c306300fa53bfac761c4567c83d38"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pandas" do
    url "https:files.pythonhosted.orgpackages9cd69f8431bacc2e19dca897724cd097b1bb224a6ad5433784a44b587c7c13afpandas-2.2.3.tar.gz"
    sha256 "4f18ba62b61d7e192368b84517265a99b4d7ee8912f8708660fb4a366cc82667"
  end

  resource "pendulum" do
    url "https:files.pythonhosted.orgpackagesb8fe27c7438c6ac8b8f8bef3c6e571855602ee784b85d072efddfff0ceb1cd77pendulum-3.0.0.tar.gz"
    sha256 "5d034998dea404ec31fae27af6b22cff1708f830a1ed7353be4d1019bb9f584e"
  end

  resource "plotly" do
    url "https:files.pythonhosted.orgpackages794f428f6d959818d7425a94c190a6b26fbc58035cbef40bf249be0b62a9aeddplotly-5.24.1.tar.gz"
    sha256 "dbc8ac8339d248a4bcc36e08a5659bacfe1b079390b8953533f4eb22169b4bae"
  end

  resource "portalocker" do
    url "https:files.pythonhosted.orgpackagesedd3c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackages20c82a13f78d82211490855b2fb303b6721348d0787fdd9a12ac46d99d3acde1propcache-0.2.1.tar.gz"
    sha256 "3f77ce728b19cb537714499928fe800c3dda29e8d9428778fc7c186da4c09a64"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackages7e0574417b2061e1bf1b82776037cad97094228fa1c1b6e82d08a78d3fb6ddb6proto_plus-1.25.0.tar.gz"
    sha256 "fbb17f57f7bd05a68b7707e745e26528b0b3c34e378db91eef93912c54982d91"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesf7d1e0a911544ca9993e0f17ce6d3cc0932752356c1b0a834397f28e63479344protobuf-5.29.3.tar.gz"
    sha256 "5da0f41edaf117bde316404bad1a486cb4ededf8e4a54891296f648e8e076620"
  end

  resource "py-ocsf-models" do
    url "https:files.pythonhosted.orgpackages4647e085aaec6e960e20ad0fc4f615af5476dc1d4da230d5e96d092871aea14apy_ocsf_models-0.2.0.tar.gz"
    sha256 "3e12648d05329e6776a0e6b1ffea87a3eb60aa7d8cb2c4afd69e5724f443ce03"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages1d676afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages20e689d6ba0c0a981fd7e3129d105502c4cf73fad1611b294c87b103f75b5837pydantic-1.10.18.tar.gz"
    sha256 "baebdff1907d1d96a139c25136a9bb7d17e118f133a76a2ef3b845e831e3403a"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagese746bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8b1a3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2732fd98246df7a0f309b58cae68b10b6b219ef2eb66747f00dfb34422687087referencing-0.36.1.tar.gz"
    sha256 "ca2e6492769e3602957e9b831b94211599d2aade9477f5d44110d2530cf9aade"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages7297bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1aerequests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "retrying" do
    url "https:files.pythonhosted.orgpackagesce7015ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9ddretrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages0180cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfdrpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesc00a1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackagesd4010ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecdschema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages92ec089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "shodan" do
    url "https:files.pythonhosted.orgpackagesc506c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "slack-sdk" do
    url "https:files.pythonhosted.orgpackages6eff6eb67fd5bd179fa804dbd859d88d872d3ae343955e63a319a73a132d406fslack_sdk-3.34.0.tar.gz"
    sha256 "ff61db7012160eed742285ea91f11c72b7a38a6500a7f6c5335662b4bc6b853d"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "std-uritemplate" do
    url "https:files.pythonhosted.orgpackagesde958d6dffcc9cf391754f8377850fa40736e8d4bee407441c88a8fa9d145325std_uritemplate-2.0.1.tar.gz"
    sha256 "f4684ae050167e237ed5819423139893e0b5b7f08dc6b7467bba3fdd64608be8"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tenacity" do
    url "https:files.pythonhosted.orgpackagescd9491fccdb4b8110642462e653d5dcb27e7b674742ad68efd146367da7bdb10tenacity-9.0.0.tar.gz"
    sha256 "807f37ca97d62aa361264d497b0e31e92b8027044942bfa756160d908320d73b"
  end

  resource "time-machine" do
    url "https:files.pythonhosted.orgpackagesfbdd5022939b9cadefe3af04f4012186c29b8afbe858b1ec2cfa38baeec94dabtime_machine-2.16.0.tar.gz"
    sha256 "4a99acc273d2f98add23a89b94d4dd9e14969c01214c8514bfa78e4e9364c7e2"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackages4a4feee4bebcbad25a798bf55601d3a4aee52003bebcf9e55fce08b91ca541a9tldextract-5.1.3.tar.gz"
    sha256 "d43c7284c23f5dc8a42fd0fee2abede2ff74cc622674e4cb07f514ab3330c338"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages430ffa4723f22942480be4ca9527bbde8d43f6c3f2fe8412f00e7f5f6746bc8btzdata-2025.1.tar.gz"
    sha256 "24894909e88cdb28bd1636c6887801df64cb485bd593f2fd83ef29075a81d694"
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
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackagesd4f90ba83eaa0df9b9e9d1efeb2ea351d0677c37d41ee5d0f91e98423c7281c9werkzeug-3.0.6.tar.gz"
    sha256 "a8dd59d4de28ca70471a34cba79bed5f7ef2e036a76b3ab0835474246eb41f8d"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackagesc3fce91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcefwrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "xlsxwriter" do
    url "https:files.pythonhosted.orgpackages484f108b0bada5cfcc47c24ea6181f4c563fbafef50bcc0054089c256b2ae578XlsxWriter-3.2.1.tar.gz"
    sha256 "97618759cb264fb6a93397f660cca156ffa9561743b1823dafb60dc4474e1902"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagesb79d4b94a8e6d2b51b599516a5cb88e5bc99b4d8d4583e468057eaa29d5f0918yarl-1.18.3.tar.gz"
    sha256 "ac1801c45cbf77b6c99242eeff4fffb5e4e73a800b5c4ad4fc0be5def634d2e1"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3f50bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56fzipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    # Multiple resources require `setuptools`, so it must be installed first
    venv = virtualenv_install_with_resources without: "plotly", start_with: "setuptools"
    venv.pip_install resource("plotly"), build_isolation: false
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}prowler aws --list-services")

    assert_match "Unable to locate credentials", shell_output("#{bin}prowler aws --quick-inventory 2>&1", 1)
    assert_match "Prowler #{version}", shell_output("#{bin}prowler -v")
  end
end