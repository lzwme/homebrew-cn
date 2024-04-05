class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Open Source Security tool to perform Cloud Security best practices"
  homepage "https:prowler.pro"
  url "https:files.pythonhosted.orgpackages27ca9651d4c081fc95df551b2a04e60cafc4a6a7d3f5f34c0c8296a9998484f9prowler-3.16.0.tar.gz"
  sha256 "e7efb07154d83ca7ecdd2a71204c5dce6c39de0b1370542d564a4ff57bf89edb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8612d86fd01a71feb56b6b3c910f3254be4193d9f7e34f5402fa8a04b8ab44e0"
    sha256 cellar: :any,                 arm64_ventura:  "69db531512c5c129902b5321aca456e60878a19a46befe308957fce84bb5a023"
    sha256 cellar: :any,                 arm64_monterey: "eaa524c797b4db36df1a2ff9dfe71d8679c22d9d2b2a32d048859253a8b0285c"
    sha256 cellar: :any,                 sonoma:         "c4d1d6a4c35113a0ac9da5ac0c9bbe5cf2bfc83ea0f3d54c2a80ed2529f067d9"
    sha256 cellar: :any,                 ventura:        "293c9a8d3d2435df92b26dcb43be822720ebd40b77a2eae7a491749400e793c2"
    sha256 cellar: :any,                 monterey:       "bdd8cab9dcaf4cb90c61c7dc97e668c4368c37ac4db0ba72a260f89c66ca1329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15a7d91cfbe316daf0c0f6c1fd00006557a639b876fb1db851fe149f414ae3fe"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "about-time" do
    url "https:files.pythonhosted.orgpackages1c3fccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0aabout-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "adal" do
    url "https:files.pythonhosted.orgpackages90d7a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages18931f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258baiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "alive-progress" do
    url "https:files.pythonhosted.orgpackages6acfde25c4f6123c3b3eb5acc87144d3e017df25b32c16806b14572a259939acalive-progress-3.1.5.tar.gz"
    sha256 "42e399a66c8150dc507602dff7b7953f105ef11faf97ddaa6d27b1cbf45c4c98"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
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
    url "https:files.pythonhosted.orgpackages510db76383f028aa3570419edf97ab504cb84b839e3cbc8c8b2048f16bbea2d3azure-core-1.30.1.tar.gz"
    sha256 "26273a254131f84269e8ea4464f3560c731f29c0c1f69ac99010845f239c1a8f"
  end

  resource "azure-identity" do
    url "https:files.pythonhosted.orgpackages7402a0545eaa3fb83a6b6c413de4a65e06a02ce887f874a2e74a1240b2169140azure-identity-1.15.0.tar.gz"
    sha256 "4c28fc246b7f9265610eb5261d65931183d019a23d4b0e99357facb2e6c227c8"
  end

  resource "azure-keyvault-keys" do
    url "https:files.pythonhosted.orgpackages12ac9a86f08659638ff2f07cb233a4f606bb765a72051a85c2622c0353eaa225azure-keyvault-keys-4.9.0.tar.gz"
    sha256 "08632dcd6ece28657204e9a256ad64369fe2b0e385ed43349f932f007d89f774"
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
    url "https:files.pythonhosted.orgpackages1ee204dc4d1d2592858b7cf22efde3f7c5e5516faf98131214823b68fb7c087aazure-mgmt-compute-30.6.0.tar.gz"
    sha256 "4d80d723ec6d4cb9583617ebec0716e7d74b2732acbaed023ed2e3cc7053d00e"
  end

  resource "azure-mgmt-containerservice" do
    url "https:files.pythonhosted.orgpackages490913aefe98d878d39d79aedd5f61aa832f7b1ede233b7ea22d8d83bc35f490azure-mgmt-containerservice-29.1.0.tar.gz"
    sha256 "46887178bb1035933f06fa63121c1ac9d4c5871f202ae2b86bc4af6e1e3b354f"
  end

  resource "azure-mgmt-core" do
    url "https:files.pythonhosted.orgpackages14952b2085e40f4b9de88ad256428a669583066d8ab348fc19110c7d04c3189bazure-mgmt-core-1.4.0.zip"
    sha256 "d195208340094f98e5a6661b781cde6f6a051e79ce317caabd8ff97030a9b3ae"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https:files.pythonhosted.orgpackagesd05ef032596e09e2fb8d96684c47327111eeb90608c0d2a0f8261491f8ec61b8azure-mgmt-cosmosdb-9.4.0.tar.gz"
    sha256 "cabb821cd446b09e73d24c31c287a60fcc3623488f1ffa9335c692267e79c341"
  end

  resource "azure-mgmt-keyvault" do
    url "https:files.pythonhosted.orgpackages5ce654879a503c28d2b1ef991f086c41c86218a82dd81a5b870c59b79a0f15ceazure-mgmt-keyvault-10.3.0.tar.gz"
    sha256 "183b4164cf1868b8ea7efeaa98edad7d2a4e14a9bd977c2818b12b75150cd2a2"
  end

  resource "azure-mgmt-monitor" do
    url "https:files.pythonhosted.orgpackagese431ebabafe0be1a177428880a8ec0fc44d681ac9dc1ae66a70d859cb5c7fbc3azure-mgmt-monitor-6.0.2.tar.gz"
    sha256 "5ffbf500e499ab7912b1ba6d26cef26480d9ae411532019bb78d72562196e07b"
  end

  resource "azure-mgmt-network" do
    url "https:files.pythonhosted.orgpackages2620c09aefc1f7a14b90161589b0dc9aeaef60b4b8a5edcad2e06f8af9086018azure-mgmt-network-25.3.0.tar.gz"
    sha256 "dce2cafb1ae0e563e0b5efc537dc98a7c0ad824d4261e64bed75f788196dd5c6"
  end

  resource "azure-mgmt-rdbms" do
    url "https:files.pythonhosted.orgpackages513cc1e03a11cf3dc2567ba947cc196d695d125d0d0e86af6731a7c067c5404aazure-mgmt-rdbms-10.1.0.zip"
    sha256 "a87d401c876c84734cdd4888af551e4a1461b4b328d9816af60cb8ac5979f035"
  end

  resource "azure-mgmt-resource" do
    url "https:files.pythonhosted.orgpackages8165128984a9bdca0542a6fabd748e4b84398de625193379ac7fc3a0805465cdazure-mgmt-resource-23.0.1.zip"
    sha256 "c2ba6cfd99df95f55f36eadc4245e3dc713257302a1fd0277756d94bd8cb28e0"
  end

  resource "azure-mgmt-security" do
    url "https:files.pythonhosted.orgpackages25b2bbe822bca8dc617ac5fab0eb40e5786a2ed933b484a3238af5b7a19e6debazure-mgmt-security-6.0.0.tar.gz"
    sha256 "ceafc1869899067110bd830c5cc98bc9b8f32d8ea840ca1f693b1a5f52a5f8b0"
  end

  resource "azure-mgmt-sql" do
    url "https:files.pythonhosted.orgpackages3faf398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https:files.pythonhosted.orgpackages495c9fc3418570dcb5de5f883f909b894f9cdd77829c84afb08b7370c796334eazure-mgmt-storage-21.1.0.tar.gz"
    sha256 "d6d3c0e917c988bc9ed0472477d3ef3f90886009eb1d97a711944f8375630162"
  end

  resource "azure-mgmt-subscription" do
    url "https:files.pythonhosted.orgpackages846714b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-mgmt-web" do
    url "https:files.pythonhosted.orgpackagesd1a9c255592263d798843d2ccc46ee42129f5ae6b95e882dae3544938c66e449azure-mgmt-web-7.2.0.tar.gz"
    sha256 "efcfe6f7f520ed0abcfe86517e1c8cf02a712f737a3db0db7cb46c6d647981ed"
  end

  resource "azure-storage-blob" do
    url "https:files.pythonhosted.orgpackagesbda2b1c1d6d8e3709bd949a18969ae8c1c61bd77d54f2b896e8574ef53053df5azure-storage-blob-12.19.1.tar.gz"
    sha256 "13e16ba42fc54ac2c7e8f976062173a5c82b9ec0594728e134aac372965a11b0"
  end

  resource "babel" do
    url "https:files.pythonhosted.orgpackagese280cfbe44a9085d112e983282ee7ca4c00429bc4d1ce86ee5f4e60259ddff7fBabel-2.14.0.tar.gz"
    sha256 "6919867db036398ba21eb5c7a0f6b28ab8cbc3ae7a73a44ebe34ae74a4e7d363"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages0f3c8a0b46a53326236006a4c4d1a0d49c4ff3a83368492c8308031fbaf61583boto3-1.26.165.tar.gz"
    sha256 "9e7242b9059d937f34264125fecd844cb5e01acce6be093f6c44869fdf7c6e30"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages3df6d35a27c73dc1053abdfe8524d1e488073fccb51e43c88da61b8fe29522e3botocore-1.29.165.tar.gz"
    sha256 "988b948be685006b43c4bbd8f5c0cb93e77c66deb70561994e0c5b31b5a67210"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesb34d27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5bcachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "contextlib2" do
    url "https:files.pythonhosted.orgpackagesc71337ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8fcontextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "detect-secrets" do
    url "https:files.pythonhosted.orgpackagesf155292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31detect_secrets-1.4.0.tar.gz"
    sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagesdb973f028f216da17ab0500550a6bb0f26bf39b07848348f63cce44b89829af9filelock-3.13.3.tar.gz"
    sha256 "a79895a25bbefdf55d1a2a0a80968f7dbb28edcd6d4234a0afb3f37ecde4b546"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "ghp-import" do
    url "https:files.pythonhosted.orgpackagesd929d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
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
    url "https:files.pythonhosted.orgpackagesb28fecd68579bd2bf5e9321df60dcdee6e575adf77fedacb1d8378760b2b16b6google-api-core-2.18.0.tar.gz"
    sha256 "62d97417bfc674d6cef251e5c4d639a9655e00c45528c4364fbfebb478ce72a9"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackagesb1ade202cc85452906df73e4e06f62613ca7b7db5cf5263d2e0d8ac701ae1dc8google-api-python-client-2.124.0.tar.gz"
    sha256 "f6d3258420f7c76b0f5266b5e402e6f804e30351b018a10083f4a46c3ec33773"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages18b2f14129111cfd61793609643a07ecb03651a71dd65c6974f63b0310ff4b45google-auth-2.29.0.tar.gz"
    sha256 "672dff332d073227550ffc7457868ac4218d6c500b155fe6cc17d2b13602c360"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackagesd2dc291cebf3c73e108ef8210f19cb83d671691354f4f7dd956445560d778715googleapis-common-protos-1.63.0.tar.gz"
    sha256 "17ad01b11d5f1d0171c06d3ba5c04c54474e883b66b949722b4938ee2694ef4e"
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
    url "https:files.pythonhosted.orgpackages3e9bfda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
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
    url "https:files.pythonhosted.orgpackages5c2d3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "hyperframe" do
    url "https:files.pythonhosted.orgpackages5a2a4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebbhyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesdb5a392426ddb5edfebfcb232ab7a47e4a827aa1d5b5267a5c20c448615feaa9importlib_metadata-7.0.0.tar.gz"
    sha256 "7fc841f8b8332803464e5dc1c63a2e59121f46ca186c0e2e182e80bf8c1319f7"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackagesdb7ac0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1afisodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages4dc53f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9bejsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages22024785861427848cc11e452cc62bb541006a1087cf04a1de83aedd5530b948Markdown-3.6.tar.gz"
    sha256 "ed4f41f6daecbeeb96e576ce414c41d2d876daa9a16cb35fa8ed8c2ddfad0224"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "microsoft-kiota-abstractions" do
    url "https:files.pythonhosted.orgpackagesd5b3e869234d71684b0382c7ba232e37b47dd9783d8c4cd59972f10957200d1dmicrosoft_kiota_abstractions-1.3.2.tar.gz"
    sha256 "acac0b34b443d3fc10a3a86dd996cdf92248080553a3768a77c23350541f1aa2"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https:files.pythonhosted.orgpackages5c3a21929600c477eb5b1deab21db52fdd06d691950b839dd3a01a3085c480bamicrosoft_kiota_authentication_azure-1.0.0.tar.gz"
    sha256 "752304f8d94b884cfec12583dd763ec0478805c7f80b29344e78c6d55a97bd01"
  end

  resource "microsoft-kiota-http" do
    url "https:files.pythonhosted.orgpackages0e66d4a53a482235be3f4d99d9ddab31546c1d8244cdbacdbf1766e31c7614c0microsoft_kiota_http-1.3.1.tar.gz"
    sha256 "09d85310379f88af0a0967925d1fcbe82f2520a9fe6fa1fd50e79af813bc451d"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https:files.pythonhosted.orgpackages2072251e030ed068a56acf13cacbd764b6e79a55dffa32baec2b686e444673d6microsoft_kiota_serialization_form-0.1.0.tar.gz"
    sha256 "663ece0cb1a41fe9ddfc9195aa3f15f219e14d2a1ee51e98c53ad8d795b2785d"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https:files.pythonhosted.orgpackagesd8b7fadead43cfb806ecd7eeeb8a725e333903810ff34621b93f8180051acacdmicrosoft_kiota_serialization_json-1.1.0.tar.gz"
    sha256 "72bf65d81c0356ad87c229694733f4eb558628a13c5ee8dd274980c4b2d9b64b"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https:files.pythonhosted.orgpackages28f75dd2a93c4d48b3cb2f058466221b06e1465b85dea36f5cac7aace19be054microsoft_kiota_serialization_multipart-0.1.0.tar.gz"
    sha256 "14e89e92582e6630ddbc70ac67b70bf189dacbfc41a96d3e1d10339e86c8dde5"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https:files.pythonhosted.orgpackagesa1c9f9c91025559d4c63237b9f232ecd106e0d8ec9a6c8953e5a7a3c4763d808microsoft_kiota_serialization_text-1.0.0.tar.gz"
    sha256 "c3dd3f409b1c4f4963bd1e41d51b65f7e53e852130bb441d79b77dad88ee76ed"
  end

  resource "mkdocs" do
    url "https:files.pythonhosted.orgpackagesedbb24a22f8154cf79b07b45da070633613837d6e59c7d870076f693b7b1c556mkdocs-1.5.3.tar.gz"
    sha256 "eb7c99214dcb945313ba30426c2451b735992c73c2e10838f76d09e39ff4d0e2"

    # Add missing setuptools dep (from mkdocs formula)
    patch do
      url "https:github.commkdocsmkdocscommitcc76672d5591b444e425423e41a0f5c0d42de9f8.patch?full_index=1"
      sha256 "7fdd3f760c25b9d08a4e97448fdb629a418913adc2d6222b2752719fe0ace60c"
    end
  end

  resource "mkdocs-git-revision-date-localized-plugin" do
    url "https:files.pythonhosted.orgpackages28067d2f5c448c717e8bb4c6c14b5147a9880693b233ca6c25277a8db0defe68mkdocs-git-revision-date-localized-plugin-1.2.4.tar.gz"
    sha256 "08fd0c6f33c8da9e00daf40f7865943113b3879a1c621b2bbf0fa794ffe997d3"
  end

  resource "mkdocs-material" do
    url "https:files.pythonhosted.orgpackages27434c53396722f4b4a8121be0af191081aced0e1c91d7782be7b5478f51526fmkdocs_material-9.5.17.tar.gz"
    sha256 "06ae1275a72db1989cf6209de9e9ecdfbcfdbc24c58353877b2bb927dbe413e4"
  end

  resource "mkdocs-material-extensions" do
    url "https:files.pythonhosted.orgpackages799b9b4c96d6593b2a541e1cb8b34899a6d021d208bb357042823d4d2cabdbe7mkdocs_material_extensions-1.3.1.tar.gz"
    sha256 "10c9511cea88f568257f960358a467d12b970e1f7b2c0e5fb2bb48cab1928443"
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
    url "https:files.pythonhosted.orgpackages498b431e1f1a377163118288f77ecc38a775b70224a6f8e99946c5be3521d19amsgraph-core-1.0.0.tar.gz"
    sha256 "f26bcbbb3cd149dd7f1613159e0c2ed862888d61bfd20ef0b08b9408eb670c9d"
  end

  resource "msgraph-sdk" do
    url "https:files.pythonhosted.orgpackagese513d07b12326f805579d9b5358f631e4641ea20f60bbf1a7e35bde1afbc80c5msgraph-sdk-1.2.0.tar.gz"
    sha256 "689eec74fcb5cb29446947e4761fa57edeeb3ec1dccd7975c44d12d8d9db9c4f"
  end

  resource "msrest" do
    url "https:files.pythonhosted.orgpackages68778397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "msrestazure" do
    url "https:files.pythonhosted.orgpackages48fc5c2940301a83f18884a8e3aead2b2ff177a1a373f75c7b17e2e404199b2amsrestazure-0.6.4.tar.gz"
    sha256 "a06f0dabc9a6f5efe3b6add4bd8fb623aeadacf816b7a35b0f89107e0544d189"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https:files.pythonhosted.orgpackages3a9e77153a81a6eba4efcc28d8a4a00ae1b619108bf0225a879fb7084cb402dbopentelemetry_api-1.24.0.tar.gz"
    sha256 "42719f10ce7b5a9a73b10a4baf620574fb8ad495a9cbe5c18d76b75d8689c67e"
  end

  resource "opentelemetry-sdk" do
    url "https:files.pythonhosted.orgpackagesa2e338a0ee0aa9dc5886e3235f4c83bf374a351109332191394147f79a484c31opentelemetry_sdk-1.24.0.tar.gz"
    sha256 "75bc0563affffa827700e0f4f4a68e1e257db0df13372344aebc6f8a64cde2e5"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https:files.pythonhosted.orgpackages8df8c8de6e148aedf56adf16981ed590d05e7bbe5594f6dfdd4eb780c5da0358opentelemetry_semantic_conventions-0.45b0.tar.gz"
    sha256 "7c84215a44ac846bc4b8e32d5e78935c5c43482e491812a0bb8aaf87e4d92118"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "paginate" do
    url "https:files.pythonhosted.orgpackages6858e670a947136fdcece8ac5376b3df1369d29e4f6659b0c9b358605b115e9epaginate-0.5.6.tar.gz"
    sha256 "5e6007b6a9398177a7e1648d04fdd9f8c9766a1a945bceac82f1929e8c78af2d"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pendulum" do
    url "https:files.pythonhosted.orgpackagesb8fe27c7438c6ac8b8f8bef3c6e571855602ee784b85d072efddfff0ceb1cd77pendulum-3.0.0.tar.gz"
    sha256 "5d034998dea404ec31fae27af6b22cff1708f830a1ed7353be4d1019bb9f584e"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
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

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesdfab67eda485b025e9253cce0eaede9b6158a08f62af7013a883b2c8775917b2pydantic-1.10.14.tar.gz"
    sha256 "46f17b832fe27de7850896f3afee50ea682220dd218f7e9c88d436788419dca6"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pymdown-extensions" do
    url "https:files.pythonhosted.orgpackagesb0ece3d966cfb286d5a48e7c43a559a297b857ab935209ee9072e5a5492706c9pymdown_extensions-10.7.1.tar.gz"
    sha256 "c70e146bdd83c744ffc766b4671999796aba18842b268510a329f7f64700d584"
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

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "pyyaml-env-tag" do
    url "https:files.pythonhosted.orgpackagesfb8eda1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629cpyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages59d748b862b8133da2e0ed091195028f0d45c4d0be0f7f23dbe046a767282f37referencing-0.34.0.tar.gz"
    sha256 "5773bd84ef41799a5a8ca72dc34590c041eb01bf9aa02632b4a973fb0181a844"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesb53931626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages2b69ba1b5f52f96cde4f2d8eca74a0aa2c11a66b2fe58d0fb63b2e46edce6ed3requests-file-2.0.0.tar.gz"
    sha256 "20c5931629c558fda566cacc10cfe2cd502433e628f568c34c80d96a0cc95972"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages55bace7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5erpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages5a47d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecfs3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackages4ee801e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4d5bdc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83dsetuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "shodan" do
    url "https:files.pythonhosted.orgpackagesc506c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "slack-sdk" do
    url "https:files.pythonhosted.orgpackagesf877e567bfc892a352ea2c6bc7e29830bed763b4a14681e7fefaf82974a9f775slack_sdk-3.27.1.tar.gz"
    sha256 "85d86b34d807c26c8bb33c1569ec0985876f06ae4a2692afba765b7a5490d28c"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "std-uritemplate" do
    url "https:files.pythonhosted.orgpackages2268bfc445f7fdf96363da9528ae398eb599e5a619a4909296f065a51a72af94std_uritemplate-0.0.55.tar.gz"
    sha256 "9073f56a77e44d0583fb6645c37e4a640a34f22a255d00e3793cd3f30da58a68"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "time-machine" do
    url "https:files.pythonhosted.orgpackagesdcc1ca7e6e7cc4689dadf599d7432dd649b195b84262000ed5d87d52aafcb7e6time-machine-2.14.1.tar.gz"
    sha256 "57dc7efc1dde4331902d1bdefd34e8ee890a5c28533157e3b14a429c86b39533"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackagesdbedc92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages163a0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
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
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "watchdog" do
    url "https:files.pythonhosted.orgpackagescd3c43eeaa9ea17a2657d639aa3827beaa77042809410f86fb76f0d0ea6a2102watchdog-4.0.0.tar.gz"
    sha256 "e3e7065cbdabe6183ab82199d7a4f6b3ba0a438c5a512a68559846ccb76a78ec"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xlsxwriter" do
    url "https:files.pythonhosted.orgpackagesa6c3b36fa44a0610a0f65d2e65ba6a262cbe2554b819f1449731971f7c16ea3cXlsxWriter-3.2.0.tar.gz"
    sha256 "9977d0c661a72866a61f9f7a809e25ebbb0fb7036baa3b9fe74afcfca6b3cb8c"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3eef65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"

    # Multiple resources require `setuptools`, so it must be installed first
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("setuptools")
    venv.pip_install resources.reject { |r| r.name == "setuptools" }
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}prowler aws --list-services")

    assert_match "NoCredentialsError[33]: Unable to locate credentials",
      shell_output("#{bin}prowler aws --quick-inventory 2>&1", 1)

    assert_match "Prowler #{version}", shell_output("#{bin}prowler -v")
  end
end