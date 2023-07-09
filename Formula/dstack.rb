class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://docs.dstack.ai/"
  url "https://files.pythonhosted.org/packages/46/ff/da849fa5f92e53116d78b314233096bb9ddeba10f3a9493281616fb16b93/dstack-0.10.4.tar.gz"
  sha256 "92427db778ad09c8093e7c2326743d570b723afb0491c863e48b3e31ebfd9041"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3845460ab8b55ba76af7a2bf6f6f37199b15366146b70cf84f12a4982a36a700"
    sha256 cellar: :any,                 arm64_monterey: "a2c5b73210132bd89288cfb83e9bdd09836574ad2596baa2b2ef5b8eacb78a7a"
    sha256 cellar: :any,                 arm64_big_sur:  "f4c270f44040275dbb0faee084ee5a06e9ebecb2a40ff6f06c2663473b419d27"
    sha256 cellar: :any,                 ventura:        "475198e4336cddec2cd3ba6a04b700b7faed5de2bf2c609ede2565108cb9559e"
    sha256 cellar: :any,                 monterey:       "d095a10c010b9c02773d0ac2cdee200568e510bc2d05cee36ddca05ce2987121"
    sha256 cellar: :any,                 big_sur:        "d9520066275551c3a7435b7f325d4b7fbb0d84d9643efc25dbbc0d2710128667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a40cf4f78c198f40812d895c2bb2be5fd638d426c2f4387607c87a1b3f92db8e"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "greenlet" do
    on_intel do
      url "https://files.pythonhosted.org/packages/1e/1e/632e55a04d732c8184201238d911207682b119c35cecbb9a573a6c566731/greenlet-2.0.2.tar.gz"
      sha256 "e7c8dc13af7db097bed64a051d2dd49e9f0af495c26995c00a9ee842690d34c0"
    end
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/ea/51/060efa10a814145acd4e42c6e5ed540b8714cad52ca026c5930e7c473049/aiosqlite-0.19.0.tar.gz"
    sha256 "95ee77b91c8d2808bd08a59fbebf66270e9090c3d92ffbf260dc0db0b979577d"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/c6/e3/3d9b95470606b93bd6e6d5c899ed9d0049dfa10246ecca25b18c2c708cdf/alembic-1.11.1.tar.gz"
    sha256 "6a810a6b012c88b33458fceb869aef09ac75d6ace5291915ba7fae44de372c01"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/28/99/2dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfce/anyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/ea/ed/f1ad88e88208c24db80dcaae7a5a339bb283956984f8fa59933d2806413a/APScheduler-3.10.1.tar.gz"
    sha256 "0293937d8f6051a0f493359440c1a1b93e882c57daf0197afeff0e727777b96e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/31/5c/9da79ae1d12571a0e268f0b813d9d19e9419339f7fbe2232b556937b4358/azure-core-1.27.1.zip"
    sha256 "5975c20808fa388243f01a8b79021bfbe114f503a27c543f002c5fc8bbdd73dd"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/52/31/87dd867c239b5b2c5bccade8a0fd81c28b9b380ece3db47b58ae05270842/azure-graphrbac-0.61.1.zip"
    sha256 "53e98ae2ca7c19b349e9e9bb1b6a824aeae8dcfcbe17190d20fe69c0f185b2e2"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/ad/3e/34b445ef2f536f4710903cbc3ca33c4272ad37f676609188c4544dc8463a/azure-identity-1.13.0.zip"
    sha256 "c931c27301ffa86b07b4dcf574e29da73e3deba9ab5d1fe4f445bb6a3117e260"
  end

  resource "azure-keyvault-secrets" do
    url "https://files.pythonhosted.org/packages/5c/a1/78ecabf98e97d600dcac1559ff64b4bc9f84eca126c0aeba859916832b0c/azure-keyvault-secrets-4.7.0.zip"
    sha256 "77ee2534ba651a1f306c85d7b505bc3ccee8fea77450ebafafc26aec16e5445d"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/7b/39/46adcbabc61a6d91f8514b46a2b64cfba365170325a6c38c31e2c1567090/azure-mgmt-authorization-3.0.0.zip"
    sha256 "0a5d7f683bf3372236b841cdbd4677f6b08ed7ce41b999c3e644d4286252057d"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/d8/3f/651b3ddfe3849bbdc247ea4a75a506137d1ecdfb460b70dfff81c42e5bb0/azure-mgmt-compute-30.0.0.zip"
    sha256 "7320fbafc392770b03ed02b68760185e6094552ed98d7fd5ea77210a5a513c78"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/14/95/2b2085e40f4b9de88ad256428a669583066d8ab348fc19110c7d04c3189b/azure-mgmt-core-1.4.0.zip"
    sha256 "d195208340094f98e5a6661b781cde6f6a051e79ce317caabd8ff97030a9b3ae"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/e6/e6/7fe0f188a1a574941f19820170350b321bb7fdc3f1abec232f517aadb090/azure-mgmt-keyvault-10.2.2.zip"
    sha256 "2c6ea831365ea604fceca749af00a973865811c954b04007522b59af114290be"
  end

  resource "azure-mgmt-loganalytics" do
    url "https://files.pythonhosted.org/packages/04/dc/48a624066655108e7f8490f643920c4ccec0798780a4e204e4ea93368039/azure-mgmt-loganalytics-13.0.0b6.zip"
    sha256 "f4aceb37f3ea14bffd1c5dcade31dc1f1de058621e183d9362d0966ad9c287c8"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/f0/6a/3148045479b8d3c6d489d74df244c19ccd0657fa8fb84889b0cf760d7f97/azure-mgmt-monitor-6.0.1.zip"
    sha256 "8fe2eb9cbb1fbd1365a252987fbd99517c60e656f7dd1ecf7f1bde052cb11c32"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/77/d7/4ef788fb8e0f90a3fe5875b05dcef535ad4b4a766372af82870120cd5dd3/azure-mgmt-msi-7.0.0.zip"
    sha256 "72d46c9a62783ec4eab619be9d1b78ffebbdaa164d406fd303f16303f37256b2"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/6b/f2/837f864ca73329becc9ab54b51469ab3bf16f6ec1c0792aecf665a9fdc93/azure-mgmt-network-23.0.0b2.zip"
    sha256 "0ce5802cee30943ea3f106cd6fcbe32ffa5dfb435ab9e7b72f4ac3cab6b74644"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/81/65/128984a9bdca0542a6fabd748e4b84398de625193379ac7fc3a0805465cd/azure-mgmt-resource-23.0.1.zip"
    sha256 "c2ba6cfd99df95f55f36eadc4245e3dc713257302a1fd0277756d94bd8cb28e0"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/83/9d/f486f601c9902bce42ea77adfa6f81895535adfb3eadc1f8522b1abbd44b/azure-mgmt-storage-21.0.0.zip"
    sha256 "6eb13eeecf89195b2b5f47be0679e3f27888efd7bd2132eec7ebcbce75cb1377"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-monitor-query" do
    url "https://files.pythonhosted.org/packages/ad/16/fd06cccfc583d8d38d8d99ee92ec1bbc9604cf6e8c62e64ddca5644e0a60/azure-monitor-query-1.2.0.zip"
    sha256 "2c57432443f203069e64e500c7e958ca31650f641950515ffe65555ba134c371"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/fb/b1/5f043703c58cb67f113dded485ef3d7610e215b3921c65e52030791b7c76/azure-storage-blob-12.16.0.zip"
    sha256 "43b45f19a518a5c6895632f263b3825ebc23574f25cc84b66e1630a6160e466f"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/fc/26/81d4ff9eb8fd067be37e4044f8f4ddd6f62abf0cd2479605e7d97fa31e36/boto3-1.28.0.tar.gz"
    sha256 "8d43863e4769a5652efc32fd63430df58488cdb3fb85e614461b511358e47ec7"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/02/06efcac837cb1a2dd10763ea26e77ef715c5dd28764ebf0dcdb4b171b303/botocore-1.31.0.tar.gz"
    sha256 "db22eea779de7f61621a612c6a36f3ee069a37d4572a9541aa374503447622aa"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/77/88/b0cc5fe95c31c301e9823ea9b028f669c0dcfa205ff71111037a5ed4892c/click-8.1.4.tar.gz"
    sha256 "b97d0c74955da062a7d4ef92fadb583806a585b2ea81958a81bd72726cbb8e37"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/65/e0/f9d77b3a1569e2217abf260b0b1462401736973d1c5d3d335f6f2009daa2/fastapi-0.100.0.tar.gz"
    sha256 "acb5f941ea8215663283c10018323ba7ea737c571b67fc7e88e9469c7eb1d12e"
  end

  resource "file-read-backwards" do
    url "https://files.pythonhosted.org/packages/e2/0f/04d8a9877d80c26506cad53e3ff7024747e9429a5a06479c68f060948d1a/file_read_backwards-3.0.0.tar.gz"
    sha256 "512c3e534043527a8fae2a0b7151aa255f2da303e77fd40f7dcf42a1e091cc26"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "git-url-parse" do
    url "https://files.pythonhosted.org/packages/26/ea/c8c22b051026d9debe95c92df4fa0388f30fcde6f10fc0000058d13f6996/git-url-parse-1.2.2.tar.gz"
    sha256 "7b5f4e3aeb1d693afeee67a3bd4ac063f7206c2e8e46e559f0da0da98445f117"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/f3/b8/f727ada5b63aba53848e3791dd57be7481d5c9bf86978600ca9cca4ab03e/google-api-core-2.11.1.tar.gz"
    sha256 "25d29e05a0058ed5f19c61c0a78b1b53adea4d9364b464d014fbda941f6d1c9a"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/38/12/9fd32d6a04818e1d3d6ad5c8c2db8e7ad0087d6a251a5a9e78920b3f7079/google-api-python-client-2.92.0.tar.gz"
    sha256 "f38a6e106a7417719715506d36f0a233ec253335e422bda311352866a86c4187"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/e6/76/2217d47be6a03dfd5f6bfe7432f87a5aa5ab6d85525a4dc546df9895f053/google-auth-2.21.0.tar.gz"
    sha256 "b28e8048e57727e7cf0e5bd8e7276b212aef476654a09511354aa82753b45c66"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/b8/e8/1132c9a96012b2959d8c645cd69843ff62a1b8eefda9830b6267ff9129d1/google-cloud-appengine-logging-1.3.1.tar.gz"
    sha256 "b3f5f797d6bacc60654de21901902f8a7878f7168d76be5d47c7775fe0c3e0a8"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/b1/3d/48e8b2c0cc7113d1674526b609944ef77d7182f233b23c50fec7106b2e2c/google-cloud-audit-log-0.2.5.tar.gz"
    sha256 "86e2faba3383adc8fd04a5bd7fd4f960b3e4aedaa7ed950f2f891ce16902eb6b"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/e0/b3/97b5bda9589b5fba41f748a43b76cb061e52f2b7345ab4b6b8af78c446b7/google-cloud-compute-1.12.1.tar.gz"
    sha256 "e8ff230c0498a05b8dec9e81543e745b0da3676d6ca3259437a429c8d2acaa25"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/6b/60/dcc26e42d3754ac57c51a524f53c988f2aa755faec4cc00a232bb0077637/google-cloud-core-2.3.3.tar.gz"
    sha256 "37b80273c8d7eee1ae816b3a20ae43585ea50506cb0e60f3cf5be5f87f1373cb"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/2f/87/633774179bc73e52b172c209c89b493804b0ad8e4c6e71b547603d35a883/google-cloud-logging-3.5.0.tar.gz"
    sha256 "f11544a21ea3556f70ebac7bc338ffa8a197913834ecdd8853d176b870823aaa"
  end

  resource "google-cloud-secret-manager" do
    url "https://files.pythonhosted.org/packages/25/13/7e481680b20cfc722da1c1d85a630cbb174642df2ec9be48cce336533e77/google-cloud-secret-manager-2.16.2.tar.gz"
    sha256 "596521091c39b94a260d814776421c8a009f6463b392880041efa80283b5fd29"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/6b/20/51e9676cc112ec7344c0a8690361175dc1f41ed6edf618eae8af87d92a49/google-cloud-storage-2.10.0.tar.gz"
    sha256 "934b31ead5f3994e5360f9ff5750982c5b6b11604dc072bc452c25965e076dc7"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/d3/a5/4bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352/google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/c0/1b/173eacfeb03e6d026c932cb810ace18987dc9ca219154c89d7746b348b9c/google-resumable-media-2.5.0.tar.gz"
    sha256 "218931e8e2b2a73a58eb354a288e03a0fd5fb1c4583261ac6e4c078666468c93"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/28/9b/ea531afe585da044686ab13351c99dfbb2ca02b96c396874946d52d0e127/googleapis-common-protos-1.59.1.tar.gz"
    sha256 "b35d530fe825fb4227857bc47ad84c33c809ac96f312e13182bdeaa2abe1178a"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/1e/1e/632e55a04d732c8184201238d911207682b119c35cecbb9a573a6c566731/greenlet-2.0.2.tar.gz"
    sha256 "e7c8dc13af7db097bed64a051d2dd49e9f0af495c26995c00a9ee842690d34c0"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/40/92/aee864f03f47c672a31d128e49981b01ca629d81541dcc9904c652dbab5b/grpc-google-iam-v1-0.12.6.tar.gz"
    sha256 "2bc4b8fdf22115a65d751c9317329322602c39b7c86a289c9b72d228d960ef5f"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/ee/d6/62ea04e71abe92406baf8fbe25daee5e90d45571206b8e93c4812ea958b6/grpcio-1.56.0.tar.gz"
    sha256 "4c08ee21b3d10315b8dc26f6c13917b20ed574cdbed2d2d80c53d5508fdcc0f2"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/e3/48/f5e1c0c55ebc847400d967db909ed9274a8eaf0c49036b96bb3ad07f2dc3/grpcio-status-1.56.0.tar.gz"
    sha256 "9eca0b2dcda0782d3702df225918efd6d820f75f93cd5c51c7fb6a4ffbfea12c"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/79/01/ce65847f79de9594d436b7ef295e374dfcc0ff3ee884bf61cf896f970ddb/jsonschema-4.18.0.tar.gz"
    sha256 "8caf5b57a990a98e9b39832ef3cb35c176fe331414252b6e1b26fd5866f891a4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/9a/8c/3d028449ac15cba52db3e1c95ca53b9240b4707fbe17f43e01cc73dd9336/jsonschema_specifications-2023.6.1.tar.gz"
    sha256 "ca1c4dd059a9e7b34101cf5b3ab7ff1d18b139f35950d598d629837ef66e8f28"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/10/b1/a648bdd3116d0028685987fb4120a37bb91d268509e09dfbafd6ae8bed87/msal-1.22.0.tar.gz"
    sha256 "8a82f5375642c1625c89058018430294c109440dce42ea667d466c2cab520acd"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/48/fc/5c2940301a83f18884a8e3aead2b2ff177a1a373f75c7b17e2e404199b2a/msrestazure-0.6.4.tar.gz"
    sha256 "a06f0dabc9a6f5efe3b6add4bd8fb623aeadacf816b7a35b0f89107e0544d189"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/87/62/cee9551811c846e9735f749dbdf05d4f9f0dbcecd66eae35b5daacf9a117/paramiko-3.2.0.tar.gz"
    sha256 "93cdce625a8a1dc12204439d45033f3261bdb2c201648cfcdc06f9fd0f94ec29"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/1f/f8/969e6f280201b40b31bcb62843c619f343dcc351dff83a5891530c9dd60e/portalocker-2.7.0.tar.gz"
    sha256 "032e81d534a88ec1736d03f780ba073f047a06c478b06e2937486f334e955c51"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/41/bd/4022c9a6de35821f215fdefc8b4e68bf9a054d04f43246f0c89ba8a7538e/proto-plus-1.22.3.tar.gz"
    sha256 "fdcd09713cbd42480740d2fe29c990f7fbd885a67efc328aa8be6ee3e9f76a6b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/37/a8/d832f7293ebb21690860d2e01d8115e5ff6f2ae8bbdc953f0eb0fa4bd2c7/py-cpuinfo-9.0.0.tar.gz"
    sha256 "3cdbbf3fac90dc6f118bfd64384f309edeadd902d7c8fb17f02ffa1fc3f49690"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/cf/01/e8a380dc6e92a76113f034c58c9ffdbd115753e9b944ddf5d2dbe862f248/pydantic-1.10.11.tar.gz"
    sha256 "f66d479cf7eb331372c470614be6511eae96f1f120344c25f3f9bb59fb1b5528"
  end

  resource "pygtail" do
    url "https://files.pythonhosted.org/packages/b0/89/437120e303d5d2c81107ed3415d5f3c9975f7dfdeef9e4440cef364e3bf9/pygtail-0.14.0.tar.gz"
    sha256 "55616d31a081eaaeb069d0946f2bc7e530ebf505d4c3c050f8e941786a3449d3"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e0/f0/9804c72e9a314360c135f42c434eb42eaabb5e7ebad760cbd8fc7023be38/PyJWT-2.7.0.tar.gz"
    sha256 "bd6ca4a3c4285c1a2d4349e5a035fdf8fb94e04ccd0fcbe6ba289dae9cc3e074"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/4f/13/28e88033cab976721512e7741000fb0635fa078045e530a91abb25aea0c0/pyparsing-3.1.0.tar.gz"
    sha256 "edb662d6fe322d6e990b1594b5feaeadf806803359e3d4d42f11e295e588f0ea"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/20/93/45213b5b6e3eeab03e3f6eb82cc516a81fbf257586a25f9eb1d21af96e1b/referencing-0.29.1.tar.gz"
    sha256 "90cb53782d550ba28d2166ef3f55731f38397def8832baac5d45235f1995e35e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/91/ac/789c1a81ac85f70cf17711e0fda2e0d27674d30b8addbfb36e92188a4f41/rich_argparse-1.2.0.tar.gz"
    sha256 "bf17fe00603ad90dbb94cd3a6a27a3a0051df6b3363fb1b46300398bb83740ea"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/75/80/7f76ff5d290a11a8d43653da186def13f293f00baf4927eae1ad128bf9de/rpds_py-0.8.8.tar.gz"
    sha256 "300b8579740b06e246238b730e636f314a7d8dc475be1868650f5d3ddc29a0d8"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/2d/69/31c7d6927338e1deac36e62be5a122e109a0a835a9bf2e30d422c0f3ccc3/simple-term-menu-1.6.1.tar.gz"
    sha256 "368b4158d1749b868552fb6c054b8301785086c71a7253dac8404cc3cb2d30e8"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/16/a5/1129ba9b20712a1d991383d99e06d3bbd3e77c278bde2d1bdd4f4ee0a463/SQLAlchemy-2.0.18.tar.gz"
    sha256 "1fb792051db66e09c200e7bc3bda3b1eb18a5b8eb153d2cedb2b14b56a68b8cb"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/06/68/559bed5484e746f1ab2ebbe22312f2c25ec62e4b534916d41a8c21147bf8/starlette-0.27.0.tar.gz"
    sha256 "6a6b0d042acb8d469a01eba54e9cda6cbd24ac602c4cd016723117d6a7e73b75"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c6/dd/0d3bab50ab4ef8bec849f89fec2adc2fabcc397018c30e57d9f0d4009c5e/uvicorn-0.22.0.tar.gz"
    sha256 "79277ae03db57ce7d9aa0567830bbb51d7a612f54d6e1e3e92da3ef24c2c8ed8"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/b3/17/d9453f774dd079fbe7d51565d58006f5059fc17c2fbcf952ef176fbb8657/watchfiles-0.19.0.tar.gz"
    sha256 "d9b073073e048081e502b6c6b0b88714c026a1a4c890569238d04aca5f9ca74b"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  resource "workflows.json" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/dstackai/dstack/e0014b9eea73014bff7f4d87688839bd8504adcc/cli/dstack/schemas/workflows.json"
    sha256 "38cf87e5b1cd73c7e6d5ff5e43a6e793a7fad90c904b628b75a1013de52d9ab0"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources.reject { |r| r.name == "workflows.json" }
    venv.pip_install_and_link buildpath

    site_packages = Language::Python.site_packages("python3.11")
    (libexec/site_packages/"dstack/schemas").install resource("workflows.json")
  end

  test do
    system "git", "init", "--initial-branch=main"

    expected = "No remote branch is configured"
    output = shell_output("#{bin}/dstack init 2>&1", 1).chomp
    assert_match expected, output

    expected = "No default project is configured"
    output = shell_output("#{bin}/dstack tags add -a #{testpath} 2>&1 brewtest", 1).chomp
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/dstack --version")
  end
end