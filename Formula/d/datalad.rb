class Datalad < Formula
  include Language::Python::Virtualenv

  desc "Data distribution geared toward scientific datasets"
  homepage "https:www.datalad.org"
  url "https:files.pythonhosted.orgpackagesee5143be9521b4942bf5db7e218e8802e747b4aa7fd8a7c7be80580a8e63232bdatalad-1.0.0.tar.gz"
  sha256 "34113a9fdd2f8fa2aa6124a89a2853e83a3604f6b31eeaf5f9161def0da692e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08efa3bc9ef069652336c2908dc8cc4fed4cd3a5f9d86f68777f3dc8af200170"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7b6418ae1cb4b9b4cf20a156359a12b489d6005233bc6ddefa5e31af10efe81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1377276049fcf9ea05b01960f0bb3e5d9d31fda4371830758bfbeb2e45815302"
    sha256 cellar: :any_skip_relocation, sonoma:         "c13bbc3d846aac89abfafdc6ba3160c6cb04cc6d978fa4e202db5c324983424f"
    sha256 cellar: :any_skip_relocation, ventura:        "123cd634198461008af0f9ebea3a07d3686e59a1ab1e3c37d8922f7f5a014c26"
    sha256 cellar: :any_skip_relocation, monterey:       "4e7cc19f50fc5104fdcf999257b693977464195a9046711c5028fbf3a7b5e3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a0b96c36d17eeb453b71eaba4bcbed90be92fa36fea99c09dfb865c295c87e"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "git-annex"
  depends_on "p7zip"
  depends_on "python@3.11" # Python 3.12 blocked by `boto` usage: https:github.comdataladdataladissues5597

  resource "annexremote" do
    url "https:files.pythonhosted.orgpackages30a8c2bd70b26edbb815cb8180344a7dd88ba9da5124b02b4434ddb25e0cc6d1annexremote-1.6.4.tar.gz"
    sha256 "da4198a25b36c699216fd5f1e93ba0e655e167b6822b64284a4bf90388ea69ae"
  end

  resource "backports-tarfile" do
    url "https:files.pythonhosted.orgpackages1df52f268125bdd8f6d5cce1d6ba19fc0c58a6d65d3f46f27df677236d58620abackports.tarfile-1.0.0.tar.gz"
    sha256 "2688f159c21afd56a07b75f01306f9f52c79aebcc5f4a117fb8fbb4445352c75"
  end

  resource "boto" do
    url "https:files.pythonhosted.orgpackagesc8af54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fasteners" do
    url "https:files.pythonhosted.orgpackages5fd4e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages76217a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75chumanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesa0fcc4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
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

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages18eccc0afdcd7538d4942a6b78f858139120a8c7999e554004080ed312e43886keyring-25.1.0.tar.gz"
    sha256 "7230ea690525133f6ad536a9b5def74a4bd52642abe594761028fc044d7c7893"
  end

  resource "keyrings-alt" do
    url "https:files.pythonhosted.orgpackages4f557a52c9961f607353034945692c700ab648f18ea2ab2d509e248b24cb0a91keyrings.alt-5.0.1.tar.gz"
    sha256 "cd372a1ec446a1bc5a90624a52c88e83b9330218e39047a6c9a48ae37d116745"
  end

  resource "looseversion" do
    url "https:files.pythonhosted.orgpackages647ef13dc08e0712cc2eac8e56c7909ce2ac280dbffef2ffd87bd5277ce9d58blooseversion-1.3.0.tar.gz"
    sha256 "ebde65f3f6bb9531a81016c6fef3eb95a61181adc47b7f949e9c0ea47911669e"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackages084c17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "patool" do
    url "https:files.pythonhosted.orgpackages97f34631a690c5620e39e03e1e6768f68f5cfe766004311e66d1c17bcd9f293bpatool-2.2.0.tar.gz"
    sha256 "7767a747b24fbaa6ecc53579debc18358b6bc792ddb57e0669784c5b29af4a73"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "python-gitlab" do
    url "https:files.pythonhosted.orgpackages8d6d934b832b55ca42740b078fe18aa83680ac7d196802feee39f9b87195a156python-gitlab-4.4.0.tar.gz"
    sha256 "1d117bf7b433ae8255e5d74e72c660978f50ee85eb62248c9fb52ef43c3e3814"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3eef65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"datalad", "create", "-d", "testdata"
    assert_predicate testpath"testdata", :exist?
  end
end