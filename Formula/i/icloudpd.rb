class Icloudpd < Formula
  include Language::Python::Virtualenv

  desc "Tool to download photos from iCloud"
  homepage "https:github.comicloud-photos-downloadericloud_photos_downloader"
  url "https:github.comicloud-photos-downloadericloud_photos_downloaderarchiverefstagsv1.20.0.tar.gz"
  sha256 "ac2d194b1d2d06989516c11ade8866386b5c762c9acf633180aec99f0269b9e4"
  license "MIT"
  head "https:github.comicloud-photos-downloadericloud_photos_downloader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a9311b3fc440b85033d84c18c07e29558a5e0402be51cc2df19702f4f1cb97c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a9311b3fc440b85033d84c18c07e29558a5e0402be51cc2df19702f4f1cb97c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a9311b3fc440b85033d84c18c07e29558a5e0402be51cc2df19702f4f1cb97c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e82a2aefd6bf1949daec9f68e3c9b17bd53dbef7ca6ac6513eaf181d5741f3fe"
    sha256 cellar: :any_skip_relocation, ventura:        "e82a2aefd6bf1949daec9f68e3c9b17bd53dbef7ca6ac6513eaf181d5741f3fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e82a2aefd6bf1949daec9f68e3c9b17bd53dbef7ca6ac6513eaf181d5741f3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77c0d5a19c7e1bfa522a092e2f0326e2cfd105726ecbecb591040604c87fb1fb"
  end

  depends_on "python@3.12"

  resource "certifi" do
    url "https:files.pythonhosted.orgpackages37f72b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages72bdfedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "contextlib2" do
    url "https:files.pythonhosted.orgpackagesc71337ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8fcontextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
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
    url "https:files.pythonhosted.orgpackagesbc66746091bed45b3683d1026cb13b8b7719e11ccc9857b18d29177a18838dc9jaraco_functools-4.0.1.tar.gz"
    sha256 "d33fa765374c0611b52f8b3a795f8900869aa88c84769d4d1746cd68fb28c3e8"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages3ee954f232e659f635a000d94cfbca40b9d5d617707593c3d552ec14d3ba27f1keyring-25.2.1.tar.gz"
    sha256 "daaffd42dbda25ddafb1ad5fec4024e5bbcfe424597ca1ca452b299861e49f1b"
  end

  resource "keyrings-alt" do
    url "https:files.pythonhosted.orgpackages4f557a52c9961f607353034945692c700ab648f18ea2ab2d509e248b24cb0a91keyrings.alt-5.0.1.tar.gz"
    sha256 "cd372a1ec446a1bc5a90624a52c88e83b9330218e39047a6c9a48ae37d116745"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "piexif" do
    url "https:files.pythonhosted.orgpackagesfa84a3f25cec7d0922bf60be8000c9739d28d24b6896717f44cc4cfb843b1487piexif-1.1.3.zip"
    sha256 "83cb35c606bf3a1ea1a8f0a25cb42cf17e24353fd82e87ae3884e74a302a5f1b"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages033edc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "pytz-deprecation-shim" do
    url "https:files.pythonhosted.orgpackages94f0909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackages4ee801e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesf1fb6f40278d3b74f1486147aebf828ad081226f4f80b5b31a042386acc76ddetqdm-4.66.0.tar.gz"
    sha256 "cc6e7e52202d894e66632c5c8a9330bd0e3ff35d2965c93ca832114a3d865362"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages745be025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackagesd73368fe21c4a3ecf5e093b5179ea23be777037b1e83722f5559a1e2223d2422tzlocal-4.3.1.tar.gz"
    sha256 "ee32ef8c20803c19a96ed366addd3d4a729ef6309cb5c7359a0cc2eeeb7fa46a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese27d539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin"icloudpd --version")

    output = shell_output(bin"icloudpd -u brew -p brew --auth-only 2>&1", 1)
    assert_match "Authenticating...", output
  end
end