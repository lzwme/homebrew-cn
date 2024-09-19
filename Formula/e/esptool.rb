class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/d4/c7/b7e4b96a0e7d9b94fe953e1b55b3573bec498bac05f72e61e5a0e979e2c7/esptool-4.8.0.tar.gz"
  sha256 "f933150b5753e7501024e4d237fe078a77913a0cb7e2f08197ef8d70306b1b53"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8ab4a992cdb45c3cf813267b05e573dd42437c5605f0e8bb458155e5ead008d"
    sha256 cellar: :any,                 arm64_sonoma:  "1befe86009f2dc70cc8d4423414eab75060b3a902c1e3f0ce3f083df20bf76a4"
    sha256 cellar: :any,                 arm64_ventura: "35ac746d4fb7d398bc3bfb7a629684d6c38a75dad7d97fbd94de34e79e6479fe"
    sha256 cellar: :any,                 sonoma:        "e315dd083e58423179467ac095aa1b9c17b424ba6252a735c2b8506fa2578257"
    sha256 cellar: :any,                 ventura:       "25acc5e5731a8bd3e75de8d2b3705f16bfbc7718c10609dfd12b5b3e1b6e6233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6851b97200b94de7c4bad9bb8d86234258d1071a38e054e84de6b8b8ea83675d"
  end

  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/75/33/a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6/argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/c7/bf/25cf92a83e1fe4948d7935ae3c02f4c9ff9cb9c13e977fba8af11a5f642c/bitarray-2.9.2.tar.gz"
    sha256 "a8f286a51a32323715d77755ed959f94bef13972e9a2fe71b609e40e6d27957e"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/d8/d0/d6f57409bb50f54fe2894ec5a50b5c04cb41aa814c3bdb8a7eeb4a0f7697/bitstring-4.2.3.tar.gz"
    sha256 "e0c447af3fda0d114f77b88c2d199f02f97ee7e957e6d719f40f41cf15fbb897"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/5e/d0/ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051b/ecdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

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