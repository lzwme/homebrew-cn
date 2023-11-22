class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/ac/f5/93aeec56550b1c9d1c9cf879045c04110b4107ae357a6b2939a24ad6e767/dstack-0.12.3.tar.gz"
  sha256 "cdaf8cb1e98db86259bb1a14757dffc82cbdb1b1d0f62fec0d45dcabff839ff6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b12ec417b1d3c777eb4276b46ebe24806197628de82ae68ff436ac3d251a7ed"
    sha256 cellar: :any,                 arm64_ventura:  "2c5b6fe345ee9c74218e20d9b4b12818093ca8e227da42b522286acc56a4be5c"
    sha256 cellar: :any,                 arm64_monterey: "e22bced99a8046c6934f37984181f51fc384de7dca040af5130d58d36cd7802b"
    sha256 cellar: :any,                 sonoma:         "e73ee1afc2aec63227d062041b81c2c10da8cccf2896144e9c5d3e1967212790"
    sha256 cellar: :any,                 ventura:        "aaf81caad0f5e00569739bb852185ecc094bd95e0dd520d004d928d68769725f"
    sha256 cellar: :any,                 monterey:       "bd7636838bbb8888e4635235ed2f2a81a9ad38bd1b91a32aa97dcdd81afc9f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8464bf5cd17ee9297955bc0cb6621fe240f849079d23200c36d403e77cf1cbd4"
  end

  # `pkg-config` and `rust` are for bcrypt.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "protobuf"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-mako"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "greenlet" do
    on_intel do
      url "https://files.pythonhosted.org/packages/54/df/718c9b3e90edba70fa919bb3aaa5c3c8dabf3a8252ad1e93d33c348e5ca4/greenlet-3.0.1.tar.gz"
      sha256 "816bd9488a94cba78d93e1abb58000e8266fa9cc2aa9ccdd6eb0696acb24005b"
    end
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/71/80/68f3bd93240efd92e9397947301efb76461db48c5ac80be2423ffa9c20a3/aiohttp-3.9.0.tar.gz"
    sha256 "09f23292d29135025e19e8ff4f0a68df078fe4ee013bca0105b2e803989de92d"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/ea/51/060efa10a814145acd4e42c6e5ed540b8714cad52ca026c5930e7c473049/aiosqlite-0.19.0.tar.gz"
    sha256 "95ee77b91c8d2808bd08a59fbebf66270e9090c3d92ffbf260dc0db0b979577d"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/44/b4/253fe31261d9f5d603d89bd9e6fba1625494a6d761d319902dfe4db59016/alembic-1.12.1.tar.gz"
    sha256 "bca5877e9678b454706347bc10b97cb7d67f300320fa5c3a94423e8266e2823f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/28/99/2dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfce/anyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/5e/34/5dcb368cf89f93132d9a31bd3747962a9dc874480e54333b0c09fa7d56ac/APScheduler-3.10.4.tar.gz"
    sha256 "e6df071b27d9be898e486bc7940a7be50b4af2e9da7c08f0744a96d4bd4cef4a"
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
    url "https://files.pythonhosted.org/packages/e3/39/328faea9f656075dbb8ecf70f1a4697bc80510fcc70e3e8f0090c34fc00c/azure-core-1.29.5.tar.gz"
    sha256 "52983c89d394c6f881a121e5101c5fa67278ca3b1f339c8fb2ef39230c70e9ac"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/52/31/87dd867c239b5b2c5bccade8a0fd81c28b9b380ece3db47b58ae05270842/azure-graphrbac-0.61.1.zip"
    sha256 "53e98ae2ca7c19b349e9e9bb1b6a824aeae8dcfcbe17190d20fe69c0f185b2e2"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/74/02/a0545eaa3fb83a6b6c413de4a65e06a02ce887f874a2e74a1240b2169140/azure-identity-1.15.0.tar.gz"
    sha256 "4c28fc246b7f9265610eb5261d65931183d019a23d4b0e99357facb2e6c227c8"
  end

  resource "azure-keyvault-secrets" do
    url "https://files.pythonhosted.org/packages/5c/a1/78ecabf98e97d600dcac1559ff64b4bc9f84eca126c0aeba859916832b0c/azure-keyvault-secrets-4.7.0.zip"
    sha256 "77ee2534ba651a1f306c85d7b505bc3ccee8fea77450ebafafc26aec16e5445d"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/81/d8/9f57b9fb1899f189acc0b56f445e23ad15c5197e752b911f9fbc70c1b20e/azure-mgmt-compute-30.3.0.tar.gz"
    sha256 "e529786340f862aa6a218a7ad6a5beb6b9fb55833c5caa0851cc3314d0493b63"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/14/95/2b2085e40f4b9de88ad256428a669583066d8ab348fc19110c7d04c3189b/azure-mgmt-core-1.4.0.zip"
    sha256 "d195208340094f98e5a6661b781cde6f6a051e79ce317caabd8ff97030a9b3ae"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/5c/e6/54879a503c28d2b1ef991f086c41c86218a82dd81a5b870c59b79a0f15ce/azure-mgmt-keyvault-10.3.0.tar.gz"
    sha256 "183b4164cf1868b8ea7efeaa98edad7d2a4e14a9bd977c2818b12b75150cd2a2"
  end

  resource "azure-mgmt-loganalytics" do
    url "https://files.pythonhosted.org/packages/04/dc/48a624066655108e7f8490f643920c4ccec0798780a4e204e4ea93368039/azure-mgmt-loganalytics-13.0.0b6.zip"
    sha256 "f4aceb37f3ea14bffd1c5dcade31dc1f1de058621e183d9362d0966ad9c287c8"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/e4/31/ebabafe0be1a177428880a8ec0fc44d681ac9dc1ae66a70d859cb5c7fbc3/azure-mgmt-monitor-6.0.2.tar.gz"
    sha256 "5ffbf500e499ab7912b1ba6d26cef26480d9ae411532019bb78d72562196e07b"
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
    url "https://files.pythonhosted.org/packages/49/5c/9fc3418570dcb5de5f883f909b894f9cdd77829c84afb08b7370c796334e/azure-mgmt-storage-21.1.0.tar.gz"
    sha256 "d6d3c0e917c988bc9ed0472477d3ef3f90886009eb1d97a711944f8375630162"
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
    url "https://files.pythonhosted.org/packages/fd/f8/59c209132b3b2993402df6b7e79728726927b53168624e917cd9daaffea8/azure-storage-blob-12.19.0.tar.gz"
    sha256 "26c0a4320a34a3c2a1b74528ba6812ebcb632a04cd67b1c7377232c4b01a5897"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/8d/5f/4ee13ee77641c98032fcddb51456a26976f69365fdc3c6c9e699970b9e99/boto3-1.29.4.tar.gz"
    sha256 "ca9b04fc2c75990c2be84c43b9d6edecce828960fc27e07ab29036587a1ca635"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/10/6f/e7fe287501ae0bb2732e0752dde93c4a2ad1922953be16dd912acc2c26be/botocore-1.32.4.tar.gz"
    sha256 "6bfa75e28c9ad0321cefefa51b00ff233b16b2416f8b95229796263edba45a39"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/d9/d8/002e0ba7cf848a981b3ee92aaf5aa396c5700b0d7dec5d060031432a87d8/fastapi-0.104.1.tar.gz"
    sha256 "e5e4540a7c5e1dcfbbcf5b903c234feddcdcd881f191977a1c5dfd917487e7ae"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "git-url-parse" do
    url "https://files.pythonhosted.org/packages/26/ea/c8c22b051026d9debe95c92df4fa0388f30fcde6f10fc0000058d13f6996/git-url-parse-1.2.2.tar.gz"
    sha256 "7b5f4e3aeb1d693afeee67a3bd4ac063f7206c2e8e46e559f0da0da98445f117"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/0d/b2/37265877ae607a2cbf9a471f4581dbf5ed13a501b90cb4c773f9ccfff3ea/GitPython-3.1.40.tar.gz"
    sha256 "22b126e9ffb671fdd0c129796343a02bf67bf2994b35449ffc9321aa755e18a4"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/10/3c/a25588d309f439aaa27e98621ab2e7fef90cb4b7b0a91a188b0faeb7c4b6/google-api-core-2.14.0.tar.gz"
    sha256 "5368a4502b793d9bbf812a5912e13e4e69f9bd87f6efb508460c43f5bbd1ce41"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/f9/26/6e4218cda2e15e7b2120acf68c470f49ec7c811bc82c09b4befa5c66386e/google-api-python-client-2.108.0.tar.gz"
    sha256 "6396efca83185fb205c0abdbc1c2ee57b40475578c6af37f6d0e30a639aade99"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/f9/ff/06d757a319b551bccd70772dc656dd0bdedec54e72e407bdd6162116cb3a/google-auth-2.23.4.tar.gz"
    sha256 "79905d6b1652187def79d491d6e23d0cbb3a21d3c7ba0dbaa9c8a01906b13ff3"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/0f/7a/83c3a1f8419d66f91672ad7f2cea57d044f7f0b3c1740389a468ff3937ed/google-auth-httplib2-0.1.1.tar.gz"
    sha256 "c64bc555fdc6dd788ea62ecf7bccffcf497bf77244887a3f3d7a5a02f8e3fc29"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/26/f3/fc3e9bd221c76fbe1e94839d001deb1640370a8563f8a5d2b24ed762aa55/google-cloud-appengine-logging-1.3.2.tar.gz"
    sha256 "a2989fca0e88463b56432aa821e64b81c3d171ee37b84771189b48e8b97cd496"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/b1/3d/48e8b2c0cc7113d1674526b609944ef77d7182f233b23c50fec7106b2e2c/google-cloud-audit-log-0.2.5.tar.gz"
    sha256 "86e2faba3383adc8fd04a5bd7fd4f960b3e4aedaa7ed950f2f891ce16902eb6b"
  end

  resource "google-cloud-billing" do
    url "https://files.pythonhosted.org/packages/2b/fd/6bf82e5c9cb18bd35af5b9bc5671a62409d14a7c1b3550707d25bf3dc902/google-cloud-billing-1.11.5.tar.gz"
    sha256 "dd89da70ef7dd6970670a76b4f8ab4c3ee073d86c7ae9c7b261c181c7ca7bc4a"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/7b/9e/08be8264ee7de93fc38f4c92bce0e9dfededadd1532f075111bfdd19fc21/google-cloud-compute-1.14.1.tar.gz"
    sha256 "acd987647d7c826aa97b4418141c740ead5e8811d3349315f2f89a30c01c7f4b"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/6b/60/dcc26e42d3754ac57c51a524f53c988f2aa755faec4cc00a232bb0077637/google-cloud-core-2.3.3.tar.gz"
    sha256 "37b80273c8d7eee1ae816b3a20ae43585ea50506cb0e60f3cf5be5f87f1373cb"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/02/76/3d7ca9f2bff3bb0e880d40d718c1dbe9ff445dcb1cc0dbaa6204c3f8efaa/google-cloud-logging-3.8.0.tar.gz"
    sha256 "fdd916e59a84aa8c02e8148d7fdd3b3b623c57b0c1ff71f43297ce8e50fc1eab"
  end

  resource "google-cloud-secret-manager" do
    url "https://files.pythonhosted.org/packages/41/08/f344ff8d7a230f42f5374d25944642999c3e6d8ba13025e9fc7e79c5d95b/google-cloud-secret-manager-2.16.4.tar.gz"
    sha256 "371dc72f9145af323e8a813c8e50380e6ac4bd6a5dbcd42dcf3162d8f37e5080"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/f1/94/665b3b7394477704cc3e894e37e04aa7c68575d30f46c62dff9ef8f2e8a6/google-cloud-storage-2.13.0.tar.gz"
    sha256 "f62dc4c7b6cd4360d072e3deb28035fbdad491ac3d9b0b1815a12daea10f37c7"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/d3/a5/4bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352/google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/66/3a/66ff4e1e862b39b1ac6680bd29cc98bd0b65c150daabfae356694d3390de/google-resumable-media-2.6.0.tar.gz"
    sha256 "972852f6c65f933e15a4a210c2b96930763b47197cdf4aa5f5bea435efb626e7"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/95/41/f9d4425eac5cec8c0356575b8f183e8f1f7206875b1e748bd3af4b4a8a1e/googleapis-common-protos-1.61.0.tar.gz"
    sha256 "8a64866a97f6304a7179873a465d6eee97b7a24ec6cfd78e0f575e96b821240b"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/96/4e/2b14edbe7d10d3d91866ff9098b3981a167f4b64fe008aa0016d8ae3890b/gpuhunt-0.0.1rc9.tar.gz"
    sha256 "5729b7b81f6bd18fc2694e5d55520594422a5e9a9a11f0e7c57a1bef881cb2ed"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/05/6b/13dfa4e7e0551377b6ec234ab70f4e5d26779573a2b3bf41b3a8c86255a4/grpc-google-iam-v1-0.12.7.tar.gz"
    sha256 "009197a7f1eaaa22149c96e5e054ac5934ba7241974e92663d8d3528a21203d1"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/ab/a1/f838646e25402eb750f037cf84c1ada46084717375e44724c89900ee4c7d/grpcio-1.59.3.tar.gz"
    sha256 "7800f99568a74a06ebdccd419dd1b6e639b477dcaf6da77ea702f8fb14ce5f80"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/7e/4e/a0ede68d10ab8a0129ac041ebbf009cfd08411b406d69b4b089ee0dc8c0e/grpcio-status-1.59.3.tar.gz"
    sha256 "65c394ba43380d6bdf8c04c61efc493104b5535552aed35817a1b4dc66598a1f"
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
    url "https://files.pythonhosted.org/packages/a8/74/77bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03aff/jsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/d4/84/8f5072792a260016048d3a5ae5186ec3be9e090480ddf5446484394dd8c3/jsonschema_specifications-2023.11.1.tar.gz"
    sha256 "c9b234904ffe02f079bf91b14d79987faa685fd4b39c377a0996954c0090b9ca"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/df/55/2e3047c723a2e3ed880b8a37ab020419c2bae1c0ba3b994fefe0508cb351/msal-1.25.0.tar.gz"
    sha256 "f44329fdb59f4f044c779164a34474b8a44ad9e4940afbc4c3a3a2bbe90324d9"
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

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/35/00/0f230921ba852226275762ea3974b87eeca36e941a13cd691ed296d279e5/portalocker-2.8.2.tar.gz"
    sha256 "2b035aa7828e46c58e9b31390ee1f169b98e1066ab10b9a6a861fe7e25ee4f33"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/41/bd/4022c9a6de35821f215fdefc8b4e68bf9a054d04f43246f0c89ba8a7538e/proto-plus-1.22.3.tar.gz"
    sha256 "fdcd09713cbd42480740d2fe29c990f7fbd885a67efc328aa8be6ee3e9f76a6b"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/eb/84/9b0a0e2d931fc9bdb32e6905076714f9592f9b20de03c90fd0f65b3ab063/pydantic-1.10.10.tar.gz"
    sha256 "3b8d5bd97886f9eb59260594207c9f57dce14a6f869c6ceea90188715d29921a"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/2d/23/abcfad10c3348cb6358400f8adbc21b523bbc6c954494fd0974428068672/python_multipart-0.0.6.tar.gz"
    sha256 "e9925a80bb668529f1b67c7fdb0a5dacdd7cbfc6fb0bff3ea443fe22bdd62132"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/61/11/5e947c3f2a73e7fb77fd1c3370aa04e107f3c10ceef4880c2e25ef19679c/referencing-0.31.0.tar.gz"
    sha256 "cc28f2c88fbe7b961a7817a0abc034c09a1e36358f82fedb4ffdf29a25398863"
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
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/7b/04/4b0b9b06662a4559041a88c2d31e93ecbc8aca1c45fee10a0c1a000b7274/rich_argparse-1.4.0.tar.gz"
    sha256 "c275f34ea3afe36aec6342c2a2298893104b5650528941fb53c21067276dba19"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/94/3f/b58db0c212ba3a89378d1684f871e0e7783fc34fadc7696e5439c8c9338e/rpds_py-0.13.1.tar.gz"
    sha256 "264f3a5906c62b9df3a00ad35f6da1987d321a053895bd85f9d5c708de5c0fbf"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/af/e3/78df2069dd13637349d4013c033b45b8ece6b13f676badd5f883ad630e7d/sentry-sdk-1.36.0.tar.gz"
    sha256 "f32dd16547f2f45e1c71a96fd4a48925e629541f7ddfe3d5d25ef7d5e94eb3c8"
  end

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/57/d7/99e90b434f7b7d9a63b1c2f363fbac4e60b39bdd627696049c2edd15a6b3/simple-term-menu-1.6.3.tar.gz"
    sha256 "edf0d7ed4a9d43fbeb75166c1927b95c5a1d8cf513dd929f6ee80950e2adf601"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/ee/46/a3196db7ffd2609c7935798730e21bed8806d9bf4401921587dac4be0747/SQLAlchemy-2.0.23.tar.gz"
    sha256 "c1bda93cbbe4aa2aa0aa8655c5aeda505cd219ff3e8da91d1d329e143e4aff69"
  end

  resource "sqlalchemy-utils" do
    url "https://files.pythonhosted.org/packages/a3/e0/6906a8a9b8e9deb82923e02e2c1f750c567d69a34f6e1fe566792494a682/SQLAlchemy-Utils-0.41.1.tar.gz"
    sha256 "a2181bff01eeb84479e38571d2c0718eb52042f9afd8c194d0d02877e84b7d74"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/06/68/559bed5484e746f1ab2ebbe22312f2c25ec62e4b534916d41a8c21147bf8/starlette-0.27.0.tar.gz"
    sha256 "6a6b0d042acb8d469a01eba54e9cda6cbd24ac602c4cd016723117d6a7e73b75"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/e5/84/d43ce8fe6b31a316ef0ed04ea0d58cab981bdf7f17f8423491fa8b4f50b6/uvicorn-0.24.0.post1.tar.gz"
    sha256 "09c8e5a79dc466bdf28dead50093957db184de356fcdc48697bad3bde4c2588e"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/66/79/0ee412e1228aaf6f9568aa180b43cb482472de52560fbd7c283c786534af/watchfiles-0.21.0.tar.gz"
    sha256 "c76c635fabf542bb78524905718c39f736a98e5ab25b23ec6d4abede1a85a6a3"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/ca/f7/2af788563995eeec32b920c0640a6bc54777c89c780030a7754f95166b7f/yarl-1.9.3.tar.gz"
    sha256 "4a14907b597ec55740f63e52d7fee0e9ee09d5b9d57a4f399a7423268e457b57"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = "No default project, specify project name"
    assert_match expected, shell_output("#{bin}/dstack init 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/dstack --version")
  end
end