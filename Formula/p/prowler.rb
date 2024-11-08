class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Tool for cloud security assessments, audits, incident response, and more"
  homepage "https://prowler.com/"
  url "https://files.pythonhosted.org/packages/2e/c9/f1a642dc91fa80b1c4b5af8ec11c80612c0bcdcd873e8c777c60cbaffab7/prowler-4.5.1.tar.gz"
  sha256 "94f4870f2726e6ce417a734674658c58dc580534b4a913f02602dc1368f80e34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b320fab98660a8ceec6dafc89868c562dc740b6756f01bc9bd41688d6f61d1f3"
    sha256 cellar: :any,                 arm64_sonoma:  "e15a3348c4597602e67554063838e7b7249a48f6cf10960b829872c3e9b173d5"
    sha256 cellar: :any,                 arm64_ventura: "1783ce216a0ec98ac087506d5ebc951752509267c003531d7a588550deb152d7"
    sha256 cellar: :any,                 sonoma:        "5365f9b54dcf99c622d10a625274ed01904999c4338418b9f13df166054f8a6a"
    sha256 cellar: :any,                 ventura:       "5a9bb710eb588bac0e420a9ad2ce3b6641d83e241f1a76c1115c64d0508b2625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a671156381040e9085e411780c01e799c1f3dbf10febe835ad99d8c1c95ce682"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.12"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/bc/69/2f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40/aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/17/7e/16e57e6cf20eb62481a2f9ce8674328407187950ccc602ad07c685279141/aiohttp-3.10.10.tar.gz"
    sha256 "0631dd7c9f0822cc61c88586ca76d5b5ada26538097d0f1df510b082bad3411a"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/6a/cf/de25c4f6123c3b3eb5acc87144d3e017df25b32c16806b14572a259939ac/alive-progress-3.1.5.tar.gz"
    sha256 "42e399a66c8150dc507602dff7b7953f105ef11faf97ddaa6d27b1cbf45c4c98"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/9f/09/45b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546cc/anyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "awsipranges" do
    url "https://files.pythonhosted.org/packages/19/2e/6efa95f995369da828715f41705686cd214b9259ed758266942553d40441/awsipranges-0.3.3.tar.gz"
    sha256 "4f0b3f22a9dc1163c85b513bed812b6c92bdacd674e6a7b68252a3c25b99e2c0"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/cc/ee/668328306a9e963a5ad9f152cd98c7adad86c822729fd1d2a01613ad1e67/azure_core-1.32.0.tar.gz"
    sha256 "22b3c35d6b2dae14990f6c1be2912bf23ffe50b220e708a28ab1bb92b1c730e5"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/aa/91/cbaeff9eb0b838f0d35b4607ac1c6195c735c8eb17db235f8f60e622934c/azure_identity-1.19.0.tar.gz"
    sha256 "500144dc18197d7019b81501165d4fa92225f03778f17d7ca8a2a180129a9c83"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/12/ac/9a86f08659638ff2f07cb233a4f606bb765a72051a85c2622c0353eaa225/azure-keyvault-keys-4.9.0.tar.gz"
    sha256 "08632dcd6ece28657204e9a256ad64369fe2b0e385ed43349f932f007d89f774"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https://files.pythonhosted.org/packages/89/37/65811225c0611bedc784f8fd954eeb5a0e4cf58dc9f46860b33444391589/azure-mgmt-applicationinsights-4.0.0.zip"
    sha256 "50c3db05573e0cc2d56314a0556fb346ef05ec489ac000f4d720d92c6b647e06"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/90/f2/a2b1391e9df876d7ef9086f8d41ad4666eafef921ae0c47da931f8cedb1a/azure-mgmt-compute-33.0.0.tar.gz"
    sha256 "a3cc0fe4f09c8e1d3523c1bfb92620dfe263a0a893b0ac13a33d7057e9ddddd2"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/a9/df/97427d1bc1bb7307c7bfa73fdb8feb1ab6f74c3a2e67e8a9223abfa4b4dd/azure-mgmt-containerregistry-10.3.0.tar.gz"
    sha256 "ae21651855dfb19c42d91d6b3a965c6c611e23f8bc4bf7138835e652d2f918e3"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/3d/f7/7cfc9177784b259aa0b403f460d87d7f59c379cb73f654ec29842476bc3a/azure_mgmt_containerservice-32.0.0.tar.gz"
    sha256 "ccb587479d8a93ec78f7162590adc82e4fba4de76e4adc3419f33ad225efb292"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/48/9a/9bdc35295a16fe9139a1f99c13d9915563cbc4f30b479efaa40f8694eaf7/azure_mgmt_core-1.5.0.tar.gz"
    sha256 "380ae3dfa3639f4a5c246a7db7ed2d08374e88230fd0da3eb899f7c11e5c441a"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/86/f1/3be440072cc7f163ccd332e3793a4a0d18a74264fa94a5459135f67745b1/azure_mgmt_cosmosdb-9.6.0.tar.gz"
    sha256 "667c7d8a8f542b0e7972e63274af536ad985187e24a6cc2e3c8eef35560881fc"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/6f/c9/c9cd047729de3996656da854e361636dafa4f5e9b35af449abe23ec75582/azure-mgmt-keyvault-10.3.1.tar.gz"
    sha256 "34b92956aefbdd571cae5a03f7078e037d8087b2c00cfa6748835dc73abb5a30"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/e4/31/ebabafe0be1a177428880a8ec0fc44d681ac9dc1ae66a70d859cb5c7fbc3/azure-mgmt-monitor-6.0.2.tar.gz"
    sha256 "5ffbf500e499ab7912b1ba6d26cef26480d9ae411532019bb78d72562196e07b"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/bf/aa/bf464fd70eefa8f13f5e5b45d021416d5c9c8d79eabb96f4a673fe91346d/azure_mgmt_network-27.0.0.tar.gz"
    sha256 "5c1c61d8bb13ad40f788a26fd7569c1d9d60eb2e4cb19c2a1b5d9c02ae862316"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/51/3c/c1e03a11cf3dc2567ba947cc196d695d125d0d0e86af6731a7c067c5404a/azure-mgmt-rdbms-10.1.0.zip"
    sha256 "a87d401c876c84734cdd4888af551e4a1461b4b328d9816af60cb8ac5979f035"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/89/60/19471f7f2499888da9d5abc7ff8c470a6d620fbf35657fff31df9eeb483d/azure-mgmt-resource-23.1.1.tar.gz"
    sha256 "20b6b006b544fdb19607f3f6a381105625e0bb60fbf3036f39885c4646d3343e"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/3d/90/13186657355452bdce44f27db6b194b99f78f8c185301b47624fff6d9531/azure-mgmt-security-7.0.0.tar.gz"
    sha256 "5912eed7e9d3758fdca8d26e1dc26b41943dc4703208a1184266e2c252e1ad66"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/3f/af/398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310/azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/b9/9b/0542c8081fe6ff808b04986892861e88775c3900c391657f796d69643f13/azure-mgmt-storage-21.2.1.tar.gz"
    sha256 "503a7ff9c31254092b0656445f5728bfdfda2d09d46a82e97019eaa9a1ecec64"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/7f/a4/a47081049ae17378b920518db566587c5691ed52c15802a2b418912081ad/azure-mgmt-web-7.3.1.tar.gz"
    sha256 "87b771436bc99a7a8df59d0ad185b96879a06dce14764a06b3fc3dafa8fcb56b"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/66/b2/df9ac2ea294e558fa8b6cdade9a14a938b07529f5194303664152819277a/azure_storage_blob-12.23.1.tar.gz"
    sha256 "a587e54d4e39d2a27bd75109db164ffa2058fe194061e5446c5a89bca918272f"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1e/57/a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abcc/blinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "blis" do
    url "https://files.pythonhosted.org/packages/bd/e4/741f20c9b767330e2605d4c71a775303cb6a9c72764b8802232fe6c7afad/blis-1.0.1.tar.gz"
    sha256 "91739cd850ca8100dcddbd8ad66942cab20c9473cdea9a35b165b11d7b8d91e4"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/25/d8/f7bc41e01e83eaad1ec297cfb675c1f98cc59450b1f4a76b93a1e31a2b09/boto3-1.35.29.tar.gz"
    sha256 "7bbb1ee649e09e956952285782cfdebd7e81fc78384f48dfab3d66c6eaf3f63f"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/41/23/482871ed269fa0c832f98c840686b4ef18662b3fb800eab48a48817d286c/botocore-1.35.29.tar.gz"
    sha256 "4ed28ab03675bb008a290c452c5ddd7aaa5d4e3fa1912aadbdf93057ee84362b"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "catalogue" do
    url "https://files.pythonhosted.org/packages/38/b4/244d58127e1cdf04cf2dc7d9566f0d24ef01d5ce21811bab088ecc62b5ea/catalogue-2.0.10.tar.gz"
    sha256 "4f56daa940913d3f09d589c191c74e5a6d51762b3a9e37dd53b7437afd6cda15"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "cloudpathlib" do
    url "https://files.pythonhosted.org/packages/71/0b/a47d78ed2816db100543b504fdbfc2070f422aac858e6bcf775713e37b8a/cloudpathlib-0.20.0.tar.gz"
    sha256 "f6ef7ca409a510f7ba4639ba50ab3fc5b6dee82d6dff0d7f5715fd0c9ab35891"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "confection" do
    url "https://files.pythonhosted.org/packages/51/d3/57c6631159a1b48d273b40865c315cf51f89df7a9d1101094ef12e3a37c2/confection-0.1.5.tar.gz"
    sha256 "8e72dd3ca6bd4f48913cd220f10b8275978e740411654b6e8ca6d7008c590f0e"
  end

  resource "cymem" do
    url "https://files.pythonhosted.org/packages/36/32/f4a457fc6c160a9e72b15dab1ca14ca5c8869074638bca8bfc26120c04e9/cymem-2.0.8.tar.gz"
    sha256 "8fb09d222e21dcf1c7e907dc85cf74501d4cea6c4ed4ac6c9e016f98fb59cbbf"
  end

  resource "dash" do
    url "https://files.pythonhosted.org/packages/79/95/1a276cad4271a1068fc6193553b2e0f44f29115ee4148cc4d189fd640817/dash-2.18.1.tar.gz"
    sha256 "ffdf89690d734f6851ef1cb344222826ffb11ad2214ab9172668bf8aadd75d12"
  end

  resource "dash-bootstrap-components" do
    url "https://files.pythonhosted.org/packages/a6/1e/59da44351adaaa2a747eb00993c498cadbe0f642b44ced7e7aabf368eaf6/dash_bootstrap_components-1.6.0.tar.gz"
    sha256 "960a1ec9397574792f49a8241024fa3cecde0f5930c971a3fc81f016cbeb1095"
  end

  resource "dash-core-components" do
    url "https://files.pythonhosted.org/packages/41/55/ad4a2cf9b7d4134779bd8d3a7e5b5f8cc757f421809e07c3e73bb374fdd7/dash_core_components-2.0.0.tar.gz"
    sha256 "c6733874af975e552f95a1398a16c2ee7df14ce43fa60bb3718a3c6e0b63ffee"
  end

  resource "dash-html-components" do
    url "https://files.pythonhosted.org/packages/14/c6/957d5e83b620473eb3c8557a253fb01c6a817b10ca43d3ff9d31796f32a6/dash_html_components-2.0.0.tar.gz"
    sha256 "8703a601080f02619a6390998e0b3da4a5daabe97a1fd7a9cebc09d015f26e50"
  end

  resource "dash-table" do
    url "https://files.pythonhosted.org/packages/3a/81/34983fa0c67125d7fff9d55e5d1a065127bde7ca49ca32d04dedd55f9f35/dash_table-5.0.0.tar.gz"
    sha256 "18624d693d4c8ef2ddec99a6f167593437a7ea0bf153aa20f318c170c5bc7308"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
    sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/31/e9/f49c4e7fccb77fa5c43c2480e09a857a78b41e7331a75e128ed5df45c56b/durationpy-0.9.tar.gz"
    sha256 "fd3feb0a69a0057d582ef643c355c40d2fa1c942191f914d12203b1a01ac722a"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/48/ce/13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1/email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8f/ed/0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3/frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/00/c2/425f97c2087affbd452a05d3faa08d97de333f2ca554733e1becab55ee4e/google_api_core-2.22.0.tar.gz"
    sha256 "26f8d76b96477db42b55fd02a33aae4a42ec8b86b98b94969b7333a2c828bf35"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/35/a4/73b9d642fa82f6fad67b0449c109a06c8e19b5980204b24fa86b86e8da06/google_api_python_client-2.147.0.tar.gz"
    sha256 "e864c2cf61d34c00f05278b8bdb72b93b6fa34f0de9ead51d20435f3b65f91be"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/6a/71/4c5387d8a3e46e3526a8190ae396659484377a73b33030614dd3b28e7ded/google_auth-2.36.0.tar.gz"
    sha256 "545e9618f2df0bcbb7dcbc45a546485b1212624716975a1ea5ae8149ce769ab1"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/53/3b/1599ceafa875ffb951480c8c74f4b77646a6b80e80970698f2aa93c216ce/googleapis_common_protos-1.65.0.tar.gz"
    sha256 "334a29d07cddc3aa01dee4988f9afd9b2916ee2ff49d6b757155dc0d197852c0"
  end

  resource "grapheme" do
    url "https://files.pythonhosted.org/packages/ce/e7/bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bf/grapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/b6/44/ed0fa6a17845fb033bd885c03e842f08c1b9406c86a2e60ac1ae1b9206a6/httpcore-1.0.6.tar.gz"
    sha256 "73f6dbd6eb8c21bbf7ef8efad555481853f5f6acdeaff1edb0694289269ee17f"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cd/12/33e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1b/importlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/7e/bd/ffcd3104155b467347cd9b3a64eb24182e459579845196b3a200569c8912/kubernetes-31.0.0.tar.gz"
    sha256 "28945de906c8c259c1ebe62703b56a03b714049372196f854105afe4e6d014c0"
  end

  resource "langcodes" do
    url "https://files.pythonhosted.org/packages/f4/79/adb488d97c8bad22fe69a1966c3fb47eb38b22598324d8ffbc5e88bc475d/langcodes-3.4.1.tar.gz"
    sha256 "a24879fed238013ac3af2424b9d1124e38b4a38b2044fd297c8ff38e5912e718"
  end

  resource "language-data" do
    url "https://files.pythonhosted.org/packages/ad/53/d3657025d32bfacc832769ab3c925f8f4ad2165cd2c8467c2446b21400d1/language_data-1.2.0.tar.gz"
    sha256 "82a86050bbd677bfde87d97885b17566cfe75dad3ac4f5ce44b52c28f752e773"
  end

  resource "marisa-trie" do
    url "https://files.pythonhosted.org/packages/31/15/9d9743897e4450b2de199ee673b50cb018980c4ced477d41cf91304a85e3/marisa_trie-1.2.1.tar.gz"
    sha256 "3a27c408e2aefc03e0f1d25b2ff2afb85aac3568f6fa2ae2a53b57a2e87ce29d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/25/c6/688231a1c88644fc619afcbed3a7f1f2afb40b7bf751e0115f8200c1aee8/microsoft_kiota_abstractions-1.3.3.tar.gz"
    sha256 "3cc01832a2e6dc6094c4e1abf7cbef3849a87d818a3b9193ad6c83a9f88e14ff"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/7f/4a/b20343e0c7b44f916b52546ea115b78fb328f2132d7ba54a75ac46249f33/microsoft_kiota_authentication_azure-1.1.0.tar.gz"
    sha256 "8940084a3c1c25d1cde1d3b193ef7164dc6323e3b8200e2f695cbc937797bac6"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/04/5c/913462eb2700a497226a3423bd0f3acc3162b1de5c3221787d6be20fa071/microsoft_kiota_http-1.3.4.tar.gz"
    sha256 "0ba94a5e982575f5a349b71a87aae2e01ff1722cfc0902247b7ef0a9072c1580"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/aa/bb/bc9e51e4d8718bd4af89461037e39f4f2f63aa9bb13b1274fe4b4c4cb70d/microsoft_kiota_serialization_form-0.1.1.tar.gz"
    sha256 "f72dd50081250d1e49111682eccf620d3c2e335195d50c096b35ec5a5ef59a54"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/70/ec/591534177f85033336be05f6078beb3e41a55e7ab3c4b5138c0539fc0951/microsoft_kiota_serialization_json-1.3.3.tar.gz"
    sha256 "348fd75ec6f9993b79172018cb986ecbaf73255d7930b89ad68e648b22b579aa"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/28/f7/5dd2a93c4d48b3cb2f058466221b06e1465b85dea36f5cac7aace19be054/microsoft_kiota_serialization_multipart-0.1.0.tar.gz"
    sha256 "14e89e92582e6630ddbc70ac67b70bf189dacbfc41a96d3e1d10339e86c8dde5"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/a1/c9/f9c91025559d4c63237b9f232ecd106e0d8ec9a6c8953e5a7a3c4763d808/microsoft_kiota_serialization_text-1.0.0.tar.gz"
    sha256 "c3dd3f409b1c4f4963bd1e41d51b65f7e53e852130bb441d79b77dad88ee76ed"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/59/04/8d7aa5c671a26ca5612257fd419f97380ba89cdd231b2eb67df58483796d/msal-1.31.0.tar.gz"
    sha256 "2c4f189cf9cc8f00c80045f66d39b7c0f3ed45873fd3d1f2af9f22db2e12ff4b"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/2d/38/ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5eb/msal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/ae/de/99d81ad15fa76b5944c7cdc547d1348e64318469bec76ca297df7542f29b/msgraph_core-1.1.6.tar.gz"
    sha256 "1ab3d2db405a71e85c969ef6e186d4517c4044489e2205648d353c29b98bbaa5"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/d8/aa/afbe3152f222cdbdcd10247c0fb1e37906a7ccf45b34888350a7631b93df/msgraph_sdk-1.8.0.tar.gz"
    sha256 "1ac84bd47ea288a84f46f6c6d0c89d164ee3453b917615632652344538098314"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "murmurhash" do
    url "https://files.pythonhosted.org/packages/6e/07/56f98a57698e6abf80e58d6c93a0422fd3f443f5b4dad06e83e8a3729ab1/murmurhash-1.0.10.tar.gz"
    sha256 "5282aab1317804c6ebd6dd7f69f15ba9075aee671c44a34be2bde0f1b11ef88a"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/79/36/260eaea0f74fdd0c0d8f22ed3a3031109ea1c85531f94f4fde266c29e29a/opentelemetry_api-1.28.0.tar.gz"
    sha256 "578610bcb8aa5cdcb11169d136cc752958548fb6ccffb0969c1036b0ee9e5353"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/0c/5b/a509ccab93eacc6044591d5ec437d8266e76f893d0389bbf7e5592c7da32/opentelemetry_sdk-1.28.0.tar.gz"
    sha256 "41d5420b2e3fb7716ff4981b510d551eff1fc60eb5a95cf7335b31166812a893"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/ee/c8/433b0e54143f8c9369f5c4a7a83e73eec7eb2ee7d0b7e81a9243e78c8e80/opentelemetry_semantic_conventions-0.49b0.tar.gz"
    sha256 "dbc7b28339e5390b6b28e022835f9bac4e134a80ebf640848306d3c5192557e8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/9c/d6/9f8431bacc2e19dca897724cd097b1bb224a6ad5433784a44b587c7c13af/pandas-2.2.3.tar.gz"
    sha256 "4f18ba62b61d7e192368b84517265a99b4d7ee8912f8708660fb4a366cc82667"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/b8/fe/27c7438c6ac8b8f8bef3c6e571855602ee784b85d072efddfff0ceb1cd77/pendulum-3.0.0.tar.gz"
    sha256 "5d034998dea404ec31fae27af6b22cff1708f830a1ed7353be4d1019bb9f584e"
  end

  resource "phonenumbers" do
    url "https://files.pythonhosted.org/packages/46/ba/3ffde4423a23198fe983fc44eca5738e4fa7367cd469de5346d055613157/phonenumbers-8.13.49.tar.gz"
    sha256 "e608ccb61f0bd42e6db1d2c421f7c22186b88f494870bf40aa31d1a2718ab0ae"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/79/4f/428f6d959818d7425a94c190a6b26fbc58035cbef40bf249be0b62a9aedd/plotly-5.24.1.tar.gz"
    sha256 "dbc8ac8339d248a4bcc36e08a5659bacfe1b079390b8953533f4eb22169b4bae"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "preshed" do
    url "https://files.pythonhosted.org/packages/f2/4e/76dbf784e7d4ed069f91a4c249b1d6ec6856ef0c0b2fd96992895d458b15/preshed-3.0.9.tar.gz"
    sha256 "721863c5244ffcd2651ad0928951a2c7c77b102f4e11a251ad85d37ee7621660"
  end

  resource "presidio-analyzer" do
    url "https://files.pythonhosted.org/packages/e0/ae/8cb849e6503ed5f6d5f28ab296417079063d3c93a62d85c7b28ccc106b8d/presidio_analyzer-2.2.355-py3-none-any.whl"
    sha256 "c4c5bc6d82e4f94059fd554c31365fc5d29afe51763391b6ecc33b628bdb5858"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a9/4d/5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cd/propcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/7e/05/74417b2061e1bf1b82776037cad97094228fa1c1b6e82d08a78d3fb6ddb6/proto_plus-1.25.0.tar.gz"
    sha256 "fbb17f57f7bd05a68b7707e745e26528b0b3c34e378db91eef93912c54982d91"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/74/6e/e69eb906fddcb38f8530a12f4b410699972ab7ced4e21524ece9d546ac27/protobuf-5.28.3.tar.gz"
    sha256 "64badbc49180a5e401f373f9ce7ab1d18b63f7dd4a9cdc43c92b9f0b481cef7b"
  end

  resource "py-ocsf-models" do
    url "https://files.pythonhosted.org/packages/46/47/e085aaec6e960e20ad0fc4f615af5476dc1d4da230d5e96d092871aea14a/py_ocsf_models-0.2.0.tar.gz"
    sha256 "3e12648d05329e6776a0e6b1ffea87a3eb60aa7d8cb2c4afd69e5724f443ce03"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/20/e6/89d6ba0c0a981fd7e3129d105502c4cf73fad1611b294c87b103f75b5837/pydantic-1.10.18.tar.gz"
    sha256 "baebdff1907d1d96a139c25136a9bb7d17e118f133a76a2ef3b845e831e3403a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/fb/68/ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020e/pyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/ce/70/15ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9dd/retrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/23/80/afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4f/rpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/d4/01/0ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecd/schema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ed/22/a438e0caa4576f8c383fa4d35f1cc01655a46c75be358960d815bfbb12bd/setuptools-75.3.0.tar.gz"
    sha256 "fba5dd4d766e97be1b1681d98712680ae8f2f26d7881245f2ce9e40714f1a686"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c5/06/c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28/shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/3b/42/344970abb81f9b6658431dadf44587fe1a58c7fd594dd7cdf8c9fe34044a/slack_sdk-3.33.1.tar.gz"
    sha256 "e328bb661d95db5f66b993b1d64288ac7c72201a745b4c7cf8848dafb7b74e40"
  end

  resource "smart-open" do
    url "https://files.pythonhosted.org/packages/a3/d8/1481294b2d110b805c0f5d23ef34158b7d5d4283633c0d34c69ea89bb76b/smart_open-7.0.5.tar.gz"
    sha256 "d3672003b1dbc85e2013e4983b88eb9a5ccfd389b0d4e5015f39a9ee5620ec18"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "spacy" do
    url "https://files.pythonhosted.org/packages/07/53/536941af8fbb5cb10a778f0dbd2a17b0f13e7ebfc11e67b154be60508fdf/spacy-3.8.2.tar.gz"
    sha256 "4b37ebd25ada4059b0dc9e0893e70dde5df83485329a068ef04580e70892a65d"
  end

  resource "spacy-legacy" do
    url "https://files.pythonhosted.org/packages/d9/79/91f9d7cc8db5642acad830dcc4b49ba65a7790152832c4eceb305e46d681/spacy-legacy-3.0.12.tar.gz"
    sha256 "b37d6e0c9b6e1d7ca1cf5bc7152ab64a4c4671f59c85adaf7a3fcb870357a774"
  end

  resource "spacy-loggers" do
    url "https://files.pythonhosted.org/packages/67/3d/926db774c9c98acf66cb4ed7faf6c377746f3e00b84b700d0868b95d0712/spacy-loggers-1.0.5.tar.gz"
    sha256 "d60b0bdbf915a60e516cc2e653baeff946f0cfc461b452d11a4d5458c6fe5f24"
  end

  resource "srsly" do
    url "https://files.pythonhosted.org/packages/59/7f/17259e0962bb9433f39aa99ec45fd36851961491c562bc2f8c731cc476a6/srsly-2.4.8.tar.gz"
    sha256 "b24d95a65009c2447e0b49cda043ac53fecf4f09e358d87a57446458f91b8a91"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/55/cc/4edf18ba0154c338c6054b2d57e954ef8eda90cdd8d435aaf3dcd7cb9a6a/std_uritemplate-2.0.0.tar.gz"
    sha256 "be88c8a4a89fee6768237f594c537d9347d96d7e68b8ad12200a3f11a0f6398f"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/cd/94/91fccdb4b8110642462e653d5dcb27e7b674742ad68efd146367da7bdb10/tenacity-9.0.0.tar.gz"
    sha256 "807f37ca97d62aa361264d497b0e31e92b8027044942bfa756160d908320d73b"
  end

  resource "thinc" do
    url "https://files.pythonhosted.org/packages/8a/9f/b2193b69dd112a46800182e897cda2fc9c497dfdd9352a0c5ba9252cf5f0/thinc-8.3.2.tar.gz"
    sha256 "3e8ef69eac89a601e11d47fc9e43d26ffe7ef682dcf667c94ff35ff690549aeb"
  end

  resource "time-machine" do
    url "https://files.pythonhosted.org/packages/fb/dd/5022939b9cadefe3af04f4012186c29b8afbe858b1ec2cfa38baeec94dab/time_machine-2.16.0.tar.gz"
    sha256 "4a99acc273d2f98add23a89b94d4dd9e14969c01214c8514bfa78e4e9364c7e2"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/4a/4f/eee4bebcbad25a798bf55601d3a4aee52003bebcf9e55fce08b91ca541a9/tldextract-5.1.3.tar.gz"
    sha256 "d43c7284c23f5dc8a42fd0fee2abede2ff74cc622674e4cb07f514ab3330c338"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e8/4f/0153c21dc5779a49a0598c445b1978126b1344bab9ee71e53e44877e14e0/tqdm-4.67.0.tar.gz"
    sha256 "fe5a6f95e6fe0b9755e9469b77b9c3cf850048224ecaa8293d7d2d31f97d869a"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e7/87/9eb07fdfa14e22ec7658b5b1147836d22df3848a22c85a4e18ed272303a5/typer-0.13.0.tar.gz"
    sha256 "f1c7198347939361eec90139ffa0fd8b3df3a2259d5852a0f7400e476d95985c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/e1/34/943888654477a574a86a98e9896bae89c7aa15078ec29f490fef2f1e5384/tzdata-2024.2.tar.gz"
    sha256 "7d85cc416e9382e69095b7bdf4afd9e3880418a2413feec7069d533d6b4e31cc"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wasabi" do
    url "https://files.pythonhosted.org/packages/ac/f9/054e6e2f1071e963b5e746b48d1e3727470b2a490834d18ad92364929db3/wasabi-1.1.3.tar.gz"
    sha256 "4bb3008f003809db0c3e28b4daf20906ea871a2bb43f9914197d540f4f2e0878"
  end

  resource "weasel" do
    url "https://files.pythonhosted.org/packages/a7/1a/9c522dd61b52939c217925d3e55c95f9348b73a66a956f52608e1e59a2c0/weasel-0.4.1.tar.gz"
    sha256 "aabc210f072e13f6744e5c3a28037f93702433405cd35673f7c6279147085aa9"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/d4/f9/0ba83eaa0df9b9e9d1efeb2ea351d0677c37d41ee5d0f91e98423c7281c9/werkzeug-3.0.6.tar.gz"
    sha256 "a8dd59d4de28ca70471a34cba79bed5f7ef2e036a76b3ab0835474246eb41f8d"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/a6/c3/b36fa44a0610a0f65d2e65ba6a262cbe2554b819f1449731971f7c16ea3c/XlsxWriter-3.2.0.tar.gz"
    sha256 "9977d0c661a72866a61f9f7a809e25ebbb0fb7036baa3b9fe74afcfca6b3cb8c"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/54/9c/9c0a9bfa683fc1be7fdcd9687635151544d992cccd48892dc5e0a5885a29/yarl-1.17.1.tar.gz"
    sha256 "067a63fcfda82da6b198fa73079b1ca40b7c9b7994995b6ee38acda728b64d47"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/54/bf/5c0000c44ebc80123ecbdddba1f5dcd94a5ada602a9c225d84b5aaa55e86/zipp-3.20.2.tar.gz"
    sha256 "bc9eb26f4506fda01b81bcde0ca78103b6e62f991b381fec825435c836edbc29"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"

    # Multiple resources require `setuptools`, so it must be installed first
    skipped = %w[plotly setuptools]
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("setuptools")
    venv.pip_install resources.reject { |r| skipped.include? r.name }
    venv.pip_install resource("plotly"), build_isolation: false
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "Unable to locate credentials", shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)
    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end