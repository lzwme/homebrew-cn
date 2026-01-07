class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32/ESP8266 super easy"
  homepage "https://github.com/esphome/esphome"
  url "https://files.pythonhosted.org/packages/5f/34/bf5a8b06ad5d8c300a090126043e35b770ab439dec51660574a881d3d930/esphome-2025.12.5.tar.gz"
  sha256 "6bcf05efc74a430f2a73be69bc853723269fb953e341047fe41f8ee0c5e023e1"
  license "MIT"

  # Issue ref: https://github.com/Homebrew/homebrew-core/issues/257992
  no_autobump! because: "macOS resources cannot be updated on linux CI"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c7597b38889c90454ba9d6c4bd1dfb3dccee4fa0770aea561384fc3c1e12265"
    sha256 cellar: :any,                 arm64_sequoia: "01bb0a2bc1f9aec10dd13714a818b0c22a357a628bc5def751ee1af8048c0067"
    sha256 cellar: :any,                 arm64_sonoma:  "1ce3dccfd171be471ab27a0b663cd4753994dfcb145286c7ab768c6aad585c79"
    sha256 cellar: :any,                 sonoma:        "66bc1ed212a88d679e5b53d9bfb6a31e041f7d9b32de54d8626d09ed0de93472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf739eaa3a62b89f49715226873f808bf377a31a9f68c39409387f6eb28835f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80da80ea1ccb8bab741fd4eec80cd47352a4ca0f92399fb233af2c4342355de9"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.13" # <3.14 was added by upstream due to https://github.com/esphome/esphome/issues/11502

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  pypi_packages exclude_packages: %w[certifi cryptography pillow],
                extra_packages:   %w[chardet dbus-fast pyobjc-framework-corebluetooth pyobjc-framework-libdispatch]

  resource "aioesphomeapi" do
    url "https://files.pythonhosted.org/packages/a9/44/2f94e51314fe07f6d2a2afa64b003f9defa47a8dd41e88f01bc88f8f9188/aioesphomeapi-43.10.1.tar.gz"
    sha256 "98bf21d22de4f66f45a48b4a79dd18169707603ccbe2fbf9496ead409faff53b"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "async-interrupt" do
    url "https://files.pythonhosted.org/packages/56/79/732a581e3ceb09f938d33ad8ab3419856181d95bb621aa2441a10f281e10/async_interrupt-1.2.2.tar.gz"
    sha256 "be4331a029b8625777905376a6dc1370984c8c810f30b79703f3ee039d262bf7"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/95/06/92fdc84448d324ab8434b78e65caf4fb4c6c90b4f8ad9bdd4c8021bfaf1e/bitarray-3.8.0.tar.gz"
    sha256 "3eae38daffd77c9621ae80c16932eea3fb3a4af141fb7cc724d4ad93eff9210d"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/15/a8/a80c890db75d5bdd5314b5de02c4144c7de94fd0cefcae51acaeb14c6a3f/bitstring-4.3.1.tar.gz"
    sha256 "a08bc09d3857216d4c0f412a1611056f1cc2b64fd254fb1e8a0afba7cfa1a95a"
  end

  resource "bleak" do
    url "https://files.pythonhosted.org/packages/45/8a/5acbd4da6a5a301fab56ff6d6e9e6b6945e6e4a2d1d213898c21b1d3a19b/bleak-2.1.1.tar.gz"
    sha256 "4600cc5852f2392ce886547e127623f188e689489c5946d422172adf80635cf9"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/7a/71/cca6167c06d00c81375fd668719df245864076d284f7cb46a694cbeb5454/bottle-0.13.4.tar.gz"
    sha256 "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"
  end

  resource "cairocffi" do
    url "https://files.pythonhosted.org/packages/70/c5/1a4dc131459e68a173cbdab5fad6b524f53f9c1ef7861b7698e998b837cc/cairocffi-1.7.1.tar.gz"
    sha256 "2e48ee864884ec4a3a34bfa8c9ab9999f688286eb714a15a43ec9d068c36557b"
  end

  resource "cairosvg" do
    url "https://files.pythonhosted.org/packages/ab/b9/5106168bd43d7cd8b7cc2a2ee465b385f14b63f4c092bb89eee2d48c8e67/cairosvg-2.8.2.tar.gz"
    sha256 "07cbf4e86317b27a92318a4cac2a4bb37a5e9c1b8a27355d06874b22f85bef9f"
  end

  resource "chacha20poly1305-reuseable" do
    url "https://files.pythonhosted.org/packages/c1/ff/6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6b/chacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/9f/86/fd7f58fc498b3166f3a7e8e0cddb6e620fe1da35b02248b1bd59e95dbaaa/cssselect2-0.8.0.tar.gz"
    sha256 "7674ffb954a3b46162392aee2a3a0aedb2e14ecf99fcc28644900f4e6e3e9d3a"
  end

  resource "dbus-fast" do
    url "https://files.pythonhosted.org/packages/16/a4/e54607cf8b0a696beba591f1a543cff5b6a9e4b4f842fd55f7ba741d678d/dbus_fast-3.1.2.tar.gz"
    sha256 "6c9e1b45e4b5e7df0c021bf1bf3f27649374e47c3de1afdba6d00a7d7bba4b3a"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "esphome-dashboard" do
    url "https://files.pythonhosted.org/packages/27/10/a1c075b1d5f5ed43f4170b253f738ba732b3b74a0105f1866c8fb235bfeb/esphome_dashboard-20251013.0.tar.gz"
    sha256 "07fe21ea17f882f5f0e19786f16a95436b994094a13a692a7b22d148801a3c11"
  end

  resource "esphome-glyphsets" do
    url "https://files.pythonhosted.org/packages/a8/d0/a90161d91647d7d8c46bd9394d6cf4c712afe513629bdbeaaa2e2cef5ae4/esphome_glyphsets-0.2.0.tar.gz"
    sha256 "f68523dabd1960659d1b0d5d2d39e0bf002885228bd494fb8ed857302297d95c"
  end

  resource "esptool" do
    url "https://files.pythonhosted.org/packages/c2/03/d7d79a77dd787dbe6029809c5f81ad88912340a131c88075189f40df3aba/esptool-5.1.0.tar.gz"
    sha256 "2ea9bcd7eb263d380a4fe0170856a10e4c65e3f38c757ebdc73584c8dd8322da"
  end

  resource "freetype-py" do
    url "https://files.pythonhosted.org/packages/d0/9c/61ba17f846b922c2d6d101cc886b0e8fb597c109cedfcb39b8c5d2304b54/freetype-py-2.5.1.zip"
    sha256 "cfe2686a174d0dd3d71a9d8ee9bf6a2c23f5872385cf8ce9f24af83d076e2fbd"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "icmplib" do
    url "https://files.pythonhosted.org/packages/6d/78/ca07444be85ec718d4a7617f43fdb5b4eaae40bc15a04a5c888b64f3e35f/icmplib-3.0.4.tar.gz"
    sha256 "57868f2cdb011418c0e1d5586b16d1fabd206569fe9652654c27b6b2d6a316de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/bc/34/55d47aab1ef03fb5aab96257a31acfc58791d274cf86c044e6e75e6d3bfe/marshmallow-4.2.0.tar.gz"
    sha256 "908acabd5aa14741419d3678d3296bda6abe28a167b7dcd05969ceb8256943ac"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "noiseprotocol" do
    url "https://files.pythonhosted.org/packages/76/17/fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95/noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/39/15/0a6214e76d4d32e7f663b109cf71fb22561c2be0f701d67f93950cd40542/paho_mqtt-2.1.0.tar.gz"
    sha256 "12d6e7511d4137555a3f6ea167ae846af2c7357b10bc6fa4f7c3968fc1723834"
  end

  resource "platformio" do
    url "https://files.pythonhosted.org/packages/2f/c5/ba3c1ba120b0466bb621615e4075a5c4752400c6adbf2a15edd91b9aefe9/platformio-6.1.18.tar.gz"
    sha256 "6ea19c66fba3c5272378afa6ae11abbf883243dd8e503ac5f4ff8ac277ccc7c6"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/34/44/e49ecff446afeec9d1a66d6bbf9adc21e3c7cea7803a920ca3773379d4f6/protobuf-6.33.2.tar.gz"
    sha256 "56dc370c91fbb8ac85bc13582c9e373569668a290aa2e66a590c2a0d35ddb9e4"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/b9/ab/33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071af/pyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "pyobjc-framework-corebluetooth" do
    url "https://files.pythonhosted.org/packages/4b/25/d21d6cb3fd249c2c2aa96ee54279f40876a0c93e7161b3304bf21cbd0bfe/pyobjc_framework_corebluetooth-12.1.tar.gz"
    sha256 "8060c1466d90bbb9100741a1091bb79975d9ba43911c9841599879fc45c2bbe0"
  end

  resource "pyobjc-framework-libdispatch" do
    url "https://files.pythonhosted.org/packages/26/e8/75b6b9b3c88b37723c237e5a7600384ea2d84874548671139db02e76652b/pyobjc_framework_libdispatch-12.1.tar.gz"
    sha256 "4035535b4fae1b5e976f3e0e38b6e3442ffea1b8aa178d0ca89faa9b8ecdea41"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/33/c1/1d9de9aeaa1b89b0186e5fe23294ff6517fce1bc69149185577cd31016b2/pyparsing-3.3.1.tar.gz"
    sha256 "47fad0f17ac1e2cad3de3b458570fbc9b03560aa029ed5e16ee5554da9a2251c"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/6b/d1/b60ca6a8745e76800b50c7ee246fd73f08a3be5d8e0b551fc93c19fa1203/rich_click-1.9.5.tar.gz"
    sha256 "48120531493f1533828da80e13e839d471979ec8d7d0ca7b35f86a1379cc74b6"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/ea/97/60fda20e2fb54b83a61ae14648b0817c8f5d84a3821e40bfbdae1437026a/ruamel_yaml_clib-0.2.15.tar.gz"
    sha256 "46e4cc8c43ef6a94885f72512094e482114a8a706d3c555a34ed4b0d20200600"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/ba/b8/73a0e6a6e079a9d9cfa64113d771e421640b6f679a52eeb9b32f72d871a1/starlette-0.50.0.tar.gz"
    sha256 "a2a17b22203254bcbc2e1f926d2d55f3f9497f769416b3190768befe598fa3ca"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/a3/ae/2ca4913e5c0f09781d75482874c3a95db9105462a92ddd303c7d285d3df2/tinycss2-1.5.1.tar.gz"
    sha256 "d339d2b616ba90ccce58da8495a78f46e55d4d25f9fd71dfd526f07e7d53f957"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/37/1d/0a336abf618272d53f62ebe274f712e213f5a03c0b2339575430b8362ef2/tornado-6.5.4.tar.gz"
    sha256 "a22fa9047405d03260b483980635f0b041989d8bcc9a313f8fe18b411d84b1d7"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c3/d1/8f3c683c9561a4e6689dd3b1d345c815f10f86acd044ee1fb9a4dcd0b8c5/uvicorn-0.40.0.tar.gz"
    sha256 "839676675e87e73694518b5574fd0f24c9d97b46bea16df7b8c05ea1a51071ea"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/92/f4/0738e6849858deae22218be3bbb8207ba83a96e9d0ec7e8e8cd67b30e5ca/voluptuous-0.16.0.tar.gz"
    sha256 "006535e22fed944aec17bef6e8725472476194743c87bd233e912eb463f8ff05"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c7/79/12135bdf8b9c9367b8701c2c19a14c913c120b882d50b014ca0d38083c2c/wsproto-1.3.2.tar.gz"
    sha256 "b86885dcf294e15204919950f666e06ffc6c7c114ca900b060d6e16293528294"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/67/46/10db987799629d01930176ae523f70879b63577060d63e05ebf9214aba4b/zeroconf-0.148.0.tar.gz"
    sha256 "03fcca123df3652e23d945112d683d2f605f313637611b7d4adf31056f681702"
  end

  def install
    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      # pyobjc-core uses "-fdisable-block-signature-string" introduced in clang 17
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699
    end

    without = if OS.mac?
      ["dbus-fast"]
    else
      %w[chardet pyobjc-core pyobjc-framework-cocoa pyobjc-framework-corebluetooth pyobjc-framework-libdispatch]
    end

    virtualenv_install_with_resources(without:)

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "esphome",
                                         shell_parameter_format: :arg)
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      esphome:
        name: test
      esp8266:
        board: d1
    YAML

    assert_includes shell_output("#{bin}/esphome config #{testpath}/test.yaml 2>&1"), "INFO Configuration is valid!"
    return if Hardware::CPU.arm?

    ENV.remove_macosxsdk if OS.mac?
    system bin/"esphome", "compile", "test.yaml"
  end
end