class Bbot < Formula
  include Language::Python::Virtualenv

  desc "OSINT automation tool"
  homepage "https://github.com/blacklanternsecurity/bbot"
  url "https://files.pythonhosted.org/packages/5c/eb/e79160ad9d406cd0cb8cfa5ec9c2341d2c39356d6fe192996b96281efa98/bbot-1.1.0.2124.tar.gz"
  sha256 "33841c6852e667c3f151f7463d4a3419dc9ada5a867fa8a5d34f124beb4f8152"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e56de8ecd60aa4ff18debfbc0e07afdf583b621cc888a5899604913304b5c4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04bdcbe78058a4181b5fa0cb901f6922a010b714181faa6f2d4dba9ba1e84732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74476e1a032f23672c8623c69af9612e11ed2d7b4f0be6d15294a32f35c72e56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c314cc37a4decd0a5edbcbaa5bffd8d55e1f7c618f7b2c2f8207446d8fabcef"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2f14f32d09132058d41ad60d02f81acd9b33b2bf15072f24230627b80c6835a"
    sha256 cellar: :any_skip_relocation, ventura:        "a44cc819ad9adbeb1cb3e98fa8d6eaa7bc7f7c317e6129f67a24b2dc03ef6fa0"
    sha256 cellar: :any_skip_relocation, monterey:       "9f025130258400dbd2df612f8a7047fbe03567ebc58defb00de75cff24f6e195"
    sha256 cellar: :any_skip_relocation, big_sur:        "12bdec042ae5c07c29ac62bbd7280e77f29119eb856bc40903ffd2aa486ddf57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50a6225e0d16f58426163d788192637698f66be9c249060f458d6c717f0e72d1"
  end

  depends_on "openjdk" => :build # for omegaconf
  depends_on "cffi"
  depends_on "docutils"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-lxml"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "ansible" do
    url "https://files.pythonhosted.org/packages/39/47/bef8fd8bc2b6e7b5058b61565959c91819eccb8be119a66f8524c0252c62/ansible-7.7.0.tar.gz"
    sha256 "9c206ba515f13a0cc9c919d496218ba26df581755bdc39be85b074066c699a02"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/15/75/080b926e400284f2834aa33e3a699b052f197caf7c8eeded80dc1cb110f5/ansible-core-2.14.9.tar.gz"
    sha256 "911354fe9f6b4c58c9546b3eca7c5244ea39007fa590096f7419fb9c019f9a05"
  end

  resource "ansible-runner" do
    url "https://files.pythonhosted.org/packages/1a/2f/7962542e2a85e8786f44e11825e1f85923ddd95c9f83cfc7cc525f5dad67/ansible-runner-2.3.4.tar.gz"
    sha256 "79a1bd134d813c8ea3740599c6fd961a11425ce7757f2fd725cf56d6a1a7236c"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/ab/eb/73a636701c5267e607732775cb7a76cc90c8ff08acd4f3e131f72017d976/anyio-4.0.0rc1.tar.gz"
    sha256 "48d53f0b141f5757c38d648309e6fe254857fae092d67f938fa248d7c0f36804"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "cloudcheck" do
    url "https://files.pythonhosted.org/packages/1a/cc/7362e02e6945bad5e484efd5ca240c481e38a79ffdd08d44ac996cb1ae05/cloudcheck-2.0.0.36.tar.gz"
    sha256 "c5348b6185a4bcf1a5766c33d2a58cb8bd232ee88065ee12a962f6a8fa474b96"
  end

  resource "deepdiff" do
    url "https://files.pythonhosted.org/packages/c7/ea/5f9833b7f851c5990fc314795a28d5dcc28fa7366530ba70503ce199ff22/deepdiff-6.4.1.tar.gz"
    sha256 "744c4e54ff83eaa77a995b3311dccdce6ee67773335a34a5ef269fa048005457"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5a/47/f1f3f5b6da710d5a7178a7f8484d9b86b75ee596fb4fefefb50e8dd2205a/filelock-3.12.3.tar.gz"
    sha256 "0ecc1dd2ec4672a10c8550a8182f1bd0c0a5088470ecd5a125e45f49472fac3d"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/63/ad/c98ecdbfe04417e71e143bf2f2fb29128e4787d78d1cedba21bd250c7e7a/httpcore-0.17.3.tar.gz"
    sha256 "a6f30213335e34c1ade7be6ec7c47f19f50c56db36abef1a9dfa3815b1cb3888"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f8/2a/114d454cb77657dbf6a293e69390b96318930ace9cd96b51b99682493276/httpx-0.24.1.tar.gz"
    sha256 "5853a43053df830c20f8110c5e69fe44d035d850b2dfe795e196f00fdb774bdd"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
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
    url "https://files.pythonhosted.org/packages/3b/9b/a7631bf35e55326fd74654fe6bd896478f47d65e97ca69e60ddb1b3823ee/pydantic-1.10.12.tar.gz"
    sha256 "0fe8a415cea8f340e7a9af9c54fc71a649b43e8ca3cc732986116b3cb135d303"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/84/50/97b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205a/python-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/c6/63/76613d73fb4ec23cc2451c1be30974a373c7258274db2e4f79530bda505d/requests_cache-0.9.8.tar.gz"
    sha256 "eaed4eb5fd5c392ba5e7cfa000d4ab96b1d32c1a1620f37aa558c43741ac362b"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
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

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove in the next release of url-normalize
    patch do
      url "https://github.com/niksite/url-normalize/commit/b8557b10c977b191cc9d37e6337afe874a24ad08.patch?full_index=1"
      sha256 "b24bf01ec8d6c163a6d3c97672beba761d35006922d4ad930dbeca79b6c52bfe"
    end
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
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
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bbot -s --version")

    assert_predicate testpath/".config/bbot/bbot.yml", :exist?
    assert_predicate testpath/".config/bbot/secrets.yml", :exist?
  end
end