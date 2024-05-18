class Twine < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https:github.compypatwine"
  url "https:files.pythonhosted.orgpackages666ddcf5c58dbc468b52f20f2de0470caaae09a7ab91d847f7ca4a786137ca4ftwine-5.1.0.tar.gz"
  sha256 "4d74770c88c4fcaf8134d2a6a9d863e40f08255ff7d8e2acb3cbbd57d25f6e9d"
  license "Apache-2.0"
  head "https:github.compypatwine.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e914259f2462ba16d7237264f23d1b2ff9a27c1a6ba33412ebf7fafe1abe082"
    sha256 cellar: :any,                 arm64_ventura:  "b7da1d5c566edab6ce27a904572e521259136fb8f6a58b6387feff53b2ca031b"
    sha256 cellar: :any,                 arm64_monterey: "304337c6de1329cafa9864f8d5d7a32310a1e043fa474a8e291e245669430ad8"
    sha256 cellar: :any,                 sonoma:         "05641b9d4d272265846dba9620d71cef1d23641037b1c21a8020855d7cd21116"
    sha256 cellar: :any,                 ventura:        "b00f9a1247117a7a8cedd3c2af5de3bdae57d9deb5a266b8426ce1c6b7bda8a4"
    sha256 cellar: :any,                 monterey:       "29c057bf1587a4b8a131bcdf2a6a292730c830993681730edf3070cfd53536a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f86b05d9efa3662bfa6d2b2872e8c66332312b1b80709640b9f19c0de80423b"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesa0fcc4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
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
    url "https:files.pythonhosted.orgpackagesbc66746091bed45b3683d1026cb13b8b7719e11ccc9857b18d29177a18838dc9jaraco_functools-4.0.1.tar.gz"
    sha256 "d33fa765374c0611b52f8b3a795f8900869aa88c84769d4d1746cd68fb28c3e8"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages3ee954f232e659f635a000d94cfbca40b9d5d617707593c3d552ec14d3ba27f1keyring-25.2.1.tar.gz"
    sha256 "daaffd42dbda25ddafb1ad5fec4024e5bbcfe424597ca1ca452b299861e49f1b"
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

  resource "nh3" do
    url "https:files.pythonhosted.orgpackages4bd2b14d619582459d2790e0c3338ec6d1611be87fdd5d1dcaca85e6c20eaed3nh3-0.2.17.tar.gz"
    sha256 "40d0741a19c3d645e54efba71cb0d8c475b59135c1e3c580f879ad5514cbf028"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackages2f72347ec5be4adc85c182ed2823d8d1c7b51e13b9a6b0c1aae59582eca652dfpkginfo-1.10.0.tar.gz"
    sha256 "5df73835398d10db79f8eecd5cd86b1f6d29317589ea70796994d49399af6297"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "readme-renderer" do
    url "https:files.pythonhosted.orgpackagesfeb5536c775084d239df6345dccf9b043419c7e3308bc31be4c7882196abc62ereadme_renderer-43.0.tar.gz"
    sha256 "1818dd28140813509eeed8d62687f7cd4f7bad90d4db586001c5dc09d4fde311"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rfc3986" do
    url "https:files.pythonhosted.orgpackages85401520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages16e58efdac4c61bd5fd24f4face2295103f42790ad2ad0f322e3a81bb8391812zipp-3.18.2.tar.gz"
    sha256 "6278d9ddbcfb1f1089a88fde84481528b07b0e10474e09dcfe53dad4069fa059"
  end

  def install
    virtualenv_install_with_resources

    pkgshare.install "testsfixturestwine-1.5.0-py2.py3-none-any.whl"
  end

  test do
    wheel = "twine-1.5.0-py2.py3-none-any.whl"
    cmd = "#{bin}twine upload -uuser -ppass #{pkgshare}#{wheel} 2>&1"
    assert_match(Uploading.*#{wheel}.*HTTPError: 403m, shell_output(cmd, 1))
  end
end