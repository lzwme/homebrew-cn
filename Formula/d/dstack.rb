class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https:dstack.ai"
  url "https:files.pythonhosted.orgpackages268adb535673244a2ae8dde1e2da4a6537e489657e8bfe1e1b95239c6834e9c6dstack-0.18.25.tar.gz"
  sha256 "f896975eee750eed51bdac2cf66ebfadea64ad08fdf5dcc71dfc59e8a6468d24"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7d84efa586f655808749351a93ab87f19e4403fe2b5e2863b95acdbb4f9eaa5"
    sha256 cellar: :any,                 arm64_sonoma:  "e75c76282962e3a8e4f32f552fffe5f0b997898b6922df9172944539d4e43493"
    sha256 cellar: :any,                 arm64_ventura: "967c5c3243bd44e535de5c8adc55467b463965d1728f553b4f7e083894372a09"
    sha256 cellar: :any,                 sonoma:        "b2b452ce41ffec30f82cfe03f6deb0f42585c65bef280a1981eb195af44aa72a"
    sha256 cellar: :any,                 ventura:       "970cd29d41e73f228a612babba6310e418c819b790ece4bf7f11cb9a13f745c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4e998a433c3bf36fd4ff9a6e4d4a18026c439f741a3bbc733982a5d64e5f0a"
  end

  # `pkgconf` and `rust` are for bcrypt.
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.12" # Python 3.13 needs new asyncpg: https:github.comMagicStackasyncpgissues1181

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackagesbc692f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages1dcdaf0e573bdb77ae7df1148fe8e4ea854215a37db0b116aac6b5496335095eaiohttp-3.11.4.tar.gz"
    sha256 "9d95cce8bb010597b3f2217155befe4708e0538d3548aa08d640ebf54e3f57cb"
  end

  resource "aiorwlock" do
    url "https:files.pythonhosted.orgpackagesbac5882b4c89d71d6f9c7d0d8dee18d267025e71d4c3241eb3b16ab39105a0d1aiorwlock-1.4.0.tar.gz"
    sha256 "4cea5bec4e9d03533a26919299394822a1422aa519bca9dd09178ec490f8d1cc"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aiosqlite" do
    url "https:files.pythonhosted.orgpackages0d3a22ff5415bf4d296c1e92b07fd746ad42c96781f13295a074d58e77747848aiosqlite-0.20.0.tar.gz"
    sha256 "6d35c8c256637f4672f843c31021464090805bf925385ac39473fb16eaaca3d7"
  end

  resource "alembic" do
    url "https:files.pythonhosted.orgpackages001e8cb8900ba1b6360431e46fb7a89922916d3a1b017a8908a7c0499cc7e5f6alembic-1.14.0.tar.gz"
    sha256 "b00892b53b3642d0b8dbedba234dbf1924b69be83a9a769d5a624b01094e304b"
  end

  resource "alembic-postgresql-enum" do
    url "https:files.pythonhosted.orgpackagesc4635188bd184cc7515090ca98686b97695f68aca403c119e688b66ceb0e653balembic_postgresql_enum-1.3.0.tar.gz"
    sha256 "64d5de7ac2ea39433afd965b057ca882fb420eb5cd6a7db8e2b4d0e7e673cae1"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages9f0945b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546ccanyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
  end

  resource "apscheduler" do
    url "https:files.pythonhosted.orgpackages5e345dcb368cf89f93132d9a31bd3747962a9dc874480e54333b0c09fa7d56acAPScheduler-3.10.4.tar.gz"
    sha256 "e6df071b27d9be898e486bc7940a7be50b4af2e9da7c08f0744a96d4bd4cef4a"
  end

  resource "asyncpg" do
    url "https:files.pythonhosted.orgpackages2f4c7c991e080e106d854809030d8584e15b2e996e26f16aee6d757e387bc17dasyncpg-0.30.0.tar.gz"
    sha256 "c551e9928ab6707602f44811817f82ba3c446e018bfe1d3abecc8ba5f3eac851"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
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

  resource "azure-mgmt-authorization" do
    url "https:files.pythonhosted.orgpackages9eabe79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73dazure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https:files.pythonhosted.orgpackages90f2a2b1391e9df876d7ef9086f8d41ad4666eafef921ae0c47da931f8cedb1aazure-mgmt-compute-33.0.0.tar.gz"
    sha256 "a3cc0fe4f09c8e1d3523c1bfb92620dfe263a0a893b0ac13a33d7057e9ddddd2"
  end

  resource "azure-mgmt-core" do
    url "https:files.pythonhosted.orgpackages489a9bdc35295a16fe9139a1f99c13d9915563cbc4f30b479efaa40f8694eaf7azure_mgmt_core-1.5.0.tar.gz"
    sha256 "380ae3dfa3639f4a5c246a7db7ed2d08374e88230fd0da3eb899f7c11e5c441a"
  end

  resource "azure-mgmt-network" do
    url "https:files.pythonhosted.orgpackagesbfaabf464fd70eefa8f13f5e5b45d021416d5c9c8d79eabb96f4a673fe91346dazure_mgmt_network-27.0.0.tar.gz"
    sha256 "5c1c61d8bb13ad40f788a26fd7569c1d9d60eb2e4cb19c2a1b5d9c02ae862316"
  end

  resource "azure-mgmt-resource" do
    url "https:files.pythonhosted.orgpackages71e9cafb7076283db9f21e05e54fa0536b16d790e43f30691e80d6eac4603789azure_mgmt_resource-23.2.0.tar.gz"
    sha256 "747b750df7af23ab30e53d3f36247ab0c16de1e267d666b1a5077c39a4292529"
  end

  resource "azure-mgmt-subscription" do
    url "https:files.pythonhosted.orgpackages846714b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagese47ed95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages46d52eda9ef554182c3b306ea18c049f152be8495198911ce0c4c2375eb6a236boto3-1.35.64.tar.gz"
    sha256 "bc3fc12b41fa2c91e51ab140f74fb1544408a2b1e00f88a4c2369a66d18ddf20"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages0ed371c2bbccea5a307e9b6218e41b5189d5e0c61217dc8d883dcac6a2aae762botocore-1.35.64.tar.gz"
    sha256 "2f95c83f31c9e38a66995c88810fc638c829790e125032ba00ab081a2cf48cb9"
  end

  resource "cached-classproperty" do
    url "https:files.pythonhosted.orgpackages6f006c75d528e795555d65de8a4cd181347a5918d267c278478aeba2b369769bcached_classproperty-1.0.1.tar.gz"
    sha256 "24ac50911c5a87bd57fafc348ce14ba58584975e73d1dfea329d1dcdc9f774c0"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cursor" do
    url "https:files.pythonhosted.orgpackages591bae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages2ea353e7d78a6850ffdd394d7048a31a6f14e44900adedf190f9a165f6b69439deprecated-1.2.15.tar.gz"
    sha256 "683e561a90de76239796e6b6feac66b99030d2dd3fcf61ef996330f14bbb9b0d"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages919b4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83cedocker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "fastapi" do
    url "https:files.pythonhosted.orgpackagesae29f71316b9273b6552a263748e49cd7b83898dc9499a663d30c7b9cb853cb8fastapi-0.115.5.tar.gz"
    sha256 "0e7a4d0dc0d01c68df21887cce0945e72d3c48b9f4f79dfe7a7d53aa08fbb289"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8fed0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
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
    url "https:files.pythonhosted.orgpackagesfa6bb98553c2061c4e2186f5bbfb1aa1a6ef13fc0775c096d18595d3c99ba023google_api_core-2.23.0.tar.gz"
    sha256 "2ceb087315e6af43f256704b871d99326b1f12a9d6ce99beaedec99ba26a0ace"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages405261cb7132cc4c328dfa8d752a64824ff11b3f6dec9c8687320342805f2f48google_api_python_client-2.153.0.tar.gz"
    sha256 "35cce8647f9c163fc04fb4d811fc91aae51954a2bdd74918decbe0e65d791dd2"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages6a714c5387d8a3e46e3526a8190ae396659484377a73b33030614dd3b28e7dedgoogle_auth-2.36.0.tar.gz"
    sha256 "545e9618f2df0bcbb7dcbc45a546485b1212624716975a1ea5ae8149ce769ab1"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-cloud-appengine-logging" do
    url "https:files.pythonhosted.orgpackagesb2fd03fe325ced54e7a5ab1c053e895570174ef939e286ba05094c4a62ec6bcfgoogle_cloud_appengine_logging-1.5.0.tar.gz"
    sha256 "39a2df694d97981ed00ef5df541f7cfcca920a92496707557f2b07bb7ba9d67a"
  end

  resource "google-cloud-audit-log" do
    url "https:files.pythonhosted.orgpackageseb81c345efe9261a4b0bd0c5957f1685d2b4cc4522ec4fc7b0861f691d4476e7google_cloud_audit_log-0.3.0.tar.gz"
    sha256 "901428b257020d8c1d1133e0fa004164a555e5a395c7ca3cdbb8486513df3a65"
  end

  resource "google-cloud-billing" do
    url "https:files.pythonhosted.orgpackages06f78f5b83bcb05d30b8a8644045853092c88bfe69e9f55964e00987a35eda8dgoogle_cloud_billing-1.14.1.tar.gz"
    sha256 "99d10cbca4a13dbe721d12cc624f0dd49d5e1fc9ac4a1e3b3b5c6a9914d2992b"
  end

  resource "google-cloud-compute" do
    url "https:files.pythonhosted.orgpackages60a9cabe95bd631addae6c1a562262d806017d1f5ef86dcfcd371ad69e03dfb1google_cloud_compute-1.22.0.tar.gz"
    sha256 "538af297f5a21413336a8e32ccba8690d315de4c6f09a4763ba98aa98b70e618"
  end

  resource "google-cloud-core" do
    url "https:files.pythonhosted.orgpackagesb81f9d1e0ba6919668608570418a9a51e47070ac15aeff64261fb092d8be94c0google-cloud-core-2.4.1.tar.gz"
    sha256 "9b7749272a812bde58fff28868d0c5e2f585b82f37e09a1f6ed2d4d10f134073"
  end

  resource "google-cloud-logging" do
    url "https:files.pythonhosted.orgpackagesa5ac1eabcefb926414812b759102e4b03a123ad5bfc9576bac0f27405e2f3727google_cloud_logging-3.11.3.tar.gz"
    sha256 "0a73cd94118875387d4535371d9e9426861edef8e44fba1261e86782d5b8d54f"
  end

  resource "google-cloud-storage" do
    url "https:files.pythonhosted.orgpackagesd6b71554cdeb55d9626a4b8720746cba8119af35527b12e1780164f9ba0f659agoogle_cloud_storage-2.18.2.tar.gz"
    sha256 "aaf7acd70cdad9f274d29332673fcab98708d0e1f4dceb5a5356aaef06af4d99"
  end

  resource "google-cloud-tpu" do
    url "https:files.pythonhosted.orgpackages16a7d045b9ae4a5cf97f85b080421747b414ed0043b42569c65eeac8662d4679google_cloud_tpu-1.19.1.tar.gz"
    sha256 "8dce6def995d94f0962fc4520c733df710e0f636493b2f3b60bdf327448d13fc"
  end

  resource "google-crc32c" do
    url "https:files.pythonhosted.orgpackages6772c3298da1a3773102359c5a78f20dae8925f5ea876e37354415f68594a6fbgoogle_crc32c-1.6.0.tar.gz"
    sha256 "6eceb6ad197656a1ff49ebfbbfa870678c75be4344feb35ac1edf694309413dc"
  end

  resource "google-resumable-media" do
    url "https:files.pythonhosted.orgpackages585a0efdc02665dca14e0837b62c8a1a93132c264bd02054a15abb2218afe0aegoogle_resumable_media-2.7.2.tar.gz"
    sha256 "5280aed4629f2b60b847b0d42f9857fd4935c11af266744df33d8074cae92fe0"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackagesffa78e9cccdb1c49870de6faea2a2764fa23f627dd290633103540209f03524cgoogleapis_common_protos-1.66.0.tar.gz"
    sha256 "c3e7b33d15fdca5374cc0a7346dd92ffa847425cc4ea941d970f13680052ec8c"
  end

  resource "gpuhunt" do
    url "https:files.pythonhosted.orgpackages65f31046d5612853bf906114a997db2524d304c57354f10da96a5b4bf50142ebgpuhunt-0.0.16.tar.gz"
    sha256 "ca8a2dafd66b71f1f68596db9c7738d2d7c229cd9d35a5437529162d2ed14959"
  end

  resource "greenlet" do
    url "https:files.pythonhosted.orgpackages2fffdf5fede753cc10f6a5be0931204ea30c35fa2f2ea7a35b25bdaf4fe40e46greenlet-3.1.1.tar.gz"
    sha256 "4ce3ac6cdb6adf7946475d7ef31777c26d94bccc377e070a7986bd2d5c515467"
  end

  resource "grpc-google-iam-v1" do
    url "https:files.pythonhosted.orgpackages6341f01bf46bac4034b4750575fe87c80c5a43a8912847307955e22f2125b60cgrpc-google-iam-v1-0.13.1.tar.gz"
    sha256 "3ff4b2fd9d990965e410965253c0da6f66205d5a8291c4c31c6ebecca18a9001"
  end

  resource "grpcio" do
    url "https:files.pythonhosted.orgpackagesd5da132615afbfc722df4bba963844843a205aa298fd5f9a03fa2995e8dddf11grpcio-1.68.0.tar.gz"
    sha256 "7e7483d39b4a4fddb9906671e9ea21aaad4f031cdfc349fec76bdfa1e404543a"
  end

  resource "grpcio-status" do
    url "https:files.pythonhosted.orgpackages7095500b24fc02a98ea16097e978958dd7ab9e16db9316a3f0bdc88d5ff239dfgrpcio_status-1.68.0.tar.gz"
    sha256 "8369823de22ab6a2cddb3804669c149ae7a71819e127c2dca7c2322028d52bea"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
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
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
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

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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

  resource "mako" do
    url "https:files.pythonhosted.orgpackagesfa0b29bc5a230948bf209d3ed3165006d257e547c02c3c2a96f6286320dfe8dcmako-1.3.6.tar.gz"
    sha256 "9ec3a1583713479fae654f83ed9fa8c9a4c16b7bb0daba0e6bbebff50c0d983d"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https:files.pythonhosted.orgpackages3ff3cdf2681e83a73c3355883c2884b6ff2f2d2aadfc399c28e9ac4edc3994fdmsal-1.31.1.tar.gz"
    sha256 "11b5e6a3f802ffd3a72107203e20c4eac6ef53401961b880af2835b723d80578"
  end

  resource "msal-extensions" do
    url "https:files.pythonhosted.orgpackages2d38ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5ebmsal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "msrest" do
    url "https:files.pythonhosted.orgpackages68778397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https:files.pythonhosted.orgpackages5134e4e9245c868c6490a46ffedf6bd5b0f512bbc0a848b19e3a51f6bbad648copentelemetry_api-1.28.2.tar.gz"
    sha256 "ecdc70c7139f17f9b0cf3742d57d7020e3e8315d6cffcdf1a12a905d45b19cc0"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages1b0fc00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609bparamiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
  end

  resource "portalocker" do
    url "https:files.pythonhosted.orgpackagesedd3c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa94d5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cdpropcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackages7e0574417b2061e1bf1b82776037cad97094228fa1c1b6e82d08a78d3fb6ddb6proto_plus-1.25.0.tar.gz"
    sha256 "fbb17f57f7bd05a68b7707e745e26528b0b3c34e378db91eef93912c54982d91"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages746ee69eb906fddcb38f8530a12f4b410699972ab7ced4e21524ece9d546ac27protobuf-5.28.3.tar.gz"
    sha256 "64badbc49180a5e401f373f9ce7ab1d18b63f7dd4a9cdc43c92b9f0b481cef7b"
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
    url "https:files.pythonhosted.orgpackagesa12ddf30554721cdad26b241b7a92e726dd1c3716d90c92915731eb00e17a9f7pydantic-1.10.19.tar.gz"
    sha256 "fea36c2065b7a1d28c6819cc2e93387b43dd5d3cf5a1e82d8132ee23f36d1f10"
  end

  resource "pydantic-duality" do
    url "https:files.pythonhosted.orgpackages9e64da9e9525f68803d75dca8b693097c666e53f2268cddaa51d6ec2335fe331pydantic_duality-1.2.4.tar.gz"
    sha256 "34bdbf102c004f009619c2b6682143fa6f14c04bf947f0ba72d75b04e84a65c7"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagesb505324952ded002de746f87b21066b9373080bb5058f64cf01c4d62784b8186pyjwt-2.10.0.tar.gz"
    sha256 "7628a7eb7938959ac1b26e819a1df0fd3259505627b575e4bad6d08f76db695c"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8cd5e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dxf" do
    url "https:files.pythonhosted.orgpackagesccf6aac11aa8d64d39706838d57ace0b5ba5c31af157019e96c1bf2a8930563dpython_dxf-12.1.0.tar.gz"
    sha256 "59ff22c0ab92a29fb3085f65ea70c0e8c7ff9fdfd74db0109efd5dfdc404d96c"
  end

  resource "python-json-logger" do
    url "https:files.pythonhosted.orgpackages4fda95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "python-multipart" do
    url "https:files.pythonhosted.orgpackages4022edea41c2d4a22e666c0c7db7acdcbf7bc8c1c1f7d3b3ca246ec982fec612python_multipart-0.0.17.tar.gz"
    sha256 "41330d831cae6e2f22902704ead2826ea038d0419530eadff3ea80175aec5538"
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
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rich-argparse" do
    url "https:files.pythonhosted.orgpackages7feec410251ff6123d4417f2fe8e72c8628f187682b70ce34134a2a3e307a2d5rich_argparse-1.6.0.tar.gz"
    sha256 "092083c30da186f25bcdff8b1d47fdfb571288510fb051e0488a72cc3128de13"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages2380afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4frpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0a8e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "sentry-sdk" do
    url "https:files.pythonhosted.orgpackages24cc0d87cc8246f52d92228aa6718a24e1988a2893f4abe2f64ec5a8bcba4185sentry_sdk-2.18.0.tar.gz"
    sha256 "0dc21febd1ab35c648391c664df96f5f79fb0d92d7d4225cd9832e53a617cafd"
  end

  resource "simple-term-menu" do
    url "https:files.pythonhosted.orgpackagesa1a07e78b93510886f6fb5b7146bd5cee03986fa5c2319644155c275e389c55asimple-term-menu-1.6.4.tar.gz"
    sha256 "be9c5dbd8df12a404b14cd8e95d6fc02d58c60e2555f65ddde41777c487fb3b9"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlalchemy" do
    url "https:files.pythonhosted.orgpackages50659cbc9c4c3287bed2499e05033e207473504dc4df999ce49385fb1f8b058asqlalchemy-2.0.36.tar.gz"
    sha256 "7f2767680b6d2398aea7082e45a774b2b0767b5c8d8ffb9c8b683088ea9b29c5"
  end

  resource "sqlalchemy-utils" do
    url "https:files.pythonhosted.orgpackages4dbfabfd5474cdd89ddd36dbbde9c6efba16bfa7f5448913eba946fed14729daSQLAlchemy-Utils-0.41.2.tar.gz"
    sha256 "bc599c8c3b3319e53ce6c5c3c471120bd325d0071fb6f38a10e924e3d07b9990"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackages1a4c9b5764bd22eec91c4039ef4c55334e9187085da2d8a2df7bd570869aae18starlette-0.41.3.tar.gz"
    sha256 "0e4ab3d16522a255be6b28260b938eae2482f98ce5cc934cb08dce8dc3ba5835"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagese84f0153c21dc5779a49a0598c445b1978126b1344bab9ee71e53e44877e14e0tqdm-4.67.0.tar.gz"
    sha256 "fe5a6f95e6fe0b9755e9469b77b9c3cf850048224ecaa8293d7d2d31f97d869a"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackagese0fc1d785078eefd6945f3e5bab5c076e4230698046231eb0f3747bc5c8fa992uvicorn-0.32.0.tar.gz"
    sha256 "f78b36b143c16f54ccdb8190d0a26b5f1901fe5a3c777e1ab29f26391af8551e"
  end

  resource "watchfiles" do
    url "https:files.pythonhosted.orgpackagesc8272ba23c8cc85796e2d41976439b08d52f691655fdb9401362099502d1f0cfwatchfiles-0.24.0.tar.gz"
    sha256 "afb72325b74fa7a428c009c1b8be4b4d7c2afedafb2982827ef2156646df2fe1"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "www-authenticate" do
    url "https:files.pythonhosted.orgpackagesa72d5567291a8274ef5d9b6495a1ec341394ab68933e2396936755b157f87b43www-authenticate-0.9.2.tar.gz"
    sha256 "cf75fc2ea5effb0f9342d7de7619b736f2a7d4b223331a53e296863a286e9dcb"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages4bd50d0481857de42a44ba4911f8010d4b361dc26487f48d5503c66a797cff48yarl-1.17.2.tar.gz"
    sha256 "753eaaa0c7195244c84b5cc159dc8204b7fd99f716f11198f999f2332a86b178"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3f50bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56fzipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    expected = "No default project, specify project name"
    assert_match expected, shell_output("#{bin}dstack init 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}dstack --version")
  end
end