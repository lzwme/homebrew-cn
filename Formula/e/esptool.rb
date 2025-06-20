class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/ae/7f/6eff54ced5fba62ec99fc78b10211977aec841c2a63cbae75b6a9de36f77/esptool-4.9.0.tar.gz"
  sha256 "f636b4552f3873cdf94cfaf2d5c37f5407f1f33df73643efee513867310b6a8e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d7bfe3d0482ad121125be310caf3ed21010e49ad6854953ce4711f185ae3eca"
    sha256 cellar: :any,                 arm64_sonoma:  "7845fb593d7704827c3742a5c61ef8412478a727e9735507e87a8a65a593a448"
    sha256 cellar: :any,                 arm64_ventura: "eacb39e29373f8e86ad8a688d54c45f2e3f529ae360f15134a875191c7e517fd"
    sha256 cellar: :any,                 sonoma:        "06ba8bc5c32b93a7d7fecba52f0e647863a6a0ab6606038a25812d72ad5042fa"
    sha256 cellar: :any,                 ventura:       "8decd9ea16775c77607fb03608343c86f60140a4e5f0cf677435767dcb36dd4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb325b24b3d729fe30ddeba68d7695913bcdcc0422a2b843e75c5825331afe77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea54c12fddc6030cd3e6e352b1867e3a678599e326df1b832efc904e97cade2"
  end

  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/b8/0d/15826c7c2d49a4518a1b24b0d432f1ecad2e0b68168f942058b5de498498/bitarray-3.4.2.tar.gz"
    sha256 "78ed2b911aabede3a31e3329b1de8abdc8104bd5e0545184ddbd9c7f668f4059"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/15/a8/a80c890db75d5bdd5314b5de02c4144c7de94fd0cefcae51acaeb14c6a3f/bitstring-4.3.1.tar.gz"
    sha256 "a08bc09d3857216d4c0f412a1611056f1cc2b64fd254fb1e8a0afba7cfa1a95a"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/c0/1f/924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46a/ecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
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
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources

    bin.each_child(false) do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script.to_s,
                                           base_name: script.to_s, shell_parameter_format: :arg)
    end
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