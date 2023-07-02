class Bbot < Formula
  include Language::Python::Virtualenv

  desc "OSINT automation tool"
  homepage "https://github.com/blacklanternsecurity/bbot"
  url "https://files.pythonhosted.org/packages/0b/df/4afd9aeca87c7f7c1ad2a15368b9fa27c3892e3923f8c3ea4614e6cb8956/bbot-1.0.5.1665.tar.gz"
  sha256 "5ec660a711afbafb4a1626b1a28ecc1b05bad9e40c1c997e76cb511cd9da1fb7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b180ec9ae47e6b55d5a25036653cd0409fb1afc2ea0973afffbfe440b453fdee"
    sha256 cellar: :any,                 arm64_monterey: "a96b02ff0560ca74f78c51eba9376b16ae5d41520f5d27554c4a2777ee70d4b0"
    sha256 cellar: :any,                 arm64_big_sur:  "e63d97b3c96cf118fe25dc884a3a618a03d98108646065d6b41d2fb32606aecc"
    sha256 cellar: :any,                 ventura:        "647160f879dfe66fe78f532ef04e171339462dbb6012cfd9fb3d207f283b6b8d"
    sha256 cellar: :any,                 monterey:       "da105dfa85dfd6a0459f8dce4de5123c0e62531aef15813ecac0915d858a59f5"
    sha256 cellar: :any,                 big_sur:        "43814fb542c3b5716a341f024ccd5c32d9e199031416c9f489eea98ae62567e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f05438015d3ceeaa7f7e47170496ab90e2a9575e775fe48df6069855e92f4499"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "docutils"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # Needs pip >= 23.1.x
  resource "pip" do
    url "https://files.pythonhosted.org/packages/fa/ee/74ff76da0ab649eec7581233daeb43d8aa35383d8f75317b2ab3b80c922f/pip-23.1.2.tar.gz"
    sha256 "0e7c86f486935893c708287b30bd050a36ac827ec7fe5e43fe7cb198dd835fba"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/d6/27/06f4b8a082d9ecd055da28f37fca69ebd0f7b8427d5f6068b6125b1441a8/ansible-core-2.14.7.tar.gz"
    sha256 "2be26d617483b2b1621ec93ca57f2e24faace90cb9f07d8dca3f68a8428d9cd6"
  end

  resource "ansible-runner" do
    url "https://files.pythonhosted.org/packages/f6/8e/4f7af61d9bb92e9c6f46d7154f8821122596a67b82be761fe63ca8b2fbba/ansible-runner-2.3.3.tar.gz"
    sha256 "38ff635e4b94791de2956c81e265836ec4965b30e9ee35d72fcf3271dc46b98b"
  end

  resource "ansible" do
    url "https://files.pythonhosted.org/packages/39/47/bef8fd8bc2b6e7b5058b61565959c91819eccb8be119a66f8524c0252c62/ansible-7.7.0.tar.gz"
    sha256 "9c206ba515f13a0cc9c919d496218ba26df581755bdc39be85b074066c699a02"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cloudcheck" do
    url "https://files.pythonhosted.org/packages/1a/cc/7362e02e6945bad5e484efd5ca240c481e38a79ffdd08d44ac996cb1ae05/cloudcheck-2.0.0.36.tar.gz"
    sha256 "c5348b6185a4bcf1a5766c33d2a58cb8bd232ee88065ee12a962f6a8fa474b96"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "deepdiff" do
    url "https://files.pythonhosted.org/packages/48/cd/8fcd6381e72d7e4033b695489df3a0f54ff5c04eea6d0f67379367b7baeb/deepdiff-6.3.0.tar.gz"
    sha256 "6a3bf1e7228ac5c71ca2ec43505ca0a743ff54ec77aa08d7db22de6bc7b2b644"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/91/8b/522301c50ca1f78b09c2ca116ffb0fd797eadf6a76085d376c01f9dd3429/dnspython-2.3.0.tar.gz"
    sha256 "224e32b03eb46be70e12ef6d64e0be123a64e621ab4c0822ff6d450d52a540b9"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "omegaconf" do
    url "https://files.pythonhosted.org/packages/09/48/6388f1bb9da707110532cb70ec4d2822858ddfb44f1cdf1233c20a80ea4b/omegaconf-2.3.0.tar.gz"
    sha256 "d5d4b6d29955cc50ad50c46dc269bcd92c6e00f5f90d23ab5fee7bfca4ba4cc7"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/eb/84/9b0a0e2d931fc9bdb32e6905076714f9592f9b20de03c90fd0f65b3ab063/pydantic-1.10.10.tar.gz"
    sha256 "3b8d5bd97886f9eb59260594207c9f57dce14a6f869c6ceea90188715d29921a"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/84/50/97b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205a/python-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/c6/63/76613d73fb4ec23cc2451c1be30974a373c7258274db2e4f79530bda505d/requests_cache-0.9.8.tar.gz"
    sha256 "eaed4eb5fd5c392ba5e7cfa000d4ab96b1d32c1a1620f37aa558c43741ac362b"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/dc/98/5f896af066c128669229ff1aa81553ac14cfb3e5e74b6b44594132b8540e/setuptools-68.0.0.tar.gz"
    sha256 "baf1fdb41c6da4cd2eae722e135500da913332ab3f2f5c7d33af9b492acb5235"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/7a/53/afac341569b3fd558bf2b5428e925e2eb8753ad9627c1f9188104c6e0c4a/tabulate-0.8.10.tar.gz"
    sha256 "6c57f3f3dd7ac2782770155f3adb2db0b1a269637e42f27599925e64b114f519"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/80/90/d294a3f69b4143cf56c326064086236bc8157c389497893d940968e6cda2/tldextract-3.4.4.tar.gz"
    sha256 "5fe3210c577463545191d45ad522d3d5e78d55218ce97215e82004dcae1e1234"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/ec/ea/780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8f/url-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  resource "wordninja" do
    url "https://files.pythonhosted.org/packages/30/15/abe4af50f4be92b60c25e43c1c64d08453b51e46c32981d80b3aebec0260/wordninja-2.0.0.tar.gz"
    sha256 "1a1cc7ec146ad19d6f71941ee82aef3d31221700f0d8bf844136cf8df79d281a"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "xmltojson" do
    url "https://files.pythonhosted.org/packages/dc/ed/1d658daeb13fdf59aa90984f94452e76c9ab494bb53bf3ad6cbd37e6e320/xmltojson-2.0.2.tar.gz"
    sha256 "10719660409bd1825507e04d2fa4848c10591a092613bcd66651c7e0774f5405"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bbot -s --version")

    assert_predicate testpath/".config/bbot/bbot.yml", :exist?
    assert_predicate testpath/".config/bbot/secrets.yml", :exist?
  end
end