class Icloudpd < Formula
  include Language::Python::Virtualenv

  desc "Tool to download photos from iCloud"
  homepage "https:github.comicloud-photos-downloadericloud_photos_downloader"
  # We use a git checkout as scriptspatch_version runs git commands to update SHA
  url "https:github.comicloud-photos-downloadericloud_photos_downloader.git",
      tag:      "v1.23.4",
      revision: "6e9c6c69996a39d0e7f77c9fd4f9b160b4b8bcdd"
  license "MIT"
  head "https:github.comicloud-photos-downloadericloud_photos_downloader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cfc84701b4d11324a7acdb9487ddc61e61f99a99024e5606381819cc7b5c1736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75bca52db6cc9ce7257ab5c617f82fe329ec87187a652331add4d40903711fc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30c3a36c8233f1906e03e51d6f10216d15b5b860e87946a32ffe25e7fe08071a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3ff85682f06bffc8b225e779df95b5360110efd3f3a9df075b20ef1f1591ac4"
    sha256 cellar: :any_skip_relocation, sonoma:         "03aa950b22125359d93ca6b0eba7d7452970309c61c26acb499612f339c5184a"
    sha256 cellar: :any_skip_relocation, ventura:        "e7fcffe1ee76ac6899c1d6253b709ce45b885e59cafee78ef80a1f1be0a6b289"
    sha256 cellar: :any_skip_relocation, monterey:       "932fd0308f570ef06466c8592109864686bdf61771acfa31120aead0f887626f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f35f0053a2ebc7829b0f4fc9b3cd6ed3040ed07979a9979f5f15d8e390f6bfe"
  end

  depends_on "python@3.12"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages1e57a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abccblinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

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

  resource "flask" do
    url "https:files.pythonhosted.orgpackages41e1d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829aflask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https:files.pythonhosted.orgpackagesdfadf3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackages03b16ca3c2052e584e9908a2c146f00378939b3c51b839304ab8ef4de067f042jaraco_functools-4.0.2.tar.gz"
    sha256 "3460c74cd0d32bf82b9576bbb3527c4364d5b27a21f5158a62aed6c4b42e23f5"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages3ee954f232e659f635a000d94cfbca40b9d5d617707593c3d552ec14d3ba27f1keyring-25.2.1.tar.gz"
    sha256 "daaffd42dbda25ddafb1ad5fec4024e5bbcfe424597ca1ca452b299861e49f1b"
  end

  resource "keyrings-alt" do
    url "https:files.pythonhosted.orgpackages4f557a52c9961f607353034945692c700ab648f18ea2ab2d509e248b24cb0a91keyrings.alt-5.0.1.tar.gz"
    sha256 "cd372a1ec446a1bc5a90624a52c88e83b9330218e39047a6c9a48ae37d116745"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages920dad6a82320cb8eba710fd0dceb0f678d5a1b58d67d03ae5be14874baa39e0more-itertools-10.4.0.tar.gz"
    sha256 "fe0e63c4ab068eac62410ab05cccca2dc71ec44ba8ef29916a0090df061cf923"
  end

  resource "piexif" do
    url "https:files.pythonhosted.orgpackagesfa84a3f25cec7d0922bf60be8000c9739d28d24b6896717f44cc4cfb843b1487piexif-1.1.3.zip"
    sha256 "83cb35c606bf3a1ea1a8f0a25cb42cf17e24353fd82e87ae3884e74a302a5f1b"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
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
    url "https:files.pythonhosted.orgpackages5ac0b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackagesb2e2adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0atzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese27d539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "waitress" do
    url "https:files.pythonhosted.orgpackages7034cb77e5249c433eb177a11ab7425056b32d3b57855377fa1e38b397412859waitress-3.0.0.tar.gz"
    sha256 "005da479b04134cdd9dd602d1ee7c49d79de0537610d653674cc6cbde222b8a1"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages0fe26dbcaab07560909ff8f654d3a2e5a60552d937c909455211b1b36d7101dcwerkzeug-3.0.4.tar.gz"
    sha256 "34f2371506b250df4d4f84bfe7b0921e4762525762bbd936614909fe25cd7306"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec"gnubin" if OS.mac?
    # https:github.comicloud-photos-downloadericloud_photos_downloaderissues922#issuecomment-2252928501
    system "scriptspatch_version"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin"icloudpd --version")

    output = shell_output(bin"icloudpd -u brew -p brew --auth-only 2>&1", 1)
    assert_match "Authenticating...", output
  end
end