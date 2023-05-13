class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://docs.dstack.ai/"
  url "https://files.pythonhosted.org/packages/dc/10/01c67c68b283f4694c8a07b80957bf84bdab15253e7bdd1b0e9329273601/dstack-0.8.1.tar.gz"
  sha256 "2642c51ec4cf3fd6146865c99d50654be188608d052d459e5a26874b10c287cd"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fbe712d1c0e350659231fd5de6192c9609cee3d0d8aaee59624f59089935f806"
    sha256 cellar: :any,                 arm64_monterey: "f28ba77304c9f4a3f4976165050700f31e5ca8653ff9135f3f783928c1b1c917"
    sha256 cellar: :any,                 arm64_big_sur:  "21aeabd09576a29b69f424ca4f8863824107db80ffdd2b7303a238a7ef68ccfd"
    sha256 cellar: :any,                 ventura:        "f453f7553ddda0d77003f7ae1b77c9d2770798e175b06e74e472b477cb6cb221"
    sha256 cellar: :any,                 monterey:       "538bb5d6e3479b916b61dcdf14b81dbd9d92a9cf3f9cc035ec4a7615f470d4f3"
    sha256 cellar: :any,                 big_sur:        "3872529e367ac49f3d73018fb3522e04ca2d7277b6978d133ca4ac7e1f311aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aa84dd69a3efc34479e1a6ece9ed404f668f4bd6514190a160ce886e4d766a8"
  end

  # `pkg-config`, `rust`, and `openssl@1.1` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
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

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/ea/51/060efa10a814145acd4e42c6e5ed540b8714cad52ca026c5930e7c473049/aiosqlite-0.19.0.tar.gz"
    sha256 "95ee77b91c8d2808bd08a59fbebf66270e9090c3d92ffbf260dc0db0b979577d"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/14/b3/e471678c278e5f9beb9cb9b6acc2cfbb5628545d9795a9e05627f87c7e7c/alembic-1.10.4.tar.gz"
    sha256 "295b54bbb92c4008ab6a7dcd1e227e668416d6f84b98b3c4446a2bc6214a556b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/8b/94/6928d4345f2bc1beecbff03325cad43d320717f51ab74ab5a571324f4f5a/anyio-3.6.2.tar.gz"
    sha256 "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/ea/ed/f1ad88e88208c24db80dcaae7a5a339bb283956984f8fa59933d2806413a/APScheduler-3.10.1.tar.gz"
    sha256 "0293937d8f6051a0f493359440c1a1b93e882c57daf0197afeff0e727777b96e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/31/88/f2193143fcd68df2dc82f039983e6c613cdc2b9e2169d14d4c551ad24d9e/boto3-1.26.133.tar.gz"
    sha256 "8ff0af0b25266a01616396abc19eb34dc3d44bd867fa4158985924128b9034fb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/38/97/75a3c20c4de2ba12da8a8af4c52da2024488c1e12cfe6d94aec53708835b/botocore-1.29.133.tar.gz"
    sha256 "7b38e540f73c921d8cb0ac72794072000af9e10758c04ba7f53d5629cc52fa87"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
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
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/a9/7b/ec011cf46d78627159ab869556f246b5f823a6df8d94f7577e043a63fffd/fastapi-0.95.1.tar.gz"
    sha256 "9569f0a381f8a457ec479d90fa01005cfddaae07546eb1f3fa035bc4797ae7d5"
  end

  resource "file-read-backwards" do
    url "https://files.pythonhosted.org/packages/e2/0f/04d8a9877d80c26506cad53e3ff7024747e9429a5a06479c68f060948d1a/file_read_backwards-3.0.0.tar.gz"
    sha256 "512c3e534043527a8fae2a0b7151aa255f2da303e77fd40f7dcf42a1e091cc26"
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
    url "https://files.pythonhosted.org/packages/2b/15/7bafa5379a228ed72baf769eea5e6019a944469fe637ea0742c0351109bf/google-api-core-2.11.0.tar.gz"
    sha256 "4b9bb5d5a380a0befa0573b302651b8a9a89262c1730e37bf423cec511804c22"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/dd/8b/0f8678165d3136ad7637784b076c851d65d223e2e8cec3b9503540bb3518/google-auth-2.18.0.tar.gz"
    sha256 "c66b488a8b005b23ccb97b1198b6cece516c91869091ac5b7c267422db2733c7"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/a3/9f/eb72dcb7445566ed5c4e5f116c132a8d771e7c8a06404bc81f8db29e1f3b/google-cloud-appengine-logging-1.3.0.tar.gz"
    sha256 "d52f14e1e9a993797a086eff3d4772dea7908390c6ad612d26281341f17c9a49"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/b1/3d/48e8b2c0cc7113d1674526b609944ef77d7182f233b23c50fec7106b2e2c/google-cloud-audit-log-0.2.5.tar.gz"
    sha256 "86e2faba3383adc8fd04a5bd7fd4f960b3e4aedaa7ed950f2f891ce16902eb6b"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/6f/24/3f83ebbc47fa472e983bf4d78a16c3ea900953783e46a07134f711a4b42d/google-cloud-compute-1.11.0.tar.gz"
    sha256 "d1d05a4b3ec6f830bbdcc779a740e963a80d324a4fd6ef41a7c248a07cf96489"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/40/4b/f4cebb92fe965f02f4a9c06f16355cf83a61a2d5db110df9af71191c830a/google-cloud-core-2.3.2.tar.gz"
    sha256 "b9529ee7047fd8d4bf4a2182de619154240df17fbe60ead399078c1ae152af9a"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/2f/87/633774179bc73e52b172c209c89b493804b0ad8e4c6e71b547603d35a883/google-cloud-logging-3.5.0.tar.gz"
    sha256 "f11544a21ea3556f70ebac7bc338ffa8a197913834ecdd8853d176b870823aaa"
  end

  resource "google-cloud-secret-manager" do
    url "https://files.pythonhosted.org/packages/48/6b/92b705f408c1d928526b65d1259be4254ef1f45e620f01f8665156b4d781/google-cloud-secret-manager-2.16.1.tar.gz"
    sha256 "149d11ce9be7ea81d4ac3544d3fcd4c716a9edb2cb775d9c075231570b079fbb"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/fc/50/c9998f84fd8ce8799d7f8020466bbc5c9e3b1126b04a09fdb02378d451b0/google-cloud-storage-2.9.0.tar.gz"
    sha256 "9b6ae7b509fc294bdacb84d0f3ea8e20e2c54a8b4bbe39c5707635fec214eff3"
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
    url "https://files.pythonhosted.org/packages/9a/19/02a6256e00653b0fec9f356678df0ed996cb9d89aeb472c8c4df9490cac0/googleapis-common-protos-1.59.0.tar.gz"
    sha256 "4168fcb568a826a52f23510412da405abd93f4d23ba544bb68d943b14ba3cb44"
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
    url "https://files.pythonhosted.org/packages/cb/82/f4a1535e6ae5360abd59ab4e8d90a884c680a3997a44c7418364030874dd/grpcio-1.54.2.tar.gz"
    sha256 "50a9f075eeda5097aa9a182bb3877fe1272875e45370368ac0ee16ab9e22d019"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/16/9a/1ca34c80afcbc93530e50c1632ccd64b4b73da0ec455e5f2c6be889d26c8/grpcio-status-1.54.2.tar.gz"
    sha256 "3255cbec5b7c706caa3d4dd584606c080e6415e15631bb2f6215e2b70055836d"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/e8/53/e614a5b7bcc658d20e6eff6ae068863becb06bf362c2f135f5c290d8e6a2/paramiko-3.1.0.tar.gz"
    sha256 "6950faca6819acd3219d4ae694a23c7a87ee38d084f70c1724b0c0dbb8b75769"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/38/ab/d5916bd1a56dfc2c9c268effd12a635ef7bbb2c9dc9b0270da72122afabb/proto-plus-1.22.2.tar.gz"
    sha256 "0e8cda3d5a634d9895b75c573c9352c16486cb75deb0e078b5fda34db4243165"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/60/1a/79f077c5baf5a9262ed41cc0909c1230ecac5cb4f4960cd97942c88d1726/protobuf-4.23.0.tar.gz"
    sha256 "5f1eba1da2a2f3f7df469fccddef3cc060b8a16cfe3cc65961ad36b4dbcf59c5"
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
    url "https://files.pythonhosted.org/packages/43/5f/e53a850fd32dddefc998b6bfcbda843d4ff5b0dcac02a92e414ba6c97d46/pydantic-1.10.7.tar.gz"
    sha256 "cfc83c0678b6ba51b0532bea66860617c4cd4251ecf76e9846fa5a9f3454e97e"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/89/6b/2114e54b290824197006e41be3f9bbe1a26e9c39d1f5fa20a6d62945a0b3/Pygments-2.15.1.tar.gz"
    sha256 "8ace4d3c1dd481894b2005f560ead0f9f19ee64fe983366be1a21e171d12775c"
  end

  resource "pygtail" do
    url "https://files.pythonhosted.org/packages/b0/89/437120e303d5d2c81107ed3415d5f3c9975f7dfdeef9e4440cef364e3bf9/pygtail-0.14.0.tar.gz"
    sha256 "55616d31a081eaaeb069d0946f2bc7e530ebf505d4c3c050f8e941786a3449d3"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e0/69/122171604bcef06825fa1c05bd9e9b1d43bc9feb8c6c0717c42c92cc6f3c/requests-2.30.0.tar.gz"
    sha256 "239d7d4458afcb28a692cdd298d87542235f4ca8d36d03a15bfc128a6559a2f4"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/3d/0b/8dd34d20929c4b5e474db2e64426175469c2b7fea5ba71c6d4b3397a9729/rich-13.3.5.tar.gz"
    sha256 "2d11b9b8dd03868f09b4fffadc84a6a8cda574e40dc90821bd845720ebb8e89c"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/a1/00/310d8c04104ccf2dac2dd505fd66639b61a40a38e77379bfa415f235a1d0/rich_argparse-1.1.0.tar.gz"
    sha256 "6af790893d9d6a0d5160dcc1a1448e0d0923d96f7b77af5de1efd54f4bd499cc"
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
    url "https://files.pythonhosted.org/packages/28/2e/b140b8dbba463663a025bb86eff8e8dd7c840047320a5412cf3e81ecbc1e/SQLAlchemy-2.0.13.tar.gz"
    sha256 "8d97b37b4e60073c38bcf94e289e3be09ef9be870de88d163f16e08f2b9ded1a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/52/55/98746af96f57a0ff4f108c5ac84c130af3c4e291272acf446afc67d5d5d8/starlette-0.26.1.tar.gz"
    sha256 "41da799057ea8620e4667a3e69a5b1923ebd32b1819c8fa75634bbe8d8bea9bd"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/70/e5/81f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420d/tzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/39/97/b15b711a10d0774390404bec9712b2647b0b53a4da50a08acf7d7e51e284/tzlocal-4.3.tar.gz"
    sha256 "3f21d09e1b2aa9f2dacca12da240ca37de3ba5237a93addfd6d593afe9073355"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c6/dd/0d3bab50ab4ef8bec849f89fec2adc2fabcc397018c30e57d9f0d4009c5e/uvicorn-0.22.0.tar.gz"
    sha256 "79277ae03db57ce7d9aa0567830bbb51d7a612f54d6e1e3e92da3ef24c2c8ed8"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8b/94/696484b0c13234c91b316bc3d82d432f9b589a9ef09d016875a31c670b76/websocket-client-1.5.1.tar.gz"
    sha256 "3f09e6d8230892547132177f575a4e3e73cfdf06526e20cc02aa1c3b47184d40"
  end

  resource "workflows.json" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/dstackai/dstack/e0014b9eea73014bff7f4d87688839bd8504adcc/cli/dstack/schemas/workflows.json"
    sha256 "38cf87e5b1cd73c7e6d5ff5e43a6e793a7fad90c904b628b75a1013de52d9ab0"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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