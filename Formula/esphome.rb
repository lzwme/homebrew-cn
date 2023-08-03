class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32/ESP8266 super easy"
  homepage "https://github.com/esphome/esphome"
  url "https://files.pythonhosted.org/packages/94/0e/277c873ec8e747532934c83cb7767378b92f617835782d5eacb816fd80d4/esphome-2023.7.1.tar.gz"
  sha256 "5ddcd3dffa5e5332a21ad3700a11987c8a129d0d61d4fda4fc46bb5343ee8a9d"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b1f593f5608a8fc8f7d298451238b235a3875558042d9cc4d7922e7a96b2919"
    sha256 cellar: :any,                 arm64_monterey: "b501341234ef8d6169770d89399591ac67941b19684690b4d3eaf36e3317b2f4"
    sha256 cellar: :any,                 arm64_big_sur:  "62e80b5144015779a3647e59839216171001612b0309fe718f2e2fd068d38500"
    sha256 cellar: :any,                 ventura:        "1e8b7d257f7ee52d1b617e619b695ddb3c4ea9b9674f3624ab330b50336426d1"
    sha256 cellar: :any,                 monterey:       "a8c476d194c8e32dfb661c9723fa3d22dbb082d90a75c0359eb5d584e8eae0d0"
    sha256 cellar: :any,                 big_sur:        "1eb7bed918a0e4e1e3beb4f4f5a54f59a652116d1f8898b2a7bf8f3f9354f699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95fb081c41b8100a41eb4052db1a95b29348f16ca0f4553a9cb20f875265e6d2"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "pycparser"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "aioesphomeapi" do
    url "https://files.pythonhosted.org/packages/00/64/6c1907e7cfbc720587719caf91f8993b092a6abbef77e3b6fa999ab80ecb/aioesphomeapi-15.0.0.tar.gz"
    sha256 "118abdd81b4de4970979fad6eaa3a62bdc3c04d87ac57f0cae2413aabb0faf3b"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/40/a0/07be94aecba162ed5147359f9883e82afd2ac13aed33678a008fc8c36f8b/aiofiles-23.1.0.tar.gz"
    sha256 "edd247df9a19e0db16534d4baaf536d6609a43e1de5401d7a4c1c148753a1635"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/28/99/2dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfce/anyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/b5/f1/f55f568ef587fe7a74f46a9ae869dbbda10575b2a404c831d2bc0567b7de/bitstring-4.0.2.tar.gz"
    sha256 "a391db8828ac4485dd5ce72c80b27ebac3e7b989631359959e310cd9729723b2"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/8e/5d/2bf54672898375d081cb24b30baeb7793568ae5d958ef781349e9635d1c8/cryptography-41.0.3.tar.gz"
    sha256 "6d192741113ef5e30d89dcb5b956ef4e1578f304708701b8b73d38e3e1461f34"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "esphome-dashboard" do
    url "https://files.pythonhosted.org/packages/62/b7/3eea1906209f826420b47b093afe7ff361c91506362b9f49c588fd379feb/esphome-dashboard-20230711.0.tar.gz"
    sha256 "d3425e9ce706b6dac30ef2082bf88445ba2246beddb20da26db340981e0b22d5"
  end

  resource "esptool" do
    url "https://files.pythonhosted.org/packages/a3/63/c757f50b606996a7e676f000b40626f65be63b3a10030563929c968e431c/esptool-4.6.2.tar.gz"
    sha256 "549ef93eef42ee7e9462ce5a53c16df7a0c71d91b3f77e19ec15749804cdf300"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "kconfiglib" do
    url "https://files.pythonhosted.org/packages/86/82/54537aeb187ade9b609af3d2988312350a7fab2ff2d3ec0230ae0410dc9e/kconfiglib-13.7.1.tar.gz"
    sha256 "a2ee8fb06102442c45965b0596944f02c2a1517f092fa208ca307f3fd12a0a22"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/e4/e0/3e49c0f91f3e8954806c1076f4eae2c95a9d3ed2546f267c683b877d327b/marshmallow-3.20.1.tar.gz"
    sha256 "5d2371bbe42000f2b3fb5eaa065224df7d8f8597bc19a1bbfa5bfe7fba8da889"
  end

  resource "noiseprotocol" do
    url "https://files.pythonhosted.org/packages/76/17/fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95/noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/f8/dd/4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12/paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "platformio" do
    url "https://files.pythonhosted.org/packages/b5/bd/929283a87ed210b537c2de33911ca4dcb0ee67d06182786f9ee30e5da75b/platformio-6.1.7.tar.gz"
    sha256 "9e72b94ff936bc530e80bef3f1ad5319d84fb4144bcf9587a4cc70ea6090ffce"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/0e/35/e76da824595452a5ad07f289ea1737ca0971fc6cc7b6ee9464279be06b5e/pyelftools-0.29.tar.gz"
    sha256 "ec761596aafa16e282a31de188737e5485552469ac63b60cfcccf22263fd24ff"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/52/55/98746af96f57a0ff4f108c5ac84c130af3c4e291272acf446afc67d5d5d8/starlette-0.26.1.tar.gz"
    sha256 "41da799057ea8620e4667a3e69a5b1923ebd32b1819c8fa75634bbe8d8bea9bd"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/30/f0/6e5d85d422a26fd696a1f2613ab8119495c1ebb8f49e29f428d15daf79cc/tornado-6.3.2.tar.gz"
    sha256 "4b927c4f19b71e627b13f3db2324e4ae660527143f9e1f2e2fb404f3a187e2ba"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/70/e5/81f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420d/tzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c6/dd/0d3bab50ab4ef8bec849f89fec2adc2fabcc397018c30e57d9f0d4009c5e/uvicorn-0.22.0.tar.gz"
    sha256 "79277ae03db57ce7d9aa0567830bbb51d7a612f54d6e1e3e92da3ef24c2c8ed8"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/72/0c/0ed7352eeb7bd3d53d2c0ae87fa1e222170f53815b8df7d9cdce7ffedec0/voluptuous-0.13.1.tar.gz"
    sha256 "e8d31c20601d6773cb14d4c0f42aee29c6821bbd1018039aac7ac5605b489723"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/6d/b3/1288ce4c7069e344cc6825dd896b4c0fe5e7950aff9ea98415275a302d15/zeroconf-0.69.0.tar.gz"
    sha256 "c6520f39f718e6bd16a87e0a7711ff65acfbb11bbc9fabb6283506833e0c3c0f"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      esphome:
        name: test
        platform: ESP8266
        board: d1
    EOS

    assert_includes shell_output("#{bin}/esphome config #{testpath}/test.yaml 2>&1"), "INFO Configuration is valid!"
  end
end