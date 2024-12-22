class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32ESP8266 super easy"
  homepage "https:github.comesphomeesphome"
  url "https:files.pythonhosted.orgpackagesfbfbd861cb0818cec435c9481d28d7879388f9d0d3a3576e394b3f1b96a85636esphome-2024.12.2.tar.gz"
  sha256 "681ce7eadf23584f16817f6461645c908a10b3a9940bd6bb49ae44dea1760122"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5cac3b96be3be4b7cdc2bc0128df3e06ca37e876d9d9b6d0980d15c4d47eea30"
    sha256 cellar: :any,                 arm64_sonoma:  "c14d3fcae318ce7bb94fbb569221f38d218352b4bb0424f65925bc0d65007154"
    sha256 cellar: :any,                 arm64_ventura: "558e8b8227ac075acdad3569948b676694b4f763f1c3b69feeb71a1d9b9e8bd7"
    sha256 cellar: :any,                 sonoma:        "a8b094d0e234d5da8666d9e1823f1880bb2f2c3e559ee173acd609e5afc879c3"
    sha256 cellar: :any,                 ventura:       "8a1942edcc5305c816d36996f8dc569e926b5c83660344812e5c80673388bdd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d734b6e6316550ce8698c4e3b4044b539bb99488520723b552645f3ffccda9"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmagic"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libyaml"
  depends_on "little-cms2"
  depends_on "pillow"
  depends_on "python-setuptools"
  depends_on "python@3.13"
  depends_on "webp"

  uses_from_macos "zlib"

  resource "aioesphomeapi" do
    url "https:files.pythonhosted.orgpackages894de5b6826e7256abc0783876a382797fd26b632b860eecc61698abb46a52caaioesphomeapi-24.6.2.tar.gz"
    sha256 "dfde91df6b115cddac95d82ca968847a7f726b2a0d0ecef6cee8c065bdbb701c"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages7f55e4373e888fdacb15563ef6fa9fa8c8252476ea071e96fb46defac9f18bf2aiohappyeyeballs-2.4.4.tar.gz"
    sha256 "5fdd7d87889c63183afc18ce9271f9b0a7d32c2303e394468dd45d514a757745"
  end

  resource "ajsonrpc" do
    url "https:files.pythonhosted.orgpackagesda5c95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesf640318e58f669b1a9e00f5c4453910682e2d9dd594334539c7b7817dabb765fanyio-4.7.0.tar.gz"
    sha256 "2f834749c602966b7d456a7567cafcb309f96482b5081d14ac93ccd457f9dd48"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7f03581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "async-interrupt" do
    url "https:files.pythonhosted.orgpackagesef7c5a2d74465037b33ccdaf830e3d9ac008bccdbe4b0657983b90dc89191626async_interrupt-1.2.0.tar.gz"
    sha256 "d147559e2478501ad45ea43f52df23b246456715a7cb96e1aebdb4b71aed43d5"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages48c86260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "bitarray" do
    url "https:files.pythonhosted.orgpackages0dc7a85f206e6b2fddb93964efe53685ad8da7d856e6975b005ed6a88f25b010bitarray-2.9.3.tar.gz"
    sha256 "9eff55cf189b0c37ba97156a00d640eb7392db58a8049be6f26ff2712b93fa89"
  end

  resource "bitstring" do
    url "https:files.pythonhosted.orgpackagesd8d0d6f57409bb50f54fe2894ec5a50b5c04cb41aa814c3bdb8a7eeb4a0f7697bitstring-4.2.3.tar.gz"
    sha256 "e0c447af3fda0d114f77b88c2d199f02f97ee7e957e6d719f40f41cf15fbb897"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackages1bfb97839b95c2a2ea1ca91877a846988f90f4ca16ee42c0bb79e079171c0c06bottle-0.13.2.tar.gz"
    sha256 "e53803b9d298c7d343d00ba7d27b0059415f04b9f6f40b8d58b5bf914ba9d348"
  end

  resource "chacha20poly1305-reuseable" do
    url "https:files.pythonhosted.orgpackagesc1ff6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6bchacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defcon" do
    url "https:files.pythonhosted.orgpackages7a9eebce8d0eec62c7e6c676bf2e2e39feeafbfe78711355df4a7e5974b2ae06defcon-0.10.3.zip"
    sha256 "56de26d7c75f164eea03e28bc11b4c769c68d705fa186dfcaeb56c27f9a4cc0c"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackages5ed0ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051becdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "esphome-dashboard" do
    url "https:files.pythonhosted.orgpackages39b577fdc0c898903de9b0601ea381653d6add51928a02b563e5548c7d5f4b62esphome_dashboard-20241217.1.tar.gz"
    sha256 "fc996c6e76dcf41af66cad79f95b8e8c2620920dc49b191a1ff3ac9e4bb2a42a"
  end

  resource "esptool" do
    url "https:files.pythonhosted.orgpackages1b8bf0d1e75879dee053874a4f955ed1e9ad97275485f51cb4bc2cb4e9b24479esptool-4.7.0.tar.gz"
    sha256 "01454e69e1ef3601215db83ff2cb1fc79ece67d24b0e5d43d451b410447c4893"
  end

  resource "fonttools" do
    url "https:files.pythonhosted.orgpackages7661a300d1574dc381393424047c0396a0e213db212e28361123af9830d71a8dfonttools-4.55.3.tar.gz"
    sha256 "3983313c2a04d6cc1fe9251f8fc647754cf49a61dac6cb1e7249ae67afaafc45"
  end

  resource "freetype-py" do
    url "https:files.pythonhosted.orgpackagesd09c61ba17f846b922c2d6d101cc886b0e8fb597c109cedfcb39b8c5d2304b54freetype-py-2.5.1.zip"
    sha256 "cfe2686a174d0dd3d71a9d8ee9bf6a2c23f5872385cf8ce9f24af83d076e2fbd"
  end

  resource "fs" do
    url "https:files.pythonhosted.orgpackages5da9af5bfd5a92592c16cdae5c04f68187a309be8a146b528eac3c6e30edbad2fs-2.4.16.tar.gz"
    sha256 "ae97c7d51213f4b70b6a958292530289090de3a7e15841e108fbe144f069d313"
  end

  resource "gflanguages" do
    url "https:files.pythonhosted.orgpackagesd247d281fde544fb23c734287b29fd24cdd5ecb6cbf7e4ff5c4b6b2a1afd5ee5gflanguages-0.7.1.tar.gz"
    sha256 "823595d53f97536a8ace884336ad51959821f0681156b486869c2b5d3b933ed1"
  end

  resource "glyphsets" do
    url "https:files.pythonhosted.orgpackages9dbed1526237e23f798e6072e552f64da19bd1afe4bf58b3b2b1e626cd6285bfglyphsets-1.0.0.tar.gz"
    sha256 "7daf96d4818865c9f53f5c4d2a6d586ff4ceb9fe1074356722f94390e2ce70b6"
  end

  resource "glyphslib" do
    url "https:files.pythonhosted.orgpackages875dc69ff84ad33983f95056dfc98e3e0d555d49a54eb5eaebea0468011e3449glyphslib-6.9.5.tar.gz"
    sha256 "e081c3514d6bc12e62e5c849e1d222ae7607ff7ed58628848a72323e88277c6f"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "icmplib" do
    url "https:files.pythonhosted.orgpackages6d78ca07444be85ec718d4a7617f43fdb5b4eaae40bc15a04a5c888b64f3e35ficmplib-3.0.4.tar.gz"
    sha256 "57868f2cdb011418c0e1d5586b16d1fabd206569fe9652654c27b6b2d6a316de"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https:files.pythonhosted.orgpackagese8acfb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "intelhex" do
    url "https:files.pythonhosted.orgpackages66371e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "kconfiglib" do
    url "https:files.pythonhosted.orgpackages868254537aeb187ade9b609af3d2988312350a7fab2ff2d3ec0230ae0410dc9ekconfiglib-13.7.1.tar.gz"
    sha256 "a2ee8fb06102442c45965b0596944f02c2a1517f092fa208ca307f3fd12a0a22"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackagesac0f33b98679f185f5ce58620595b32d4cf8e2fa5fb56d41eb463826558265c6marshmallow-3.23.2.tar.gz"
    sha256 "c448ac6455ca4d794773f00bae22c2f351d62d739929f761dce5eacb5c468d7f"
  end

  resource "noiseprotocol" do
    url "https:files.pythonhosted.orgpackages7617fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "openstep-plist" do
    url "https:files.pythonhosted.orgpackages9c36edffefa5f2f679fc7c146303c035fc18b015a1c5b7c48b5beb2d53abc2b9openstep_plist-0.4.0.tar.gz"
    sha256 "453a56cdf534c6f42d24934d2ed7f95bc77c3d1a8acbc1881a4aa061a7d601a2"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paho-mqtt" do
    url "https:files.pythonhosted.orgpackagesf8dd4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "pillow" do
    url "https:files.pythonhosted.orgpackagescd74ad3d526f3bf7b6d3f408b73fde271ec69dfac8b81341a318ce825f2b3812pillow-10.4.0.tar.gz"
    sha256 "166c1cd4d24309b30d61f79f4a9114b7b2313d7450912277855ff5dfd7cd4a06"
  end

  resource "platformio" do
    url "https:files.pythonhosted.orgpackages32a04b1d18da2668a37b28beff3ecdc934940516302565c31a4cd4e17661a285platformio-6.1.16.tar.gz"
    sha256 "79387b45ca7df9c0c51cae82b3b0a40ba78d11d87cea385db47e1033d781e959"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages555be3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bcprotobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "puremagic" do
    url "https:files.pythonhosted.orgpackagesd5cedc3a664654f1abed89d4e8a95ac3af02a2a0449c776ccea5ef9f48bde267puremagic-1.27.tar.gz"
    sha256 "7cb316f40912f56f34149f8ebdd77a91d099212d2ed936feb2feacfc7cbce2c1"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages88560f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8cd5e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "pyserial" do
    url "https:files.pythonhosted.orgpackages1e7dae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "reedsolo" do
    url "https:files.pythonhosted.orgpackagesf761a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5ereedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackages020a62fbd5697f6174041f9b4e2e377b6f383f9189b77dbb7d73d24624caca1dstarlette-0.39.2.tar.gz"
    sha256 "caaa3b87ef8518ef913dac4f073dea44e85f73343ad2bdc17941931835b2a26a"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackagesbda2ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackagese134943888654477a574a86a98e9896bae89c7aa15078ec29f490fef2f1e5384tzdata-2024.2.tar.gz"
    sha256 "7d85cc416e9382e69095b7bdf4afd9e3880418a2413feec7069d533d6b4e31cc"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages04d3c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "ufolib2" do
    url "https:files.pythonhosted.orgpackages1ee1d20226fc36ce7df772500409879c3a856f77a07ba8a5e1629449f219a656ufolib2-0.17.0.tar.gz"
    sha256 "891524052b3636a25b9a92f13f7fd8c24e15483bac96ccd0245ae947d127248b"
  end

  resource "unicodedata2" do
    url "https:files.pythonhosted.orgpackages7f3512c70556a27ad6196135ddb37030d1a989234ef41f05995a166297651a49unicodedata2-15.1.0.tar.gz"
    sha256 "cb30f189ad66482f8529a45da71b2a8841e9bd2bb376cc2933003a4a55a07648"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackages5a015e637e7aa9dd031be5376b9fb749ec20b86f5a5b6a49b87fabd374d5fa9fuvicorn-0.30.6.tar.gz"
    sha256 "4b15decdda1e72be08209e860a1e10e92439ad5b97cf44cc945fcbee66fc5788"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackagesa1ce0733e4d6f870a0e5f4dbb00766b36b71ee0d25f8de33d27fb662f29154b1voluptuous-0.14.2.tar.gz"
    sha256 "533e36175967a310f1b73170d091232bf881403e4ebe52a9b4ade8404d151f5d"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zeroconf" do
    url "https:files.pythonhosted.orgpackages247d02e8c583b57692eee495e60c7a4dd862635a9702067d69c6dd1c907cb589zeroconf-0.132.2.tar.gz"
    sha256 "9ad8bc6e3f168fe8c164634c762d3265c775643defff10e26273623a12d73ae1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.yaml").write <<~YAML
      esphome:
        name: test
        platform: ESP8266
        board: d1
    YAML

    assert_includes shell_output("#{bin}esphome config #{testpath}test.yaml 2>&1"), "INFO Configuration is valid!"
    return if Hardware::CPU.arm?

    ENV.remove_macosxsdk if OS.mac?
    system bin"esphome", "compile", "test.yaml"
  end
end