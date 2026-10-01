class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/82/6c/f8e0e8dcc8ae9c48f535a875ab404befbe65397d4f0b74207d2063f04023/dstack-0.22.1.tar.gz"
  sha256 "a8322739ea62d7da60a446092c1716d89d80d78c0d78ef47dd15492a86d2651c"
  license "MPL-2.0"
  revision 1
  head "https://github.com/dstackai/dstack.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "167580a4518870d629136ca3ea2cbdfb57ea4a41e45a48f13a7d05ef19ff17f2"
    sha256 cellar: :any, arm64_tahoe:       "18a849fffe88dc26ecb444f116161382e5605ef7259eadeb9c72b7d07b49720d"
    sha256 cellar: :any, arm64_sequoia:     "f8b1656064f34b1e104d7caca48a59b214928a9f5cde893c46b52b1e21d03c94"
    sha256 cellar: :any, arm64_linux:       "8328f9bc73c33c2ec0625c50d8304b86886bf56582ecae34357f2ef17cf18ed8"
    sha256 cellar: :any, x86_64_linux:      "3a91cc6499b80d18329c0623c6ef420ff4345f0913d5ba46edd504a8e09ee331"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages package_name:     "dstack[aws,azure,gcp,lambda]",
                exclude_packages: %w[certifi cryptography pydantic rpds-py]

  resource "aiocache" do
    url "https://files.pythonhosted.org/packages/7a/64/b945b8025a9d1e6e2138845f4022165d3b337f55f50984fbc6a4c0a1e355/aiocache-0.12.3.tar.gz"
    sha256 "f528b27bf4d436b497a1d0d1a8f59a542c153ab1e37c3621713cb376d44c4713"
  end

  resource "aiorwlock" do
    url "https://files.pythonhosted.org/packages/6b/65/316cdc82c1b92953235ced1c71a3763f0cd9273c3bec5db60bdb5ad59bfe/aiorwlock-1.5.1.tar.gz"
    sha256 "2729c77ec736c8d85ec305aa3827a50394fd8c6d823f4404d301cc8c59a4b7f5"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/ed/aa/02910bdb8e2f1444f6654d5b296cd827d126f82209050ee7b1000f92ac4b/alembic-1.20.0.tar.gz"
    sha256 "db505480647bc60386c5369402f4a57a506b7539c9e9ef5e270d45cbbe4939bf"
  end

  resource "alembic-postgresql-enum" do
    url "https://files.pythonhosted.org/packages/63/cf/b5147b926441e7cdc12f306465dac488ff22364b1467a09a5d43743b8cfc/alembic_postgresql_enum-1.10.0.tar.gz"
    sha256 "ea23481de3d6a00d68d369f92a46ff4fa27b2575e39c583145f1e23ea9c7511d"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/8c/6b/eeff360196bb20b312c9e762a820fd1b2c6d809466c755ef57863478e454/apscheduler-3.11.3.tar.gz"
    sha256 "cd2fcc9330039a81a5893472ad49facf23a6d5604cbe1d918c835c6de7834d5a"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "asyncpg" do
    url "https://files.pythonhosted.org/packages/fe/cc/d18065ce2380d80b1bcce927c24a2642efd38918e33fd724bc4bca904877/asyncpg-0.31.0.tar.gz"
    sha256 "c989386c83940bfbd787180f2b1519415e2d3d6277a70d9d0f0145ac73500735"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/ac/5d/264f77dfb852e0c2f03c348b8be618a8794e57ba16d2b55c22dcb81ef5aa/azure_mgmt_compute-38.4.0.tar.gz"
    sha256 "7bf2f2b49e2b7cedf5f3eb2a71cf501b70e5898bd45d2421650029b95d589835"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/f8/83/f2e8eeca619905ffc48205664ad10e7cdfc168be522a06d04bea54e41556/azure_mgmt_msi-7.1.0.tar.gz"
    sha256 "1a01a089f1f66cb0d4b2886603d5ba415f360eff0be6f685737ecdd59c78225b"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/bf/aa/bf464fd70eefa8f13f5e5b45d021416d5c9c8d79eabb96f4a673fe91346d/azure_mgmt_network-27.0.0.tar.gz"
    sha256 "5c1c61d8bb13ad40f788a26fd7569c1d9d60eb2e4cb19c2a1b5d9c02ae862316"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/61/e1/c6196381cc6bb3eff9e24f5bf31b7fd962651ddbd6120bc2a4c482a7af16/azure_mgmt_resource-26.0.0.tar.gz"
    sha256 "54227c5db06d3be4dd4b77ad885b273e9eb2606d1de653c5b534066cfbb60c0c"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b3/d3/aae7125fb2ed6796aea7a0f5588af71971569f14063cfa65a01178f619ca/boto3-1.43.104.tar.gz"
    sha256 "d26ad9b8f6066e9be90c78c1f8f0cdd82e33e0a363a1ccc5ab01008b0e48c7fd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9f/47/5825401cb9883bc0fbf981dfb4893371f48bc77527bde6c1efe8f9aa8754/botocore-1.43.104.tar.gz"
    sha256 "099f84876df9f6dc23a24b4d8c02da2d73c6949249761dd85585f735b825c182"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/29/2c/3f18755527b03ca9ff6be724bd5370cb777c76a87f17301377cf04a4729b/cachetools-7.2.0.tar.gz"
    sha256 "bcac1a1b8da6909994a2957238a57b8140dab7c5c5c69a43669654fe87a33c1d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/88/7f/731ff914b0255d3d065f45fd4e626d4b8c95dbcbaada049f337a6ac16410/docker-7.2.0.tar.gz"
    sha256 "cebb93773d334f778e023a7ee352a8d6e13ab1bd3b863a4d4a59dec897df43ac"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/8a/02/91e3416a8fdd715abb903a952a6bec7cdd8d14eed55d415fc8595524c319/fastapi-0.141.1.tar.gz"
    sha256 "e8822fc40db1e1858054d7a949a888695bc9bdce70139178e33bd2871a453ca1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/2b/2d/5cb7a5ac017031e96a63173f3d57a8a5162ce36f9ff461e62bc6da4d88ab/filelock-4.0.6.tar.gz"
    sha256 "323fab3b2fb22d889b29fa83774f60029addddb4b6a1bcfa1e73066eabffb5f2"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e0/db/3ca813cbacb23ab6fe46ff38a9b5ef8e73e970c8051f2ce903aacafe0446/gitpython-3.1.62.tar.gz"
    sha256 "1791de66309bc0c7cfca40bf8d2e3de7ca091cbf94e6051be1ad0722c61062af"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/44/8d/cbdc715cdfb7acd7ccf1ce2869b103734c6a3cf124afd021f56c10c17522/google_api_core-2.39.0.tar.gz"
    sha256 "824ee414a10adefefae33fc5e2ba28dc6f0f7089d011c9cc98ea9178e61299e9"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/fd/e5/12024a0ae2fd39a54ff47a3868c47344ffff4ff1cd5edf4dff523c1a9fc1/google_api_python_client-2.200.0.tar.gz"
    sha256 "82aa18b851328ea04867fd51c5a0c8da2e1b86ec45ce08487e902e7726d4ee50"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/3b/0b/9b4e806ebcd29701b5193a162dd9906c4c5a16cbde8476461622d2bfa70e/google_auth-2.59.0.tar.gz"
    sha256 "eb32f44f89f6b577947ebee5887c1db46e6b1a278889ba369a88179643f32240"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/d4/74/0c8177b73734dfbd89420c162ac8754257fa0f9007fb49569493d83a17db/google_auth_httplib2-0.4.2.tar.gz"
    sha256 "916225a6367e613c9af44d83f41688a599d3f687777846b8b91bec65085ed1f1"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/7f/b9/fcafc8d2dc68975a65cdff74807547cff9b2a7b00e738d3f5ff0bd112867/google_cloud_appengine_logging-1.10.0.tar.gz"
    sha256 "b5563e76010a36e6adf1cc489620c29ee4fb3b986b006d237e9a061eb0f0abb7"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/69/91/e2a4ed95e790564b807a61fd54d90aa6bf2d3a9474bc5197651acf0cad13/google_cloud_audit_log-0.6.2.tar.gz"
    sha256 "ea5dc892b1858d345aef0c5563a728534fa875bd0388765391574d3c57fd8f0e"
  end

  resource "google-cloud-billing" do
    url "https://files.pythonhosted.org/packages/30/c1/6f6e9762e8e89edc21267062456d851da02773eceb8250583cee44f89ceb/google_cloud_billing-1.20.0.tar.gz"
    sha256 "155824147381d3ed0303092540992bde50214a29177529458e3c4cc3de2b588f"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/2a/36/e467fefd6ea440497260b113652ee4ced649fb9b81c7b6ce29caa85dab16/google_cloud_compute-1.54.0.tar.gz"
    sha256 "75be7d3a9d58c286f7d0b567a2fc4fb3f451fa665338c731e61b12b331487be1"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/f9/54/790548b190cff9cf07225c811d2668eacd8f2cbf04114475cbe3e5738752/google_cloud_core-2.7.0.tar.gz"
    sha256 "874aaf89765db87a9b911b7a2ca7c5068554868eed9e75c7766affe342a2913d"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/61/08/73f21dd94c7da7c2580dd179fdaebf72b74f2ea06d9812924dfd57d6d765/google_cloud_logging-3.16.3.tar.gz"
    sha256 "5d7924bbb33c066bb43f70d33ba66749ff1c29b207de4c80b2bce1aacd53f676"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/5c/b9/de4f0a218485bdbac839ad337166997171471a29c7d28c03b41b37830379/google_cloud_storage-3.15.0.tar.gz"
    sha256 "110041ee1cb566114015aa7c2492f1ff18c92af528588386663f4b41b6279989"
  end

  resource "google-cloud-tpu" do
    url "https://files.pythonhosted.org/packages/d5/4a/1cd9c4afa464df17dd1ba231e099ea7e5ddd7460af325f5954de87f0ab3f/google_cloud_tpu-1.27.0.tar.gz"
    sha256 "9c7abbf299f4fa6d421cf094268b795ad6fb99ec02b31af152160469db383c4e"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/fa/25/9cb0c1c31c45b893eb8f11ae70b3f4309432d59b5acaebca5dbe791729a4/google_crc32c-1.9.0.tar.gz"
    sha256 "7b8c84c3d159ab6817fe3f74e6e6cef099c3f95dcec3abc0d8afb1404642efbe"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/17/4b/44e128cd7b0e72cd26da4a3052cd8a9ef1b5a890be7c611558067ea0b354/google_resumable_media-2.10.2.tar.gz"
    sha256 "1de441703cd298d75a419bfdc0066e9fc7b0a1de630df96eea8ce8f5c759358c"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/4b/13/f83676de1dce4f8106bcba91725b3f3f4baf6ca1977685102b008b8e0097/googleapis_common_protos-1.75.4.tar.gz"
    sha256 "4587babdc82a8d7e5a3d4f5a6697e064bf44a598b4d08341c212b68185eadbcd"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/d6/d2/9e2af6f2482588baa596016171adcdaa6b3c3a72d8ad33bbf41f70d00c09/gpuhunt-0.1.30.tar.gz"
    sha256 "7ec5a412fca1a4e1b78611fe857eab7efc24027fad4c6d388001c61459fdd655"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/d2/d0/fa5bdd5f3f421bb68dc6dc162e9caaf942897ca41ce7255b524723c80f0b/grpc_google_iam_v1-0.14.5.tar.gz"
    sha256 "07fd3a9fafb586588e771831fbfc8f6597050181d0c3b45e039d18b8fdc1aab5"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/3f/4f/4435c0aae54657258d9cfcba78598f3d9e5fe4c82ff18d78558567b90faf/grpcio-1.84.0.tar.gz"
    sha256 "19aaf172fc2edbefccce3f6e92c5150975dbe56c45744e9e87cf72ebdf85bfbe"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/52/45/f80309cdb6a7dbf8f65e2082dd2ddc9797ba7180516a73c54d966ba632c4/grpcio_status-1.84.0.tar.gz"
    sha256 "5caf28ba7184b81f618b5f7f094859fd2541bf429d2189bbbcd715c9c2cdcee2"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/84/f5/ccf58de92d61e3ad921119668f54ed36ca1d0cf5dcc5c1657dfb164fd78b/httplib2-0.32.0.tar.gz"
    sha256 "48a0ef30a42db65d8f3399045e1d09ab0ba66e3b9efc360d07f80ea55d286025"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/43/e5/d471fcb0e14523fe1c3f4ba58ca52480e7bd70ad7109a3846bc75892f7fb/httptools-0.8.0.tar.gz"
    sha256 "6b2a32f18d97e16e90827d7a819ffa8dbd8cc245fc4e1fa9d1095b54ef4bd999"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/7b/79/39bfb3743a176742c9075be3b7b12b4ec7100bb4cae13448b1839fb0d9df/ignore_python-0.4.1.tar.gz"
    sha256 "dbd8a009d554b86c600f7b5cb180a126813ebf485c08d7ae05bcf9754fc25073"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/85/747d28986a44b715cc51cf57aa021c8fd94e9614064261ceec77320e8b0b/msal-1.39.0.tar.gz"
    sha256 "6ab7de335e6d7f5717e2c7e1dbf86e4dda2f6acf3c56773b78dc53ebc6395b5f"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/7a/d8/a1bcc8ba112a627f8ffbdc212a78ce18d3ac07e91a5ca65d27918eee25a1/oauthlib-4.0.0.tar.gz"
    sha256 "efb274799819440f95b4ab3b818869f1ce9ae26c5beacba0201d1a1b76b54f86"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/1f/dc/e12c1fe1ed8a7b7149777127b1a0e12ce5bd5a81d97408bedc2128c260f5/opentelemetry_api-1.45.0.tar.gz"
    sha256 "711ede81773c8025c2c03dac0450bc89f3d30aea6eabcc815c570d4e35a963f7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/62/93/dcc25d52f49022ae6175d15e6bd751f1acc99b98bc61fc55e5155a7be2e7/paramiko-5.0.0.tar.gz"
    sha256 "36763b5b95c2a0dcfdf1abc48e48156ee425b21efe2f0e787c2dd5a95c0e5e79"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/52/73/f1334c29c2af4cd9dba6c7817e61b611bd0215e2eb5565c6064a4de18802/prometheus_client-0.26.0.tar.gz"
    sha256 "04a91bcf94e2cf74a44a1a874d651a2e853ed354b6e822f3b7487751465d5c2b"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/40/a6/4fbadcc2044034449b3f8f0ce82dcf3005d53f37c136642103fd4836a31c/proto_plus-1.28.4.tar.gz"
    sha256 "5ff7ecad828e032a491fcb86947801768e32237f99dd049b649965b892ae9a63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-dxf" do
    url "https://files.pythonhosted.org/packages/ed/55/4b4fd31f5e5f7dc559a36c75e98b37670d6ddbd2b6b259e3a2bc8694cc2f/python_dxf-12.1.1.tar.gz"
    sha256 "2f5fd883599f8553872e1f7a67b8d278744ab574f55feb9790c93a347520dd9d"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/21/25/5473e46b179f8e8b4ad3aeeb36773d1701b7770eaf5e5bc2025c7303b598/python_json_logger-4.2.0.tar.gz"
    sha256 "e371ebe22ec01e289850102091a2b1f6fc9e655c7f1f5f29073936756c290afa"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/22/80/44636b363e75af7f5e6ac0571137466fec66e47016179139d0019a453ab7/requests_unixsocket-0.4.1.tar.gz"
    sha256 "b2596158c356ecee68d27ba469a52211230ac6fb0cde8b66afb19f0ed47a1995"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/6a/e5/1064c43203a357d668cd42435f7a15fe6af51512d85b2104fecb937aa861/rich_argparse-1.8.0.tar.gz"
    sha256 "679df3d832fa94ad6e4bdb07ded088cd7ea2dddc58ae9b2b46346a40b06cbc0c"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/67/93/9ef70bfb7346c778caf09b7cd10c17c33f601f2d17019fa1aedcda738b5f/sentry_sdk-2.71.0.tar.gz"
    sha256 "7beb27a22f06396f3a05510c3da6ea10e1c79e02e859993c27ce4ff074e296d6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smg-grpc-proto" do
    url "https://files.pythonhosted.org/packages/66/e0/a8c0499bb4fbfebe4ff51ec674ded489cccbcf243f7f9e2ca09a45838608/smg_grpc_proto-0.4.9.tar.gz"
    sha256 "ea54704ab92452d9ce13371dc65234799bfd18cc1fcd6806a9d0c3e23e149d20"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/a8/cb/7c68da82239ffae9378eca076afe14c310e17a4f01e3d315112f266e26c7/sqlalchemy-2.1.1.tar.gz"
    sha256 "fcf3cbb33bb23bad75d2150157c21804618745731e9931ab27e61879a9f6123b"
  end

  resource "sqlalchemy-utils" do
    url "https://files.pythonhosted.org/packages/0f/7d/eb9565b6a49426552a5bf5c57e7c239c506dc0e4e5315aec6d1e8241dc7c/sqlalchemy_utils-0.42.1.tar.gz"
    sha256 "881f9cd9e5044dc8f827bccb0425ce2e55490ce44fc0bb848c55cc8ee44cc02e"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/7b/2b/3850dc6bf7ef71b088962eba31dafc6cffd2f96e577ebb0bb316df96da3e/starlette-1.7.0.tar.gz"
    sha256 "c79f74ea63cff761804fbbfb182f1e0b440c2d07b164d24700c5a1bab5d6ff5d"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/b3/68/e6aa0b77d217b31f8f486ec0cdfe5e00e6e38dc0be657e7d85819b9faf0a/watchfiles-1.3.0.tar.gz"
    sha256 "99aee4a07847c06820765fd7b1b49ceac4f3f711ccb7d104655a33231de1c207"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/dc/ac/3a943d2792c9bb368aaa8b50121c0f778460ba2d7fbdc0a0366201d9e761/wcwidth-0.9.1.tar.gz"
    sha256 "5823209b0d43af322ce698c689380d7c15ca31fa8e6e3be8459f27031bef0af5"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/d8/cb/a5abcc2891249f393827c650c6296660ce40374ac22d99ab9aea41f9d2a2/websocket_client-1.9.2.tar.gz"
    sha256 "0fcb57545848be86992e128218fd96dd87a6769ffdb1a968dff79632b85604d0"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/18/72/fba934cb3dff7a85d811820efffcd141ddd52b5a2a01637f64551373ff4d/websockets-17.1.tar.gz"
    sha256 "acfea4c20bf54384883ea33b1240fc1db4f52e190823a4e2b334bc3e8bfca96a"
  end

  resource "www-authenticate" do
    url "https://files.pythonhosted.org/packages/a7/2d/5567291a8274ef5d9b6495a1ec341394ab68933e2396936755b157f87b43/www-authenticate-0.9.2.tar.gz"
    sha256 "cf75fc2ea5effb0f9342d7de7619b736f2a7d4b223331a53e296863a286e9dcb"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dstack", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dstack --version")
    expected = "Git repo not found:"
    assert_match expected, shell_output("#{bin}/dstack init 2>&1", 1)
  end
end