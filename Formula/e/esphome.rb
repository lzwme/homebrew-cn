class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32ESP8266 super easy"
  homepage "https:github.comesphomeesphome"
  url "https:files.pythonhosted.orgpackages037abb283a36282e9ab6daa0a876eac70b9200853b820a7f981c7750b3c9aeddesphome-2025.6.0.tar.gz"
  sha256 "a8aa51e18853f00d03135f93d93238d9c133b5ca2600985a8e3cf5ccde1f92b5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fccd00db6bda7443a11cf3069392bc664aa75d728f0ea6fa139db5997288b82f"
    sha256 cellar: :any,                 arm64_sonoma:  "ff87e85d7943817538ffe8e27fbaac02c593157272c9403af1ff894fb0187827"
    sha256 cellar: :any,                 arm64_ventura: "f26eac2d46e417469a06b5e55835c41ca8e5840ba090751703b97405118b9b99"
    sha256 cellar: :any,                 sonoma:        "42f45336fa0a29efadc3ca5c46d025588115595f33be6b8cf91a4af6acb51840"
    sha256 cellar: :any,                 ventura:       "6b9c1da3a363381160165544f373466f4ca14a6eedeaff20f38cf103da59b547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0c6b8296a426d6bc136b4397eb3274875ba2fedcbd45d4150513c16d33e58ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d61783338578045dbbc969129249f5617394cf8504e35b42f08e169f481f4d"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "aioesphomeapi" do
    url "https:files.pythonhosted.orgpackagesf89df680cd706a14274cfb2ecd555090418ba97869b9dbf6a608b2bf6ddb060aaioesphomeapi-32.2.3.tar.gz"
    sha256 "5262473190edf7390ea43c4be972f432e9e695022e675e6ef05bde4d645d27cc"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "ajsonrpc" do
    url "https:files.pythonhosted.orgpackagesda5c95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages160f861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "async-interrupt" do
    url "https:files.pythonhosted.orgpackages5679732a581e3ceb09f938d33ad8ab3419856181d95bb621aa2441a10f281e10async_interrupt-1.2.2.tar.gz"
    sha256 "be4331a029b8625777905376a6dc1370984c8c810f30b79703f3ee039d262bf7"
  end

  resource "bitarray" do
    url "https:files.pythonhosted.orgpackagesb80d15826c7c2d49a4518a1b24b0d432f1ecad2e0b68168f942058b5de498498bitarray-3.4.2.tar.gz"
    sha256 "78ed2b911aabede3a31e3329b1de8abdc8104bd5e0545184ddbd9c7f668f4059"
  end

  resource "bitstring" do
    url "https:files.pythonhosted.orgpackages15a8a80c890db75d5bdd5314b5de02c4144c7de94fd0cefcae51acaeb14c6a3fbitstring-4.3.1.tar.gz"
    sha256 "a08bc09d3857216d4c0f412a1611056f1cc2b64fd254fb1e8a0afba7cfa1a95a"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackages7a71cca6167c06d00c81375fd668719df245864076d284f7cb46a694cbeb5454bottle-0.13.4.tar.gz"
    sha256 "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"
  end

  resource "cairocffi" do
    url "https:files.pythonhosted.orgpackages70c51a4dc131459e68a173cbdab5fad6b524f53f9c1ef7861b7698e998b837cccairocffi-1.7.1.tar.gz"
    sha256 "2e48ee864884ec4a3a34bfa8c9ab9999f688286eb714a15a43ec9d068c36557b"
  end

  resource "cairosvg" do
    url "https:files.pythonhosted.orgpackagesabb95106168bd43d7cd8b7cc2a2ee465b385f14b63f4c092bb89eee2d48c8e67cairosvg-2.8.2.tar.gz"
    sha256 "07cbf4e86317b27a92318a4cac2a4bb37a5e9c1b8a27355d06874b22f85bef9f"
  end

  resource "chacha20poly1305-reuseable" do
    url "https:files.pythonhosted.orgpackagesc1ff6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6bchacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssselect2" do
    url "https:files.pythonhosted.orgpackages9f86fd7f58fc498b3166f3a7e8e0cddb6e620fe1da35b02248b1bd59e95dbaaacssselect2-0.8.0.tar.gz"
    sha256 "7674ffb954a3b46162392aee2a3a0aedb2e14ecf99fcc28644900f4e6e3e9d3a"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackagesc01f924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46aecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
  end

  resource "esphome-dashboard" do
    url "https:files.pythonhosted.orgpackages83d1116f6633fe60449479cd38812ee00113eb8e4581aea0828afbed01bedc80esphome_dashboard-20250514.0.tar.gz"
    sha256 "b881e95bfe0911992eb968f8f44f99321af0e67e4761dbc4db3ebf15dda49e99"
  end

  resource "esphome-glyphsets" do
    url "https:files.pythonhosted.orgpackagesa8d0a90161d91647d7d8c46bd9394d6cf4c712afe513629bdbeaaa2e2cef5ae4esphome_glyphsets-0.2.0.tar.gz"
    sha256 "f68523dabd1960659d1b0d5d2d39e0bf002885228bd494fb8ed857302297d95c"
  end

  resource "esptool" do
    url "https:files.pythonhosted.orgpackages5c6b3ce9bb7f36bdef3d6ae71646a1d3b7d59826a478f3ed8a783a93a2f8f537esptool-4.8.1.tar.gz"
    sha256 "dc4ef26b659e1a8dcb019147c0ea6d94980b34de99fbe09121c7941c8b254531"
  end

  resource "freetype-py" do
    url "https:files.pythonhosted.orgpackagesd09c61ba17f846b922c2d6d101cc886b0e8fb597c109cedfcb39b8c5d2304b54freetype-py-2.5.1.zip"
    sha256 "cfe2686a174d0dd3d71a9d8ee9bf6a2c23f5872385cf8ce9f24af83d076e2fbd"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
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
    url "https:files.pythonhosted.orgpackagesab5e5e53d26b42ab75491cda89b871dab9e97c840bf12c63ec58a1919710cd06marshmallow-3.26.1.tar.gz"
    sha256 "e6d8affb6cb61d39d26402096dc0aee12d5a26d490a121f118d2e81dc0719dc6"
  end

  resource "noiseprotocol" do
    url "https:files.pythonhosted.orgpackages7617fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paho-mqtt" do
    url "https:files.pythonhosted.orgpackagesf8dd4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "platformio" do
    url "https:files.pythonhosted.orgpackages2fc5ba3c1ba120b0466bb621615e4075a5c4752400c6adbf2a15edd91b9aefe9platformio-6.1.18.tar.gz"
    sha256 "6ea19c66fba3c5272378afa6ae11abbf883243dd8e503ac5f4ff8ac277ccc7c6"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages52f3b9655a711b32c19720253f6f06326faf90580834e2e83f840472d752bc8bprotobuf-6.31.1.tar.gz"
    sha256 "d8cac4c982f0b957a4dc73a80e2ea24fab08e679c0de9deb835f4a12d69aca9a"
  end

  resource "puremagic" do
    url "https:files.pythonhosted.orgpackagesd6dec9dbb741a2e0e657147c6125699e4a2a3b9003840fed62528e17c87c0989puremagic-1.29.tar.gz"
    sha256 "67c115db3f63d43b13433860917b11e2b767e5eaec696a491be2fb544f224f7a"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackagesb9ab33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071afpyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
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
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages39876da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages208480203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
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
    url "https:files.pythonhosted.orgpackagesce2008dfcd9c983f6a6f4a1000d934b9e6d626cff8d2eeb77a89a68eef20a2b7starlette-0.46.2.tar.gz"
    sha256 "7f7361f34eed179294600af672f565727419830b54b7b084efe44bb82d2fccd5"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tinycss2" do
    url "https:files.pythonhosted.orgpackages7afd7a5ee21fd08ff70d3d33a5781c255cbe779659bd03278feb98b19ee550f4tinycss2-1.4.0.tar.gz"
    sha256 "10c0972f6fc0fbee87c3edb76549357415e94548c1ae10ebccdea16fb404a9b7"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackages5189c72771c81d25d53fe33e3dca61c233b665b2780f21820ba6fd2c6793c12btornado-6.5.1.tar.gz"
    sha256 "84ceece391e8eb9b2b95578db65e920d2a61070260594819589609ba9bc6308c"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages95321a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages8b2ec14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackagesdead713be230bcda622eaa35c28f0d328c3675c371238470abdea52417f17a8euvicorn-0.34.3.tar.gz"
    sha256 "35919a9a979d7a59334b6b10e05d77c1d0d574c50e0fc98b8b1a0f165708b55a"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackages91afa54ce0fb6f1d867e0b9f0efe5f082a691f51ccf705188fca67a3ecefd7f4voluptuous-0.15.2.tar.gz"
    sha256 "6ffcab32c4d3230b4d2af3a577c87e1908a714a11f6f95570456b1849b0279aa"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zeroconf" do
    url "https:files.pythonhosted.orgpackagese278f681afade2a4e7a9ade696cf3d3dcd9905e28720d74c16cafb83b5dd5c0azeroconf-0.147.0.tar.gz"
    sha256 "f517375de6bf2041df826130da41dc7a3e8772176d3076a5da58854c7d2e8d7a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec"binregister-python-argcomplete", "esphome",
                                         shell_parameter_format: :arg)
  end

  test do
    (testpath"test.yaml").write <<~YAML
      esphome:
        name: test
      esp8266:
        board: d1
    YAML

    assert_includes shell_output("#{bin}esphome config #{testpath}test.yaml 2>&1"), "INFO Configuration is valid!"
    return if Hardware::CPU.arm?

    ENV.remove_macosxsdk if OS.mac?
    system bin"esphome", "compile", "test.yaml"
  end
end