class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32/ESP8266 super easy"
  homepage "https://github.com/esphome/esphome"
  url "https://files.pythonhosted.org/packages/f3/e0/396d82cd687d7e31e7130c8b1bab1df12f2f33f154b24bde542991d2c19d/esphome-2023.10.6.tar.gz"
  sha256 "7473f04fb786254ea38a123aaeda98616878a5da9a5b72934e387faca10b1879"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66a0cff9c18cef2381f191681d4335e4ce035ce4ae62e0f6d15cff078e64dcd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad29deeb19c2f7acc7a9dd621ddd4f71e1d6d58b49d733274e376f3a63cc2427"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef8d5963a08cc71a5aa9b41ae3b353b218ece57c4069b2391f7bd05aced4b20e"
    sha256 cellar: :any_skip_relocation, sonoma:         "97076e3d8b2ae69b5260b4942ebafe9e2b6e1dbc1bfc789027722f5b6f435292"
    sha256 cellar: :any_skip_relocation, ventura:        "d3707a7ecca94ca0fbb448a3ad7ebd2905396b93d743bbedd6ed728d5f8d48cd"
    sha256 cellar: :any_skip_relocation, monterey:       "195e8a07e2fbe67f5304bc468e611c06a1df06b1659f13cdb58aaa4c73dc2285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f74934d31ce4a3e5f80fd441a3e68a3902ff6b10ba23a108c70cce02f3f875"
  end

  depends_on "cffi"
  depends_on "platformio"
  depends_on "protobuf"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-pyparsing"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "aioesphomeapi" do
    url "https://files.pythonhosted.org/packages/00/64/6c1907e7cfbc720587719caf91f8993b092a6abbef77e3b6fa999ab80ecb/aioesphomeapi-15.0.0.tar.gz"
    sha256 "118abdd81b4de4970979fad6eaa3a62bdc3c04d87ac57f0cae2413aabb0faf3b"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
    sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/99/f4/316cfb1cd62886d7bf87da48cf847ecfced48ed5f91ff8e54bc52f7fd76e/bitarray-2.8.2.tar.gz"
    sha256 "f90b2f44b5b23364d5fbade2c34652e15b1fcfe813c46f828e008f68a709160f"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/23/fc/b5ace4f51fea5bcc7f8cca8859748ea5eb941680b82a5b3687c980d9589b/bitstring-4.1.2.tar.gz"
    sha256 "c22283d60fd3e1a8f386ccd4f1915d7fe13481d6349db39711421e24d4a9cccf"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "esphome-dashboard" do
    url "https://files.pythonhosted.org/packages/39/57/0d329e71a79223fed13dc27cbb58a587b8512427534cb2f04f8c5335a223/esphome-dashboard-20230904.0.tar.gz"
    sha256 "6fe36559e90d5db1af84b42542a16d492b0ef7d27e95d4ba35d7652b797291e0"
  end

  resource "esptool" do
    url "https://files.pythonhosted.org/packages/a3/63/c757f50b606996a7e676f000b40626f65be63b3a10030563929c968e431c/esptool-4.6.2.tar.gz"
    sha256 "549ef93eef42ee7e9462ce5a53c16df7a0c71d91b3f77e19ec15749804cdf300"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "kconfiglib" do
    url "https://files.pythonhosted.org/packages/86/82/54537aeb187ade9b609af3d2988312350a7fab2ff2d3ec0230ae0410dc9e/kconfiglib-13.7.1.tar.gz"
    sha256 "a2ee8fb06102442c45965b0596944f02c2a1517f092fa208ca307f3fd12a0a22"
  end

  resource "noiseprotocol" do
    url "https://files.pythonhosted.org/packages/76/17/fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95/noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/f8/dd/4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12/paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/70/e5/81f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420d/tzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/72/0c/0ed7352eeb7bd3d53d2c0ae87fa1e222170f53815b8df7d9cdce7ffedec0/voluptuous-0.13.1.tar.gz"
    sha256 "e8d31c20601d6773cb14d4c0f42aee29c6821bbd1018039aac7ac5605b489723"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/d2/51/77c4bc6b117ba338091f0427a89a83dd9c0c155d941a3c92340809ab6a4f/zeroconf-0.115.1.tar.gz"
    sha256 "401d737689565401ad0f36952eeabbbcd43e00498287b716e1bb6a50c2394238"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[platformio].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
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