class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https:docs.microsoft.comcliazureoverview"
  url "https:github.comAzureazure-cliarchiverefstagsazure-cli-2.65.0.tar.gz"
  sha256 "e9d4503b82eca5c78ef0acbe83ad229e35821caef200d7b290f06c66e5749bcf"
  license "MIT"
  head "https:github.comAzureazure-cli.git", branch: "dev"

  livecheck do
    url :stable
    regex(azure-cli[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a61db9082f4b688c3dc00b595ecaa7cb2658786740d4c577b7c6f4e291ef0447"
    sha256 cellar: :any,                 arm64_sonoma:  "ca44bcfd45b698538b26c58c19f8c8eac98d2d9463c3b23d3f761729894bf442"
    sha256 cellar: :any,                 arm64_ventura: "5cc569dddb312f6d8054603076a17ac0c25635c32b4f1c1a628838e212830274"
    sha256 cellar: :any,                 sonoma:        "7ba5980beb33127de872d213d8ae6c5d1221a85d2c812de8795e4614229b529f"
    sha256 cellar: :any,                 ventura:       "2cf80661b412e7b6ed1d88529a33ad8b688709bb463f92278ec66619a2ea9f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d4102331281e026f189acc43cac23567dddca6df8762bb476a77f48ad0038d"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "Deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "PyGithub" do
    url "https:files.pythonhosted.orgpackages9836386d282903c572b18abc36de68aaf4146db4659c82dceee009ef88a86b67PyGithub-1.55.tar.gz"
    sha256 "1bbfff9372047ff3f21d5cd8e07720f3dbfdaf6462fcaed9d815f528f1ba7283"
  end

  resource "PySocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "adal" do
    url "https:files.pythonhosted.orgpackages90d7a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "antlr4-python3-runtime" do
    url "https:files.pythonhosted.orgpackagesb6007f1cab9b44518ca225a03f4493ac9294aab5935a7a28486ba91a20ea29cfantlr4-python3-runtime-4.13.1.tar.gz"
    sha256 "3cd282f5ea7cfb841537fe01f143350fdb1c0b1ce7981443a2fa8513fddb6d1a"
  end

  resource "applicationinsights" do
    url "https:files.pythonhosted.orgpackagesf502b831bf3281723b81eb6b041d91d2c219123366f975ec0a73556620773417applicationinsights-0.11.9.tar.gz"
    sha256 "30a11aafacea34f8b160fbdc35254c9029c7e325267874e3c68f6bdbcd6ed2c3"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7951fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "azure-appconfiguration" do
    url "https:files.pythonhosted.orgpackages07fee4aa2ca52bcd3fcc2231c02e216d97010b4345cbd963e10eb49539c59cbdazure-appconfiguration-1.7.0.tar.gz"
    sha256 "9eb079d061f05738ad3b42fe1d53da73fc6076dd7178a52df3e631f131d4ed1f"
  end

  resource "azure-batch" do
    url "https:files.pythonhosted.orgpackages353e4611960f8ceb281285d764f32a0e88515fab4e1e32ff5d02bc77e55bbcb6azure-batch-14.2.0.tar.gz"
    sha256 "c79267d6c3d3fe14a16a422ab5bbfabcbd68ed0b58b6bbcdfa0c8345c4c78532"
  end

  resource "azure-common" do
    url "https:files.pythonhosted.orgpackages9933fe8ffd51ed08a2b77d34b6a997f8e3e884a6e08f08f9626c9969d930fd3cazure-common-1.1.22.zip"
    sha256 "c8e4a7bf15f139f779a415d2d3c371738b1e9f5e14abd9c18af6b9bed3babf35"
  end

  resource "azure-core" do
    url "https:files.pythonhosted.orgpackagesfd510ee0a2844712f54117b3ee4853c3d209ba37641f0c587be22a993990989eazure-core-1.28.0.zip"
    sha256 "e9eefc66fc1fde56dab6f04d4e5d12c60754d5a9fa49bdcfd8534fc96ed936bd"
  end

  resource "azure-cosmos" do
    url "https:files.pythonhosted.orgpackages3cd3f74bf55c48851944b726cb36883c68d3c4bb887fb2196f216ca543c691e1azure-cosmos-3.2.0.tar.gz"
    sha256 "4f77cc558fecffac04377ba758ac4e23f076dc1c54e2cf2515f85bc15cbde5c6"
  end

  resource "azure-data-tables" do
    url "https:files.pythonhosted.orgpackages8b0cbc5ca41bcfeb1ce3a7e870084abc257463be521da27c27409f4b502f4739azure-data-tables-12.4.0.zip"
    sha256 "dd5fc8de91e2f8908efa4c64ca7f63cf83b3068a9ba426298de3b54139e9665c"
  end

  resource "azure-datalake-store" do
    url "https:files.pythonhosted.orgpackages22ff61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-graphrbac" do
    url "https:files.pythonhosted.orgpackages3e4e4598ea52efc2654b0c865243bd60625d4ffa4df874e7e5dcb76a9a4ddbbcazure-graphrbac-0.60.0.zip"
    sha256 "d0bb62d8bf8e196b903f3971ba4afa448e4fe14e8394ebfcdd941d84d62ecafe"
  end

  resource "azure-keyvault-administration" do
    url "https:files.pythonhosted.orgpackages804fb0d62738a6e3c8e27c3cc33400e8deb14d6490042180fc872c1cdbe891acazure-keyvault-administration-4.4.0b2.tar.gz"
    sha256 "8d0edefad78024c3a97b071fa5cf50daf923085e9d4379259f7237d911e66810"
  end

  resource "azure-keyvault-certificates" do
    url "https:files.pythonhosted.orgpackagese6cf85d521e65557e4dee2cd9c700f518c3a46f6f71068e61c07d0b13b2e0727azure-keyvault-certificates-4.7.0.zip"
    sha256 "9e47d9a74825e502b13d5481c99c182040c4f54723f43371e00859436dfcf3ca"
  end

  resource "azure-keyvault-keys" do
    url "https:files.pythonhosted.orgpackages50f0cc544f2ea8dc1a7ea9a1159ffb5b2b56b3fb86694fc565c87e5444a98718azure-keyvault-keys-4.9.0b3.tar.gz"
    sha256 "aa8b1ec9fe96a81106f2f3dcd61175ecae3a01693c05af15f4a45e77894e946a"
  end

  resource "azure-keyvault-secrets" do
    url "https:files.pythonhosted.orgpackages5ca178ecabf98e97d600dcac1559ff64b4bc9f84eca126c0aeba859916832b0cazure-keyvault-secrets-4.7.0.zip"
    sha256 "77ee2534ba651a1f306c85d7b505bc3ccee8fea77450ebafafc26aec16e5445d"
  end

  resource "azure-mgmt-advisor" do
    url "https:files.pythonhosted.orgpackages3496e28b949dd55e1fc381fae2676c95c8a9410fa4b9768cc02ec3668fc490c4azure-mgmt-advisor-9.0.0.zip"
    sha256 "fc408b37315fe84781b519124f8cb1b8ac10b2f4241e439d0d3e25fd6ca18d7b"
  end

  resource "azure-mgmt-apimanagement" do
    url "https:files.pythonhosted.orgpackages554118982d29dceae7d2cca0e03513e30d65229a6785a0ab0d6b05e942ea6f6cazure-mgmt-apimanagement-4.0.0.zip"
    sha256 "0224e32c9dbc83cd319eb4452df3d47af26079ac4ba6e1a6be4777f85b24362c"
  end

  resource "azure-mgmt-appconfiguration" do
    url "https:files.pythonhosted.orgpackagesfe67c49099506deec6d902af1e9e71e8f9f3602615966cef7dd1c7b236942e01azure-mgmt-appconfiguration-3.0.0.zip"
    sha256 "14986e560a8d8dd4487a03f8bd4212ac0b47bef5657b95501552133e6e072c4c"
  end

  resource "azure-mgmt-appcontainers" do
    url "https:files.pythonhosted.orgpackages97ad3eb1687c3f27b8a4c87b284f5180984073564f47ebd8445e4a44184473a7azure-mgmt-appcontainers-2.0.0.zip"
    sha256 "71c74876f7604d83d6119096aa42dcf2512e32e004111be5e41d61b89c8192f5"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https:files.pythonhosted.orgpackages04d631fdc6bc6cebfbf66e12e8a5556e5f7bda7f7ec57367ec9d8025df62560aazure-mgmt-applicationinsights-1.0.0.zip"
    sha256 "c287a2c7def4de19f92c0c31ba02867fac6f5b8df71b5dbdab19288bb455fc5b"
  end

  resource "azure-mgmt-authorization" do
    url "https:files.pythonhosted.orgpackages9eabe79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73dazure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-batch" do
    url "https:files.pythonhosted.orgpackages376db76ba7ca3b3e68f173afbdaf3373acd11d203be1ccf9408957525c355cbaazure-mgmt-batch-17.3.0.tar.gz"
    sha256 "fc94881a6acdb8a9533f371b6f7b2d3eaea1789eb955014b24a908d6dfe75991"
  end

  resource "azure-mgmt-batchai" do
    url "https:files.pythonhosted.orgpackages808bed14bdce18c5f7a54dde2d4717f7bfb4bf1546b7b380d2af0af6cb11a999azure-mgmt-batchai-7.0.0b1.zip"
    sha256 "993eafbe359bab445642276e811db6f44f09795122a1b3c3dd703f9c333723a6"
  end

  resource "azure-mgmt-billing" do
    url "https:files.pythonhosted.orgpackagesb04059a55614cc987457efe35c2055a7c5d8757f9cb5207010cb1d3ddf382eddazure-mgmt-billing-6.0.0.zip"
    sha256 "d4f5c5a4188a456fe1eb32b6c45f55ca2069c74be41eb76921840b39f2f5c07f"
  end

  resource "azure-mgmt-botservice" do
    url "https:files.pythonhosted.orgpackagesb98d0b681fc3be71de2e46bb2d4a16e6375eb1f65b65f4f240d1af056929c4ddazure-mgmt-botservice-2.0.0b3.zip"
    sha256 "5d919039e330f2eb32435b65f23e7b7d9deea8bb21a261d8f633bfadba503af3"
  end

  resource "azure-mgmt-cdn" do
    url "https:files.pythonhosted.orgpackagesd7fc48310b510043223c42ea2f9ac1e91a9a88b7438c0882d4c32db9f0b9fb0cazure-mgmt-cdn-12.0.0.zip"
    sha256 "b7c3ee2189234b4af51ace2924927c5fd733f3de748a642d6d5040067c8c9ddd"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https:files.pythonhosted.orgpackagesf7868f31cf3709ad612f5e0f17810d97124193468eb5f1e3b36d37227715a2dfazure-mgmt-cognitiveservices-13.5.0.zip"
    sha256 "44af0b19b1f827e9cdea09c6054c1e66092a51c32bc1ef5a56dbd9b40bc57815"
  end

  resource "azure-mgmt-compute" do
    url "https:files.pythonhosted.orgpackages90f2a2b1391e9df876d7ef9086f8d41ad4666eafef921ae0c47da931f8cedb1aazure-mgmt-compute-33.0.0.tar.gz"
    sha256 "a3cc0fe4f09c8e1d3523c1bfb92620dfe263a0a893b0ac13a33d7057e9ddddd2"
  end

  resource "azure-mgmt-containerinstance" do
    url "https:files.pythonhosted.orgpackages4c19cdb22d87560238893f5c014176b4e6868c3befbd6585bb5c44bdb1ddc997azure-mgmt-containerinstance-10.1.0.zip"
    sha256 "78d437adb28574f448c838ed5f01f9ced378196098061deb59d9f7031704c17e"
  end

  resource "azure-mgmt-containerregistry" do
    url "https:files.pythonhosted.orgpackagesa9df97427d1bc1bb7307c7bfa73fdb8feb1ab6f74c3a2e67e8a9223abfa4b4ddazure-mgmt-containerregistry-10.3.0.tar.gz"
    sha256 "ae21651855dfb19c42d91d6b3a965c6c611e23f8bc4bf7138835e652d2f918e3"
  end

  resource "azure-mgmt-containerservice" do
    url "https:files.pythonhosted.orgpackages3df77cfc9177784b259aa0b403f460d87d7f59c379cb73f654ec29842476bc3aazure_mgmt_containerservice-32.0.0.tar.gz"
    sha256 "ccb587479d8a93ec78f7162590adc82e4fba4de76e4adc3419f33ad225efb292"
  end

  resource "azure-mgmt-core" do
    url "https:files.pythonhosted.orgpackagesae186f79cfddbf08f233de5a51961323c0b1b2174e06ae9460988091fd012043azure-mgmt-core-1.3.2.zip"
    sha256 "07f4afe823a55d704b048d61edfdc1318c051ed59f244032126350be95e9d501"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https:files.pythonhosted.orgpackages86f13be440072cc7f163ccd332e3793a4a0d18a74264fa94a5459135f67745b1azure_mgmt_cosmosdb-9.6.0.tar.gz"
    sha256 "667c7d8a8f542b0e7972e63274af536ad985187e24a6cc2e3c8eef35560881fc"
  end

  resource "azure-mgmt-databoxedge" do
    url "https:files.pythonhosted.orgpackagesbc97e6f9041c0e22cdf3fa8f5ccfec70daf0d1c15740bc5f36e8e9694ff98a98azure-mgmt-databoxedge-1.0.0.zip"
    sha256 "04090062bc1e8f00c2f45315a3bceb0fb3b3479ec1474d71b88342e13499b087"
  end

  resource "azure-mgmt-datamigration" do
    url "https:files.pythonhosted.orgpackages0647cccd2c22f8f525b8a1c38fd88ffef7ae989f50bd15f1ad5b955e27ef5985azure-mgmt-datamigration-10.0.0.zip"
    sha256 "5cee70f97fe3a093c3cb70c2a190c2df936b772e94a09ef7e3deb1ed177c9f32"
  end

  resource "azure-mgmt-devtestlabs" do
    url "https:files.pythonhosted.orgpackagesf018ef3217b4ef0acc25d1ed20f5e873f6ad3fe80dafaf8b9c17349063bb1d98azure-mgmt-devtestlabs-4.0.0.zip"
    sha256 "59549c4c4068f26466b1097b574a8e5099fb2cd6c8be0a00395b06d3b29e278d"
  end

  resource "azure-mgmt-dns" do
    url "https:files.pythonhosted.orgpackages5804a2849bf2e2a5e115666dfa50e7ca551e75fa39d0f9bfe83f0bdb7d7e4765azure-mgmt-dns-8.0.0.zip"
    sha256 "407c2dacb33513ffbe9ca4be5addb5e9d4bae0cb7efa613c3f7d531ef7bf8de8"
  end

  resource "azure-mgmt-eventgrid" do
    url "https:files.pythonhosted.orgpackagesffef2d48ac5af17c3ae32feaf40769e4579ca47c4d1c5a6798f149faf0397b65azure-mgmt-eventgrid-10.2.0b2.zip"
    sha256 "41c1d8d700b043254e11d522d3aff011ae1da891f909c777de02754a3bb4a990"
  end

  resource "azure-mgmt-eventhub" do
    url "https:files.pythonhosted.orgpackages20dc5e2ff08ecff52df3a767b62bd92eef43c94ebd7e8dccd8127df863ce2712azure-mgmt-eventhub-10.1.0.zip"
    sha256 "319aa1481930ca9bc479f86811610fb0150589d5980fba805fa79d7010c34920"
  end

  resource "azure-mgmt-extendedlocation" do
    url "https:files.pythonhosted.orgpackagesb7dea7b62f053597506e01641c68e1708222f01cd7574e4147d4f645ff6e6aaaazure-mgmt-extendedlocation-1.0.0b2.zip"
    sha256 "9a37c7df94fcd4943dee35601255a667c3f93305d5c5942ffd024a34b4b74fc0"
  end

  resource "azure-mgmt-hdinsight" do
    url "https:files.pythonhosted.orgpackages893c04ce6c779c28d95a13e37cf00854a31472ef4b563d98361c50200180b8f2azure-mgmt-hdinsight-9.0.0b3.tar.gz"
    sha256 "72549e08ff3eed3d6e23835e73ece1cc32bdf340bdf8919e78916c352c200f64"
  end

  resource "azure-mgmt-imagebuilder" do
    url "https:files.pythonhosted.orgpackages06a05996570f011ddab6dfcc19c5bf64056370c255ffbbd2232447f88f24e5d1azure-mgmt-imagebuilder-1.3.0.tar.gz"
    sha256 "3f325d688b6125c2fa92681e5b18ea407ba032d5be3f7c0724406d733e6c14ef"
  end

  resource "azure-mgmt-iotcentral" do
    url "https:files.pythonhosted.orgpackages9e9e50b30ad35c0038ce93ccf80535d2052967dc0dedae0eee84d2dc81458614azure-mgmt-iotcentral-10.0.0b1.zip"
    sha256 "d42899b935d88486fbe1e1906542471f3a2f60d9e755ddd876ed540b2d81bb4d"
  end

  resource "azure-mgmt-iothub" do
    url "https:files.pythonhosted.orgpackagese899145453e748480be1d7abf17ab56f45f295679bde00b3edf7a4199494cd74azure-mgmt-iothub-3.0.0.tar.gz"
    sha256 "daf21fc98c68a353ec616318c0e62be04c8d6899960be8c2cbf991673ac8b722"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https:files.pythonhosted.orgpackages4778b5252f7e42d596d0e8ab4d7ea5f90545436d83c4bf45f1e86d7618d128dbazure-mgmt-iothubprovisioningservices-1.1.0.zip"
    sha256 "d383a826e7dff772fad86e88a33a661e911a51b1c71c3ea72a590c1d5a09bc9e"
  end

  resource "azure-mgmt-keyvault" do
    url "https:files.pythonhosted.orgpackages5ce654879a503c28d2b1ef991f086c41c86218a82dd81a5b870c59b79a0f15ceazure-mgmt-keyvault-10.3.0.tar.gz"
    sha256 "183b4164cf1868b8ea7efeaa98edad7d2a4e14a9bd977c2818b12b75150cd2a2"
  end

  resource "azure-mgmt-kusto" do
    url "https:files.pythonhosted.orgpackages0d79887c8f71d7ebd87e4f2359f6726a0a881f1c9369167bf075bf22ba39751cazure-mgmt-kusto-0.3.0.zip"
    sha256 "9eb8b7781fd4410ee9e207cd0c3983baf9e58414b5b4a18849d09856e36bacde"
  end

  resource "azure-mgmt-loganalytics" do
    url "https:files.pythonhosted.orgpackagesda3fc784b29431b597d11fdcdb6b430d114819459eb34da190fceff5a70901cdazure-mgmt-loganalytics-13.0.0b4.zip"
    sha256 "266d6deefe6fc858cd34cfdebd568423db1724a370264e97017b894914a72879"
  end

  resource "azure-mgmt-managementgroups" do
    url "https:files.pythonhosted.orgpackagesb3e774159d9cd15966031ba03a92e0b53c6b0cc895bb5fdb7374fc326fb9dd21azure-mgmt-managementgroups-1.0.0.zip"
    sha256 "bab9bd532a1c34557f5b0ab9950e431e3f00bb96e8a3ce66df0f6ce2ae19cd73"
  end

  resource "azure-mgmt-maps" do
    url "https:files.pythonhosted.orgpackagesc2d135d471f400b612b38473ffa7747ba5fa2f79f47e410009fb887db19a4e8aazure-mgmt-maps-2.0.0.zip"
    sha256 "384e17f76a68b700a4f988478945c3a9721711c0400725afdfcb63cf84e85f0e"
  end

  resource "azure-mgmt-marketplaceordering" do
    url "https:files.pythonhosted.orgpackages179c74d7746672a4e9ac6136e3043078a2f4d0a0e3568daf2de772de8e4d7cffazure-mgmt-marketplaceordering-1.1.0.zip"
    sha256 "68b381f52a4df4435dacad5a97e1c59ac4c981f667dcca8f9d04453417d60ad8"
  end

  resource "azure-mgmt-media" do
    url "https:files.pythonhosted.orgpackages549790167348963e7544be9984866712dadaae665d91d0f4fbbae6cddf5875baazure-mgmt-media-9.0.0.zip"
    sha256 "4c8ee5f2c490d905203ea884dc2bbf17aed69daf8a1db412ddfb888ce6fde593"
  end

  resource "azure-mgmt-monitor" do
    url "https:files.pythonhosted.orgpackages75345acd343743ba66e06107f323d06844faa51900380143992b4a9ec3554883azure-mgmt-monitor-5.0.0.zip"
    sha256 "78bf4a268c314c5ee164941040234967b97eaca3c533cc0fe6f12282ddd91461"
  end

  resource "azure-mgmt-msi" do
    url "https:files.pythonhosted.orgpackages77d74ef788fb8e0f90a3fe5875b05dcef535ad4b4a766372af82870120cd5dd3azure-mgmt-msi-7.0.0.zip"
    sha256 "72d46c9a62783ec4eab619be9d1b78ffebbdaa164d406fd303f16303f37256b2"
  end

  resource "azure-mgmt-netapp" do
    url "https:files.pythonhosted.orgpackages0ff2074f7ddf5e62b5853b88483fcdc5bd5acb12ae16d98aa910c8e57132f1f3azure-mgmt-netapp-10.1.0.zip"
    sha256 "7898964ce0a4d82efd268b64bbd6ca96edef53a1fcd34e215ab5fe87be8c8d03"
  end

  resource "azure-mgmt-policyinsights" do
    url "https:files.pythonhosted.orgpackagesd8ec4af9af212e5680831208e12874dd064dfdd5a0876af0edfe15be79c04f0eazure-mgmt-policyinsights-1.1.0b4.zip"
    sha256 "681d7ac72ae13581c97a2b6f742795fa48a4db50762c2fb9fce4834081b04e92"
  end

  resource "azure-mgmt-privatedns" do
    url "https:files.pythonhosted.orgpackages72f0e8e401da635a72936c7edc32d4fdb7fcc4572400e0d66ed6ff6978b935a9azure-mgmt-privatedns-1.0.0.zip"
    sha256 "b60f16e43f7b291582c5f57bae1b083096d8303e9d9958e2c29227a55cc27c45"
  end

  resource "azure-mgmt-rdbms" do
    url "https:files.pythonhosted.orgpackagesad48a494ad47d0ea08d1f9a29abcd241787d2513b5727ac6f3836a66487eaf39azure-mgmt-rdbms-10.2.0b17.tar.gz"
    sha256 "d679d1932af8226efd07b0c3a86cff14eacf013a05686844f9aeebe5b64cb8e4"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https:files.pythonhosted.orgpackagesfa52bb554f77c7e73f4ddf9833abfbc183a073f26a20453034c54798c0c9bb44azure-mgmt-recoveryservices-3.0.0.tar.gz"
    sha256 "df212dfadfbcc659c31231c3e170aab7c21144d172b0f88268ab0f5ad8e95882"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https:files.pythonhosted.orgpackagesd110e3d49f12842a84de410f8ed9831d6dcf6ee04e993f79fe4eb33adf1a9265azure-mgmt-recoveryservicesbackup-9.1.0.tar.gz"
    sha256 "1e9fd406c0c9ee2627f5a371f012f877342f7fc6f33b2564fcd14d6f0663cd0f"
  end

  resource "azure-mgmt-redhatopenshift" do
    url "https:files.pythonhosted.orgpackages01a2b89ba36f4bc2708a7ab0115b451028b8888184b3c19bd9a3ac71afec8941azure-mgmt-redhatopenshift-1.5.0.tar.gz"
    sha256 "51fb7429c39c88acc9fa273d9f89f19303520662996a6d7d8e1122a98f5f2527"
  end

  resource "azure-mgmt-redis" do
    url "https:files.pythonhosted.orgpackagesde4b5aefcaabcb66ef7a9c90c6e119c6d07b4401de186f61c476ae535cfeab26azure-mgmt-redis-14.4.0.tar.gz"
    sha256 "08847325aff07b17ae85e6fe033d0a05acf8cf41cc9a9cc60623ae2dac4667ef"
  end

  resource "azure-mgmt-resource" do
    url "https:files.pythonhosted.orgpackages896019471f7f2499888da9d5abc7ff8c470a6d620fbf35657fff31df9eeb483dazure-mgmt-resource-23.1.1.tar.gz"
    sha256 "20b6b006b544fdb19607f3f6a381105625e0bb60fbf3036f39885c4646d3343e"
  end

  resource "azure-mgmt-search" do
    url "https:files.pythonhosted.orgpackagesc55270315fa90fddd4ac681ecf39ce63e81254e4aa972be3ad94a29eb5e8e24dazure-mgmt-search-9.0.0.zip"
    sha256 "19cfaaa136b5104e3f62626f512a951becd9e74c1fa21bd639efdf2c9fef81bd"
  end

  resource "azure-mgmt-security" do
    url "https:files.pythonhosted.orgpackages25b2bbe822bca8dc617ac5fab0eb40e5786a2ed933b484a3238af5b7a19e6debazure-mgmt-security-6.0.0.tar.gz"
    sha256 "ceafc1869899067110bd830c5cc98bc9b8f32d8ea840ca1f693b1a5f52a5f8b0"
  end

  resource "azure-mgmt-servicebus" do
    url "https:files.pythonhosted.orgpackagesf9fa88014c3bd2fe34694184e9ced1b8230de495bcf2eb368c0bfc82db36dc12azure-mgmt-servicebus-8.2.0.zip"
    sha256 "8be9208f141d9a789f68db8d219754ff78069fd8f9390e9f7644bb95a3be9ec2"
  end

  resource "azure-mgmt-servicefabric" do
    url "https:files.pythonhosted.orgpackages5574056878a1bbe4f07a49ac8479a587ae73c0d7d719cce3b540d4b22af44e81azure-mgmt-servicefabric-2.1.0.tar.gz"
    sha256 "a08433049554436c90844bc8a96820e883699484e6ffc99032fd2571f8c5f7d6"
  end

  resource "azure-mgmt-servicefabricmanagedclusters" do
    url "https:files.pythonhosted.orgpackages56968f2cdaf1edb93f5af91db350e0446a028f14414cd9b8c17ef8781f80cef0azure-mgmt-servicefabricmanagedclusters-2.0.0b6.tar.gz"
    sha256 "6a4fed9cea3d36711e61b10a6a41160ac7dcff996559976cc1c2fa1178ba0905"
  end

  resource "azure-mgmt-servicelinker" do
    url "https:files.pythonhosted.orgpackages16f4d8765085cffab9820d306dce8b56972af6fdb7bdd05b3e6617a4d19fb7e2azure-mgmt-servicelinker-1.2.0b2.tar.gz"
    sha256 "3e910530cf2b8bd3a001aefd74686f3cacb96057c3659bacb4150389e42bb595"
  end

  resource "azure-mgmt-signalr" do
    url "https:files.pythonhosted.orgpackagese631afada0487b2890e8bfb72e3e3c55569d069eb6f461b90d78b772455af4a2azure-mgmt-signalr-2.0.0b1.tar.gz"
    sha256 "a0ad9c78112843b800786ea6c9efb1f073f3414f5b50d44f549b515b618be318"
  end

  resource "azure-mgmt-sql" do
    url "https:files.pythonhosted.orgpackages217b55d4fc488715129825e97184c7586b08559c5b72e205c20105abc1a7d23fazure_mgmt_sql-4.0.0b19.tar.gz"
    sha256 "d39358c0bb9f546fe148684bb092061dd6b452b993811f74227ecff201782237"
  end

  resource "azure-mgmt-sqlvirtualmachine" do
    url "https:files.pythonhosted.orgpackages8c9ab5f0ebf6b82df07a55556bfb18388d09582e50369b6a69e85b0df66dcb02azure-mgmt-sqlvirtualmachine-1.0.0b5.zip"
    sha256 "6458097e58329d14b1a3e07e56ca38797d4985e5a50d08df27d426ba95f2a4c7"
  end

  resource "azure-mgmt-storage" do
    url "https:files.pythonhosted.orgpackages1157bffd94c4b67b6d0539f9d0fa031aac961f9df56321169085b5f17b891cdeazure-mgmt-storage-21.2.0.tar.gz"
    sha256 "287c9840b01be931819d403da7ed52bd62fd077b0529dd470e6dbc4fede4b20d"
  end

  resource "azure-mgmt-synapse" do
    url "https:files.pythonhosted.orgpackages9a3783c4b44418fb7bb10389e43a5fc29c164bd8524f73a0e664d5f4ccf716beazure-mgmt-synapse-2.1.0b5.zip"
    sha256 "e44e987f51a03723558ddf927850db843c67380e9f3801baa288f1b423f89be9"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https:files.pythonhosted.orgpackages0ff031bbc546d10254513905174e429e320f192f853159482f2bdc71b4623830azure-mgmt-trafficmanager-1.0.0.zip"
    sha256 "4741761e80346c4edd4cb3f271368ea98063f804d015e245c2fe048ed2b596a8"
  end

  resource "azure-mgmt-web" do
    url "https:files.pythonhosted.orgpackagesd1a9c255592263d798843d2ccc46ee42129f5ae6b95e882dae3544938c66e449azure-mgmt-web-7.2.0.tar.gz"
    sha256 "efcfe6f7f520ed0abcfe86517e1c8cf02a712f737a3db0db7cb46c6d647981ed"
  end

  resource "azure-monitor-query" do
    url "https:files.pythonhosted.orgpackagesad16fd06cccfc583d8d38d8d99ee92ec1bbc9604cf6e8c62e64ddca5644e0a60azure-monitor-query-1.2.0.zip"
    sha256 "2c57432443f203069e64e500c7e958ca31650f641950515ffe65555ba134c371"
  end

  resource "azure-multiapi-storage" do
    url "https:files.pythonhosted.orgpackagesd884f9a4fcf58f5d531d7b1b660df14d25b9d9443b3ad4c9137bfbf8307fb20bazure-multiapi-storage-1.3.0.tar.gz"
    sha256 "b652a8808b37f6d228315977a7f602a277cf74fae95fda1cf56a90f85ba18109"
  end

  resource "azure-storage-common" do
    url "https:files.pythonhosted.orgpackagesae450d21c1543afd3a97c416298368e06df158dfb4740da0e646a99dab6080deazure-storage-common-1.4.2.tar.gz"
    sha256 "4ec87c7537d457ec95252e0e46477e2c1ccf33774ffefd05d8544682cb0ae401"
  end

  resource "azure-synapse-accesscontrol" do
    url "https:files.pythonhosted.orgpackagese9fddf10cfab13b3e715e51dd04077f55f95211c3bad325d59cda4c22fec67eaazure-synapse-accesscontrol-0.5.0.zip"
    sha256 "835e324a2072a8f824246447f049c84493bd43a1f6bac4b914e78c090894bb04"
  end

  resource "azure-synapse-artifacts" do
    url "https:files.pythonhosted.orgpackagesdfd690f9b841f94ca4daf9b8def64bfc937c0069988c0580e9a04e8ad167249eazure-synapse-artifacts-0.19.0.tar.gz"
    sha256 "52f092b22677d792280f0bcc234d892c9f738e93c8e14b74c195101b9ba27184"
  end

  resource "azure-synapse-managedprivateendpoints" do
    url "https:files.pythonhosted.orgpackages14853f7224fb15155be1acd9d5cb2a5ac0575b617cade72a890f09d35b175ad7azure-synapse-managedprivateendpoints-0.4.0.zip"
    sha256 "900eaeaccffdcd01012b248a7d049008c92807b749edd1c9074ca9248554c17e"
  end

  resource "azure-synapse-spark" do
    url "https:files.pythonhosted.orgpackages76be1a645ecf2b8215e2753d115e163b8c0fa0a4d9fec02f24486e7f9993c212azure-synapse-spark-0.2.0.zip"
    sha256 "390e5bae1c1e108aed37688fe08e4d69c742f6ddd852218856186a4acdc532e2"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagesd8ba21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4ddbcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagesc202a95f2b11e207f68bc64d7aae9666fed2e2b3f307748d5123dffb72a1bbeacertifi-2024.7.4.tar.gz"
    sha256 "5a1e7645bc0ec61a09e26c36f6106dd4cf40c6db3a1fb6352b0244e7fb057c7b"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cryptography" do
    url "https:files.pythonhosted.orgpackagesdeba0664727028b37e249e73879348cc46d45c5c1a2a2e81e8166462953c5755cryptography-43.0.1.tar.gz"
    sha256 "203e92a75716d8cfb491dc47c79e17d0d9207ccffcbcb35f598fbe463ae3444d"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fabric" do
    url "https:files.pythonhosted.orgpackages0d3f337f278b70ba339c618a490f6b8033b7006c583bd197a897f12fbc468c51fabric-3.2.2.tar.gz"
    sha256 "8783ca42e3b0076f08b26901aac6b9d9b1f19c410074e7accfab902c184ff4a3"
  end

  resource "humanfriendly" do
    url "https:files.pythonhosted.orgpackagescc3f2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "invoke" do
    url "https:files.pythonhosted.orgpackagesf942127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6cinvoke-2.2.0.tar.gz"
    sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackagesdb7ac0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1afisodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "javaproperties" do
    url "https:files.pythonhosted.orgpackagesdb4358b89453727acdcf07298fe0f037e45b3988e5dcc78af5dce6881d0d2c5ejavaproperties-0.5.1.tar.gz"
    sha256 "2b0237b054af4d24c74f54734b7d997ca040209a1820e96fb4a82625f7bd40cf"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages5c403bed01fc17e2bb1b02633efc29878dfa25da479ad19a69cfb11d2b88ea8ejmespath-0.9.5.tar.gz"
    sha256 "cca55c8d153173e21baa59983015ad0daf603f9cb799904ff057bfb8ff8dc2d9"
  end

  resource "jsondiff" do
    url "https:files.pythonhosted.orgpackagesdd132b691afe0a90fb930a32b8fc1b0fd6b5bdeaed459a32c5a58dc6654342dajsondiff-2.0.0.tar.gz"
    sha256 "2795844ef075ec8a2b8d385c4d59f5ea48b08e7180fce3cb2787be0db00b1fb4"
  end

  resource "knack" do
    url "https:files.pythonhosted.orgpackages0c5b7cc69b2941a11bdace4faffef8f023543feefd14ab0222b6e62a318c53b9knack-0.11.0.tar.gz"
    sha256 "eb6568001e9110b1b320941431c51033d104cc98cda2254a5c2b09ba569fd494"
  end

  resource "msal" do
    url "https:files.pythonhosted.orgpackages59048d7aa5c671a26ca5612257fd419f97380ba89cdd231b2eb67df58483796dmsal-1.31.0.tar.gz"
    sha256 "2c4f189cf9cc8f00c80045f66d39b7c0f3ed45873fd3d1f2af9f22db2e12ff4b"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackages2d38ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5ebmsal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "msrest" do
    url "https:files.pythonhosted.orgpackages68778397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "msrestazure" do
    url "https:files.pythonhosted.orgpackages48fc5c2940301a83f18884a8e3aead2b2ff177a1a373f75c7b17e2e404199b2amsrestazure-0.6.4.tar.gz"
    sha256 "a06f0dabc9a6f5efe3b6add4bd8fb623aeadacf816b7a35b0f89107e0544d189"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackagesccaf11996c4df4f9caff87997ad2d3fd8825078c277d6a928446d2b6cf249889paramiko-3.4.0.tar.gz"
    sha256 "aac08f26a31dc4dffd92821527d1682d99d52f9ef6851968114a8728f3c274d3"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackages546a42056522e1d79fa9768712782f37365ef786d905e4efeed6db44cad1803bpkginfo-1.8.2.tar.gz"
    sha256 "542e0d0b6750e2e21c20179803e40ab50598d8066d51097a0e382cba9eb02bff"
  end

  resource "portalocker" do
    url "https:files.pythonhosted.orgpackages382e32172e8418f2ba284cee4fd67cb547d39a7debb3eed37d514da173786112portalocker-2.3.2.tar.gz"
    sha256 "75cfe02f702737f1726d83e04eedfa0bda2cc5b974b1ceafb8d6b42377efbd5f"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages18c78c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "Pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "PyJWT" do
    url "https:files.pythonhosted.orgpackagesd86b6287745054dbcccf75903630346be77d4715c594402cec7c2518032416c2PyJWT-2.4.0.tar.gz"
    sha256 "d42908208c699b3b973cbeb01a969ba6a96c821eefb1c5bfe4c390c01d67abba"
  end

  resource "PyNaCl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "microsoft-security-utilities-secret-masker" do
    url "https:files.pythonhosted.orgpackagesced306730675783ff775af413153b7ea534931bba9d45687d3268eb9f313f2bcmicrosoft_security_utilities_secret_masker-1.0.0b3.tar.gz"
    sha256 "d04548230c67a3bd2cb460b28e71fe6cac168f48f06d76a969d9ca47bdf67343"
  end

  resource "pyOpenSSL" do
    url "https:files.pythonhosted.orgpackages5d70ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pycomposefile" do
    url "https:files.pythonhosted.orgpackagesa62958e6dddddf8f76af870365be52532d84ad40b469a317b39e9c0f087fa214pycomposefile-0.0.30.tar.gz"
    sha256 "190a2920ef05f86e620f3e0d1761931c2a57a38baa2877472337df69c8a1ca53"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackagesad995b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364cpython-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "PyYAML" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackagesdea2f55312dfe2f7a344d0d4044fdfae12ac8a24169dc668bd55f72b27090c32requests-oauthlib-1.2.0.tar.gz"
    sha256 "bd6533330e8748e94bf0b214775fed487d309b8b8fe823dc45641ebcd9a32f57"
  end

  resource "scp" do
    url "https:files.pythonhosted.orgpackages05e0ac4169e773e12a08d941ca3c006cb8c91bee9d6d80328a15af850b5e7480scp-0.13.2.tar.gz"
    sha256 "ef9d6e67c0331485d3db146bf9ee9baff8a48f3eb0e6c08276a8584b13bf34b3"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages31a9b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ecesemver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sshtunnel" do
    url "https:files.pythonhosted.orgpackagesc55c4b320d7ec4b0d5d4d6df1fdf66a5799625b3623d0ce4efe81719c6f8dfb3sshtunnel-0.1.5.tar.gz"
    sha256 "c813fdcda8e81c3936ffeac47cb69cfb2d1f5e77ad0de656c6dab56aeebd9249"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesae3d9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0atabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesc89365e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1burllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackages8d12cd10d050f7714ccc675b486cdcbbaed54c782a5b77da2bb82e5c7b31fb40websocket-client-1.3.1.tar.gz"
    sha256 "6278a75065395418283f887de7c3beafb3aa68dada5cacbe4b214e8d26da499b"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages58400d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    venv = virtualenv_create(libexec, "python3.12", system_site_packages: false)
    venv.pip_install resources

    # Get the CLI components we'll install
    components = [
      buildpath"srcazure-cli",
      buildpath"srcazure-cli-telemetry",
      buildpath"srcazure-cli-core",
    ]

    # Install CLI
    components.each do |item|
      cd item do
        venv.pip_install item
      end
    end

    (bin"az").write <<~EOS
      #!usrbinenv bash
      AZ_INSTALLER=HOMEBREW #{libexec}binpython -Im azure.cli "$@"
    EOS

    generate_completions_from_executable(libexec"binregister-python-argcomplete", "az",
                                         base_name: "az", shell_parameter_format: :arg)
  end

  test do
    json_text = shell_output("#{bin}az cloud show --name AzureCloud")
    azure_cloud = JSON.parse(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["endpoints"]["management"], "https:management.core.windows.net"
    assert_equal azure_cloud["endpoints"]["resourceManager"], "https:management.azure.com"
  end
end