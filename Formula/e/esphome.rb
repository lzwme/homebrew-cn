class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32ESP8266 super easy"
  homepage "https:github.comesphomeesphome"
  url "https:files.pythonhosted.orgpackagesbfb42bbe3c69c647959617c333c13a7524243095e9955764dfc54f341061c5a0esphome-2023.12.6.tar.gz"
  sha256 "c05d9c3059220ce4a36b8b9a3117e00bf42d49264d5fd03f664c0faa7541e20c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fb3bc36b7f846cf8a10e67814cbe2c2c816ed415b7e3b15eccfae68013780d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aee1064e8e633b1973e06bab5f404c1c5261dc57ca8366c5e70162d7fb8e891d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ba69ed14eebf5ff33742158d92cde8fba844780d5d760a33e281ceae0025ea8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f640442ec36fac80e4d778de2130fe186cbc54d9acb29e0cd42e7bf03271e45f"
    sha256 cellar: :any_skip_relocation, ventura:        "6b6f12c50f3e49b70c509448718a41fd795d1055efdae63e0a11465120c5868c"
    sha256 cellar: :any_skip_relocation, monterey:       "f34db278eb274c1198d57556e6ccb94dbf199a12f6b6c5bb54fa89c6372d0d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b844cefaab73557e6699a94273467cad9605892fb015a9e1c51e2b77ab8b12cc"
  end

  depends_on "cffi"
  depends_on "platformio"
  depends_on "protobuf"
  depends_on "pycparser"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-pyparsing"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "aioesphomeapi" do
    url "https:files.pythonhosted.orgpackages4965312734ba2682aead9ab77fde23675aa03310b0e7cc7c65ade61836509cc2aioesphomeapi-21.0.1.tar.gz"
    sha256 "f292c759dc1f3258905fe31284d39bcb926045677f41a1a1b3bf95ca438621c7"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackagescc83f731ac54f82fc25984ee4d6abadf69b824dde03b629a1348f459e7b35d5aaiohappyeyeballs-2.3.2.tar.gz"
    sha256 "77e15a733090547a1f5369a1287ddfc944bd30df0eb8993f585259c34b405f4e"
  end

  resource "bitarray" do
    url "https:files.pythonhosted.orgpackagesc7bf25cf92a83e1fe4948d7935ae3c02f4c9ff9cb9c13e977fba8af11a5f642cbitarray-2.9.2.tar.gz"
    sha256 "a8f286a51a32323715d77755ed959f94bef13972e9a2fe71b609e40e6d27957e"
  end

  resource "bitstring" do
    url "https:files.pythonhosted.orgpackages7f070fd502a29127b968bada3d1824a8af997546d2b9ff73f00e800b3d9888cbbitstring-4.1.4.tar.gz"
    sha256 "94f3f1c45383ebe8fd4a359424ffeb75c2f290760ae8fcac421b44f89ac85213"
  end

  resource "chacha20poly1305-reuseable" do
    url "https:files.pythonhosted.orgpackagesfc41ae11c16381bb210ccb12c4d07c0030452d8e4d888d46e227d1a596026f09chacha20poly1305_reuseable-0.12.0.tar.gz"
    sha256 "238a1d5af6473a8ed249e6ddad327190b3567a673ad54766c9cb2da5c78a4c9b"
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
    url "https:files.pythonhosted.orgpackagesa363c757f50b606996a7e676f000b40626f65be63b3a10030563929c968e431cesptool-4.6.2.tar.gz"
    sha256 "549ef93eef42ee7e9462ce5a53c16df7a0c71d91b3f77e19ec15749804cdf300"
  end

  resource "ifaddr" do
    url "https:files.pythonhosted.orgpackagese8acfb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "kconfiglib" do
    url "https:files.pythonhosted.orgpackages868254537aeb187ade9b609af3d2988312350a7fab2ff2d3ec0230ae0410dc9ekconfiglib-13.7.1.tar.gz"
    sha256 "a2ee8fb06102442c45965b0596944f02c2a1517f092fa208ca307f3fd12a0a22"
  end

  resource "noiseprotocol" do
    url "https:files.pythonhosted.orgpackages7617fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "paho-mqtt" do
    url "https:files.pythonhosted.orgpackagesf8dd4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "python-magic" do
    url "https:files.pythonhosted.orgpackagesdadb0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "reedsolo" do
    url "https:files.pythonhosted.orgpackagesf761a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5ereedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackagesbda2ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages4d60acd18ca928cc20eace3497b616b6adb8ce1abc810dd4b1a22bc6bdefac92tzdata-2023.4.tar.gz"
    sha256 "dd54c94f294765522c77399649b4fefd95522479a664a0cec87f41bebc6148c9"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages04d3c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackagesd83398b8032d580525c04e0691f4df9a74b0cfb327661823e32fe6d00bed55a4voluptuous-0.14.1.tar.gz"
    sha256 "7b6e5f7553ce02461cce17fedb0e3603195496eb260ece9aca86cc4cc6625218"
  end

  resource "zeroconf" do
    url "https:files.pythonhosted.orgpackagesee8a09b72c5740030c71167bec119eb7baf006ea2dbec3e29d26be0def248c94zeroconf-0.130.0.tar.gz"
    sha256 "db96a3033bc2ece2c75d873796e82530e092e250d03d07dd530828cf84ae16f0"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    pth_contents = "import site; site.addsitedir('#{Formula["platformio"].opt_libexecsite_packages}')\n"
    (libexecsite_packages"homebrew-platformio.pth").write pth_contents
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