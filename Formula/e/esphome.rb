class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32ESP8266 super easy"
  homepage "https:github.comesphomeesphome"
  url "https:files.pythonhosted.orgpackages32124bc0549c90097b9b875a72dc31d5c87d194a9de2ab74d1009c7e3621c2daesphome-2025.4.0.tar.gz"
  sha256 "cd2331512dc54229b4371a9f5a8848b696355c18dc24e860d36595dc4af6d802"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dbaf734b115cfdf4eedc79a0b9e1f7e6a77c211013f28b16e4717b18dc76c4c3"
    sha256 cellar: :any,                 arm64_sonoma:  "f3e0e170a82f157c963adbf8af86549268e0be0d7def9b0ae3fab1252f8de563"
    sha256 cellar: :any,                 arm64_ventura: "433c8232b4d8613637bb9df659074deb8116f209271d7460b1f1496215298f0c"
    sha256 cellar: :any,                 sonoma:        "3075d2843dac2e6d993cde9b5bf73ffa51f05aff5deaf91210bd6745952c9a5d"
    sha256 cellar: :any,                 ventura:       "e6219b5ed4b4bf0cf87557c4d748d87fd12eab7fd60081a70bbf42d225e9c0b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f7ae0c57a1191e96e5c43087b90e55eb3177817a262c573e1a0b6075adab874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3eba5192cea12fad28c7a0d0da61b49d4d7d157f7f211601c5d3eb936cf51f5"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "aioesphomeapi" do
    url "https:files.pythonhosted.orgpackagese393973650f52265d5c367761fa61e16a9c87c69059dacb584b5ad7049176149aioesphomeapi-29.10.0.tar.gz"
    sha256 "bb89b1d0c63c7f7ea767d22f43eeb3828101ef7905a56ffc1347d90581a14931"
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
    url "https:files.pythonhosted.orgpackagesf16ee3877eebb83e3e9d22b6089be7b8c098d3d09b2195a9570d6d9049e90d5bbitarray-3.3.1.tar.gz"
    sha256 "8c89219a672d0a15ab70f8a6f41bc8355296ec26becef89a127c1a32bb2e6345"
  end

  resource "bitstring" do
    url "https:files.pythonhosted.orgpackages15a8a80c890db75d5bdd5314b5de02c4144c7de94fd0cefcae51acaeb14c6a3fbitstring-4.3.1.tar.gz"
    sha256 "a08bc09d3857216d4c0f412a1611056f1cc2b64fd254fb1e8a0afba7cfa1a95a"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesf53befa9540213c71be3500e14592c5823bd3f9ddd881d306e01b5dd490ddab5bottle-0.13.3.tar.gz"
    sha256 "1c23aeb30aa8a13f39c60c0da494530ddd5de3da235bc431b818a50d999de49f"
  end

  resource "chacha20poly1305-reuseable" do
    url "https:files.pythonhosted.orgpackagesc1ff6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6bchacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackagesc01f924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46aecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
  end

  resource "esphome-dashboard" do
    url "https:files.pythonhosted.orgpackages1b7d9c2117e64696366db2fd8bec9f7682fb7be6eea40100a25cc8e52e121551esphome_dashboard-20250415.0.tar.gz"
    sha256 "c751e8ee7fa24db7ef020acead25393c56c3284590220cd9e55669abe662e75b"
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
    url "https:files.pythonhosted.orgpackagesc88ccf2ac658216eebe49eaedf1e06bc06cbf6a143469236294a1171a51357c3protobuf-6.30.2.tar.gz"
    sha256 "35c859ae076d8c56054c25b59e5e59638d86545ed6e2b6efac6be0b6ea3ba048"
  end

  resource "puremagic" do
    url "https:files.pythonhosted.orgpackages092d40599f25667733e41bbc3d7e4c7c36d5e7860874aa5fe9c584e90b34954dpuremagic-1.28.tar.gz"
    sha256 "195893fc129657f611b86b959aab337207d6df7f25372209269ed9e303c1a8c0"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesea46f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
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

  resource "tornado" do
    url "https:files.pythonhosted.orgpackages5945a0daf161f7d6f36c3ea5fc0c2de619746cc3dd4c76402e9db545bd920f63tornado-6.4.2.tar.gz"
    sha256 "92bad5b4746e9879fd7bf1eb21dce4e3fc5128d71601f80005afa39237ad620b"
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
    url "https:files.pythonhosted.orgpackagesa6ae9bbb19b9e1c450cf9ecaef06463e40234d98d95bf572fab11b4f19ae5deduvicorn-0.34.2.tar.gz"
    sha256 "0e929828f6186353a80b58ea719861d2629d766293b6d19baf086ba31d4f3328"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackages91afa54ce0fb6f1d867e0b9f0efe5f082a691f51ccf705188fca67a3ecefd7f4voluptuous-0.15.2.tar.gz"
    sha256 "6ffcab32c4d3230b4d2af3a577c87e1908a714a11f6f95570456b1849b0279aa"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zeroconf" do
    url "https:files.pythonhosted.orgpackages853d872026a00b364f74144a8103f036fb23562e94461295ecbc7b10783f14b9zeroconf-0.146.5.tar.gz"
    sha256 "e2907ce4c12b02c0e05082f3e0fce75cbac82deecb53c02ce118d50a594b48a5"
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