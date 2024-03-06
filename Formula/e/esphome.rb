class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32ESP8266 super easy"
  homepage "https:github.comesphomeesphome"
  url "https:files.pythonhosted.orgpackages856cdef19ffaec3e24db1f651b4a34880a94a59ac1b65bd4c92a8fc917eef10desphome-2024.2.2.tar.gz"
  sha256 "4611dab7f4de0f5f68e70a3abbdec6c6d45f7710640bddc63791502a9eadb4b3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "204bbb6959f44ed6647feb880cb0de1e14b9c1ef92ceb9077b802d8ba7180fa5"
    sha256 cellar: :any,                 arm64_ventura:  "fefeef7a66acd9dec4f8d4161dcda690319ad6b6a6ecf8302b359ddd92970f94"
    sha256 cellar: :any,                 arm64_monterey: "b92199bd68cbd92966b3065cda89b8ff87f254aeb3b4cd83646d13daa30ce494"
    sha256 cellar: :any,                 sonoma:         "7618f00b53a3c7ef1905bf77e0d6511297d7a6ada1d61f85dc6fe4e3e8d7bffb"
    sha256 cellar: :any,                 ventura:        "4efbd5a4ee352aeabd0dfd61d3a3e663e03ac2dc70c1bb8891aaccf251d32a98"
    sha256 cellar: :any,                 monterey:       "951bb2c6cd7f35a6ee89593d163286fbd84dc48137a42e29326db5e7c0f6ca3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d248b96bfc2360ee1093a83d6b3f24b33592f311a8c27fd8bf245a9fe816cca0"
  end

  depends_on "libyaml"
  depends_on "protobuf"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "aioesphomeapi" do
    url "https:files.pythonhosted.orgpackages495c9854cf6ea8f4739f7508fc15e646a3a3cc43c88d4fea515fe8c2a5daac48aioesphomeapi-21.0.2.tar.gz"
    sha256 "339579dc067579dd2b2f7d904b736ddf727e9f3e797134765814fff394e02ada"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackagescc83f731ac54f82fc25984ee4d6abadf69b824dde03b629a1348f459e7b35d5aaiohappyeyeballs-2.3.2.tar.gz"
    sha256 "77e15a733090547a1f5369a1287ddfc944bd30df0eb8993f585259c34b405f4e"
  end

  resource "ajsonrpc" do
    url "https:files.pythonhosted.orgpackagesda5c95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackagesf0a2ce706abe166457d5ef68fac3ffa6cf0f93580755b7d5f883c456e94fab7bargcomplete-3.2.2.tar.gz"
    sha256 "f3e49e8ea59b4026ee29548e24488af46e30c9de57d48638e24f54a1ea1000a2"
  end

  resource "bitarray" do
    url "https:files.pythonhosted.orgpackagesc7bf25cf92a83e1fe4948d7935ae3c02f4c9ff9cb9c13e977fba8af11a5f642cbitarray-2.9.2.tar.gz"
    sha256 "a8f286a51a32323715d77755ed959f94bef13972e9a2fe71b609e40e6d27957e"
  end

  resource "bitstring" do
    url "https:files.pythonhosted.orgpackages7f070fd502a29127b968bada3d1824a8af997546d2b9ff73f00e800b3d9888cbbitstring-4.1.4.tar.gz"
    sha256 "94f3f1c45383ebe8fd4a359424ffeb75c2f290760ae8fcac421b44f89ac85213"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesfd041c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "chacha20poly1305-reuseable" do
    url "https:files.pythonhosted.orgpackages18c4011bf30a7b82df544c9f1b1703bfe249b76f2309b2ca7d65e3359152fb2cchacha20poly1305_reuseable-0.12.1.tar.gz"
    sha256 "c1ca3de2c78eb87ac006d975729e0b9032ff31597e3c112e78268f4cd431fd6a"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https:files.pythonhosted.orgpackagesff7bba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "esphome-dashboard" do
    url "https:files.pythonhosted.orgpackages4c260fd5346999ff61b7dce87b19b1a1fda5cbdcb772764e46035a2795264deeesphome-dashboard-20231107.0.tar.gz"
    sha256 "f3888cf7cee7c4d89d30e6e76d8de5b7bf3145b37d51236da90cdf3b391dd7b9"
  end

  resource "esptool" do
    url "https:files.pythonhosted.orgpackages1b8bf0d1e75879dee053874a4f955ed1e9ad97275485f51cb4bc2cb4e9b24479esptool-4.7.0.tar.gz"
    sha256 "01454e69e1ef3601215db83ff2cb1fc79ece67d24b0e5d43d451b410447c4893"
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
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https:files.pythonhosted.orgpackages5b171b117d1875d8287a85cc2d5e2effd3f31bd8afd9f142c7b8391b9d665f0cmarshmallow-3.21.1.tar.gz"
    sha256 "4e65e9e0d80fc9e609574b9983cf32579f305c718afb30d7233ab818571768c3"
  end

  resource "noiseprotocol" do
    url "https:files.pythonhosted.orgpackages7617fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "paho-mqtt" do
    url "https:files.pythonhosted.orgpackagesf8dd4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "platformio" do
    url "https:files.pythonhosted.orgpackagesf17c149bb05152ebbb6f4c29d00fe7ee5433e870b73f1e51cf46bcfcf11d1707platformio-6.1.13.tar.gz"
    sha256 "ed7c6397f0ced579bc8137c8253465c0cfab6c0cc38d4f63da4502e995bdb5ce"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages8405fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages37fe65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44bpyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "pyserial" do
    url "https:files.pythonhosted.orgpackages1e7dae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "python-magic" do
    url "https:files.pythonhosted.orgpackagesdadb0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "reedsolo" do
    url "https:files.pythonhosted.orgpackagesf761a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5ereedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackages5e8a80e0343c8051e522752eaae54e96c814946ac97ae0c08b441620e3a22755starlette-0.35.1.tar.gz"
    sha256 "3e2639dac3520e4f58734ed22553f950d3f3cb1001cd2eaac4d57e8cdc5f66bc"
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
    url "https:files.pythonhosted.orgpackages745be025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages04d3c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackagesec540eb4441bf38c70f6ed1886dddb2e29d1650026041d19e49fc373e332fa60uvicorn-0.25.0.tar.gz"
    sha256 "6dddbad1d7ee0f5140aba5ec138ddc9612c5109399903828b4874c9937f009c2"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackagesd83398b8032d580525c04e0691f4df9a74b0cfb327661823e32fe6d00bed55a4voluptuous-0.14.1.tar.gz"
    sha256 "7b6e5f7553ce02461cce17fedb0e3603195496eb260ece9aca86cc4cc6625218"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zeroconf" do
    url "https:files.pythonhosted.orgpackagesb4b0a4f6ceb219d3cfed5f1f8dcdbf026f9224b1da0d4da9e57af01d814fec17zeroconf-0.131.0.tar.gz"
    sha256 "90c431e99192a044a5e0217afd7ca0ca9824af93190332e6f7baf4da5375f331"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.yaml").write <<~EOS
      esphome:
        name: test
        platform: ESP8266
        board: d1
    EOS

    assert_includes shell_output("#{bin}esphome config #{testpath}test.yaml 2>&1"), "INFO Configuration is valid!"
    return if Hardware::CPU.arm?

    ENV.remove_macosxsdk if OS.mac?
    system "#{bin}esphome", "compile", "test.yaml"
  end
end