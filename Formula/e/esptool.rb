class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/6a/c8/15a0d5a80a81d7a33d1bdf4a75db4c3b4334e53ef81f178cd52567acde80/esptool-5.5.0.tar.gz"
  sha256 "cfc1d1c6d1699427451af1be7335efa835b7974c61ed86d77927d9553c443d57"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0ab6f8b55f996cc2cbc7fc8385af205378f443c1a297a1763e208c94d44e12b2"
    sha256 cellar: :any, arm64_tahoe:       "19a27e76e2b45a393ae47b13dd93606a852c4ae7af94b448a0bec80f4ad5677a"
    sha256 cellar: :any, arm64_sequoia:     "84aaa61bbbd7aede123584703645d0fbf3779d24d322a49537c795d412ceea70"
    sha256 cellar: :any, arm64_linux:       "5902c44ab6e195d03465fd21b4d73a1d9130f6db7ad5339e09ac71084d247b54"
    sha256 cellar: :any, x86_64_linux:      "a7a18467a7f895fef88ad68ce8769a5239a2a54120cc49fa0b1b6ca60b33f0c7"
  end

  depends_on "rust" => :build # for tibs
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/04/f7/6765577df59e2345036e435f7e983e1c291d67b7d76a51918eff04ad1494/bitarray-3.11.0.tar.gz"
    sha256 "bf19437ec00ec3d40aef82eaeedc14cf4000be9b635c4f5049796506e6630dd8"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/36/d3/de6fe4e7065df8c2f1ac1766f5fdccbe75bc18af2cf2dbeecd34d68e1518/bitstring-4.4.0.tar.gz"
    sha256 "e682ac522bb63e041d16cbc9d0ca86a4f00194db16d0847c7efe066f836b2e37"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "esp-pylib" do
    url "https://files.pythonhosted.org/packages/c6/af/ebfab3ce5babdf0bc068d13205c3b28a4fe55f41d7cc229e1991f3f07e43/esp_pylib-1.2.0.tar.gz"
    sha256 "51f0c44a0f7a92fdded9cab54bde92441b22b464f7d684ed179afb57000bed70"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
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

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/96/3e/5688fdd83aea416de336582a274f2bc8236b5c261b04c11e17bc262786ad/rich_click-1.9.9.tar.gz"
    sha256 "324cba7513cd4187ee92b2eef21f071714e45be062458c8b157bd7e0c81103e3"
  end

  resource "tibs" do
    url "https://files.pythonhosted.org/packages/57/cd/6cf028decf1c2df4d26077dd5d0532587d93d4917233d5e004133166a940/tibs-0.5.7.tar.gz"
    sha256 "173dfbecb2309edd9771f453580c88cf251e775613461566b23dbd756b3d54cb"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/01/89/3f825ab71c242fffb62ea8fe638741c290f62f8d7aadf8125ff897747af3/websockets-17.2.tar.gz"
    sha256 "36c2fb94c990cc2545143b12690e2de6c16300f9dbe5b4f33fa300cf57dc8792"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"esptool", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "Usage: espefuse", shell_output("#{bin}/espefuse --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write <<~EOS.unpack1("m")
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py --chip esp8266 image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end