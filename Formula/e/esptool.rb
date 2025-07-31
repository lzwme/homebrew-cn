class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/6c/d1/92d407cffc2d7d0113ba965a1b79bf80c1ccfdb9f86495e31de07669472f/esptool-5.0.2.tar.gz"
  sha256 "05cc4732eb2a9a7766c9e3531f7943d76ff0ca06dc9cd308d1d3d0b72f74aac2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4c0b829cb6a40b00ed709a16f672900ea0c78028c5fffaf4362d3c93cb656bc"
    sha256 cellar: :any,                 arm64_sonoma:  "0620d85ed8f210deb1d517d97a8d5347f34254e5631fd1e9e496051217b0eb9e"
    sha256 cellar: :any,                 arm64_ventura: "11db7398183d5ee30c8a51a7dec42bbee02d99625c81f7459cdc25ec54eb0da7"
    sha256 cellar: :any,                 sonoma:        "03eafa96d26f68d1cd86e470a11aaaea025583a419e877a9ccaf2bf95f65f468"
    sha256 cellar: :any,                 ventura:       "762db54cfd2ae29954ca7c1cbce31c5fdb97c27f881146d641b781059e971b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "668dfc6f2393bb32a7eb37e2d1bd53e2375adf81971854a87f2a861939eb99d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a96f7744bdd8e4cc7ec11deee625ecd61aac1fa0cfc762fdecced831bf59ff6e"
  end

  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/e5/ee/3b2fcbac3a4192e5d079aaa1850dff2f9ac625861c4c644819c2b34292ec/bitarray-3.6.0.tar.gz"
    sha256 "20febc849a1f858e6a57a7d47b323fe9e727c579ddd526d317ad8831748a66a8"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/15/a8/a80c890db75d5bdd5314b5de02c4144c7de94fd0cefcae51acaeb14c6a3f/bitstring-4.3.1.tar.gz"
    sha256 "a08bc09d3857216d4c0f412a1611056f1cc2b64fd254fb1e8a0afba7cfa1a95a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
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

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/b7/a8/dcc0a8ec9e91d76ecad9413a84b6d3a3310c6111cfe012d75ed385c78d96/rich_click-1.8.9.tar.gz"
    sha256 "fd98c0ab9ddc1cf9c0b7463f68daf28b4d0033a74214ceb02f761b3ff2af3136"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "base64"

    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "Usage: espefuse", shell_output("#{bin}/espefuse --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py --chip esp8266 image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end