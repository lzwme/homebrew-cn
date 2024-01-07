class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https:github.comvolatilityfoundationvolatility3"
  url "https:files.pythonhosted.orgpackages83f6be2fb46e5656f322eeb807a1b0d8a767561cec26824f275f8a3e29e4280cvolatility3-2.5.0.tar.gz"
  sha256 "278ec521c9213967a01321361e4d007c71e681a0c577a75710f482bfa15d0506"
  license :cannot_represent
  revision 1
  version_scheme 1
  head "https:github.comvolatilityfoundationvolatility3.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34ca02a6d0506021c1e54eb639436493e29cd6e7d2d498ca7eb4e50cc99628f9"
    sha256 cellar: :any,                 arm64_ventura:  "5009e530a9fd882e007cb87d9b99b91d1c209242c699441706ae6c9a645480bc"
    sha256 cellar: :any,                 arm64_monterey: "6cdcf08126d23419af6e0b774cbc4e3dfcbff93406ed3210540f96724519d071"
    sha256 cellar: :any,                 sonoma:         "294c2c90a5b75ebdf70861c56a5e44ca867f70f47745601dde893d68550f99ab"
    sha256 cellar: :any,                 ventura:        "bb952b75ac94871a7233ae60340be3a6d302ff04a50036eea38c460e6df53dc1"
    sha256 cellar: :any,                 monterey:       "01038a65424ee7626e388d07f917415f42b8bb4f9b424792052817ef496cb76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5925d6c47de8804ac7b56fa708fcb94b42c60a092fd006232ab065a0e2a057c2"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "yara"

  # Extra resources are from `requirements.txt`: https:github.comvolatilityfoundationvolatility3#requirements
  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "capstone" do
    url "https:files.pythonhosted.orgpackages7afee6cdc4ad6e0d9603fa662d1ccba6301c0cb762a1c90a42c7146a538c24e9capstone-5.0.1.tar.gz"
    sha256 "740afacc29861db591316beefe30df382c4da08dcb0345a0d10f0cac4f8b1ee2"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagesa87477bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03affjsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "pefile" do
    url "https:files.pythonhosted.orgpackages78c53b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb13842a8855ff1bf568c61ca6557e2203f318fb7afeadaf2eb8ecfdbde107151pycryptodome-3.19.1.tar.gz"
    sha256 "8ae0dd1bcfada451c35f9e29a3e5db385caabc190f98e4a80ad02a61098fb776"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages81ce910573eca7b1a1c6358b0dc0774ce1eeb81f4c98d4ee371f1c85f22040a1referencing-0.32.1.tar.gz"
    sha256 "3c57da0513e9563eb7e203ebe9bb3a1b509b042016433bd1e45a2853466c3dd3"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackagesc26394a1e9406b34888bdf8506e91d654f1cd84365a5edafa5f8ff0c97d4d9e1rpds_py-0.16.2.tar.gz"
    sha256 "781ef8bfc091b19960fc0142a23aedadafa826bc32b433fdfe6fd7f964d7ef44"
  end

  resource "yara-python" do
    url "https:files.pythonhosted.orgpackages5f3460a293c7ae05731c2e6366e132a9fe4c02ae84c4f57714a2f5e8651a8491yara-python-4.3.1.tar.gz"
    sha256 "7af4354ee0f1561f51fd01771a121d8d385b93bbc6138a25a38ce68aa6801c2c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"vol", "--help"
  end
end