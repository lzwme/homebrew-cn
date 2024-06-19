class Twine < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https:github.compypatwine"
  url "https:files.pythonhosted.orgpackages666ddcf5c58dbc468b52f20f2de0470caaae09a7ab91d847f7ca4a786137ca4ftwine-5.1.0.tar.gz"
  sha256 "4d74770c88c4fcaf8134d2a6a9d863e40f08255ff7d8e2acb3cbbd57d25f6e9d"
  license "Apache-2.0"
  revision 2
  head "https:github.compypatwine.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f0711d230b7078078b9e2fefc98df2afdce83aa5f2774d4b131ad683d00597f0"
    sha256 cellar: :any,                 arm64_ventura:  "988e26c5147610594286df2558f2529dfbb20e6c0162a95d9345e43b6c657010"
    sha256 cellar: :any,                 arm64_monterey: "bc35ec8d5e3acc2e84e8aaee8262f5a4e1e57d61925d623476a9d5c5ddf61388"
    sha256 cellar: :any,                 sonoma:         "2143138d2669bf39ba3cafa72084810773fba913edddf86b6b55b7058cac74da"
    sha256 cellar: :any,                 ventura:        "b802a7bcdc0d913cb3edf840d59938820b06edf06ee431063ae60737d6df1973"
    sha256 cellar: :any,                 monterey:       "0468348a66fcc76130091070441844c8813ff369b4ee6d6d2cb1e456e2745359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333cc4b4674d142ea5f03dc5326278040a741346219b36f94162209d8918930f"
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
    url "https:files.pythonhosted.orgpackages013377f586de725fc990d12dda3d4efca4a41635be0f99a987b9cc3a78364c13more-itertools-10.3.0.tar.gz"
    sha256 "e5d93ef411224fbcef366a6e8ddc4c5781bc6359d43412a65dd5964e46111463"
  end

  resource "nh3" do
    url "https:files.pythonhosted.orgpackages4bd2b14d619582459d2790e0c3338ec6d1611be87fdd5d1dcaca85e6c20eaed3nh3-0.2.17.tar.gz"
    sha256 "40d0741a19c3d645e54efba71cb0d8c475b59135c1e3c580f879ad5514cbf028"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackages4fa1f00755330cb34bc19b1ba744b9880c51a9b1ed8526039354736d5f4dfb0dpkginfo-1.11.1.tar.gz"
    sha256 "2e0dca1cf4c8e39644eed32408ea9966ee15e0d324c62ba899a393b3c6b467aa"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackagesd320b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
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