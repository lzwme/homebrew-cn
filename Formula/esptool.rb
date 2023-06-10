class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/01/0f/d0ff6cf55c1932d239c4c0dd743fd10cc3f664818791542173d96f6e4810/esptool-4.6.1.tar.gz"
  sha256 "026169edbfc0180e87b8b9b178da8844fd0f39bbc1c3ee8e8f7611a2c30c8f59"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ffcd7484468e26386ee4053d840c5bffe8c6b38a640541229c41a6861ece4ffc"
    sha256 cellar: :any,                 arm64_monterey: "da66071ab638f67b80d316553a330945d74b9b0fb89fbaca45b6a04c1d24826b"
    sha256 cellar: :any,                 arm64_big_sur:  "3015ce38a13503d49a8d48c4d05e7df722f50dec69bd387b5c09d2962ec311a4"
    sha256 cellar: :any,                 ventura:        "a1ece0124fcf1faee2368fb34e3c635076a93244e7cfe277210f567bae965d6c"
    sha256 cellar: :any,                 monterey:       "d86e4966dfbcfe7ffe386931696f24fff5ecf71a6129f5a5560c47abdd998f23"
    sha256 cellar: :any,                 big_sur:        "b84793f9464382f4c6e6c89e090c8734210364f7028727c6f1cf5789b91fd8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920ee688f4c0de970c652c06d0cd0132174279115e5582a8a237d6f3ff3bdde4"
  end

  # `pkg-config`, `rust`, and `openssl@1.1` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/b5/f1/f55f568ef587fe7a74f46a9ae869dbbda10575b2a404c831d2bc0567b7de/bitstring-4.0.2.tar.gz"
    sha256 "a391db8828ac4485dd5ce72c80b27ebac3e7b989631359959e310cd9729723b2"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "base64"

    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "usage: espefuse.py", shell_output("#{bin}/espefuse.py --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py --chip esp8266 image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end