class Pferd < Formula
  include Language::Python::Virtualenv

  desc "Programm zum Flotten Einfachen Runterladen von Dateien"
  homepage "https:github.comGarmelonPFERD"
  url "https:files.pythonhosted.orgpackages463ec59874ab484c5e19fed106c8b37aa29bbe64921bd8f5b88e9b718c3c264bpferd-3.5.1.tar.gz"
  sha256 "adad46fbfad08fbe9a479bb8989393598dc26ec30851d162a97e958509cbf809"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19dc49b64e11d8bc3a87a11b9e2676ed3f804449c7a6de132e2c95248086eead"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "469117a1bd2d8267dcf17e8d5efaf08af8404fa24b0cdabfc6786b398db64a47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f406afebe991bd0c197fa20b6fb58d17bf372dbd830590c861caeaaa81f5f82"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f35332402d9c56a71baab3b53feba48c5a4a28de994ae80d5f689a57fc31b67"
    sha256 cellar: :any_skip_relocation, ventura:        "cc5b8858f544e63b2cb792535bb6cf19af64444569024271a9a2f1b2d61fd6dd"
    sha256 cellar: :any_skip_relocation, monterey:       "92c1e7b2d9db2766bc382b63f2c00a904ede2e0cd10a89575188b55c2041c060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "049828f5b882487f8477466b56c76ad627162d4a8133cfb2a6182b7539345c04"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages7e0b4235b25496c741f4c9f75a94951fbc15c48537349a03448687fb226256efaiohttp-3.9.4.tar.gz"
    sha256 "6ff71ede6d9a5a58cfb7b6fffc83ab5d4a63138276c771ac91ceaaddf5459644"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https:files.pythonhosted.orgpackagesc960e83781b07f9a66d1d102a0459e5028f3a7816fdd0894cba90bee2bbbda14jaraco.context-5.3.0.tar.gz"
    sha256 "c2f67165ce1f9be20f32f650f25d8edfc1646a8aeee48ae06fb35f90763576d2"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackages577cfe770e264913f9a49ddb9387cca2757b8d7d26f06735c1bfbb018912afcejaraco.functools-4.0.0.tar.gz"
    sha256 "c279cb24c93d694ef7270f970d499cab4d3813f4e08273f95398651a634f0925"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages18eccc0afdcd7538d4942a6b78f858139120a8c7999e554004080ed312e43886keyring-25.1.0.tar.gz"
    sha256 "7230ea690525133f6ad536a9b5def74a4bd52642abe594761028fc044d7c7893"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "PFERD #{version} (#{homepage})", shell_output("#{bin}pferd --version").strip

    assert_match "Error Failed to load config", shell_output("#{bin}pferd", 1)

    (testpath"pferd.cfg").write <<~EOS
      [crawl:Foo]
      type = kit-ilias-web
      target = 1234567
    EOS
    assert_match "key 'auth': Missing value", shell_output("#{bin}pferd -c #{testpath}pferd.cfg", 1)
  end
end