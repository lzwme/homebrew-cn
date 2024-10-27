class Icloudpd < Formula
  include Language::Python::Virtualenv

  desc "Tool to download photos from iCloud"
  homepage "https:github.comicloud-photos-downloadericloud_photos_downloader"
  # We use a git checkout as scriptspatch_version runs git commands to update SHA
  url "https:github.comicloud-photos-downloadericloud_photos_downloader.git",
      tag:      "v1.24.0",
      revision: "0e608f6fa412bbfa32fa711a73afad8070492991"
  license "MIT"
  head "https:github.comicloud-photos-downloadericloud_photos_downloader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94565c94aa0e30b0c6fe64ef0e33984a4e935760fd9d20f681643d2adf7a50d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a006608d738088edb6830ebb508cfa8b24697b201480a7f862d8584bae7ea27b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca89d5a2c8e0954282aa1c7952891b2cdd6fc987dc57d5635f789e3c888f4509"
    sha256 cellar: :any_skip_relocation, sonoma:        "e53841ecf3e85108dfef4d26acb3ff9f38c616dec83e909c743d73ce4451a065"
    sha256 cellar: :any_skip_relocation, ventura:       "5b3c8ec8054fd1d3043952484cc18b460206f08309e54696be8f2ba722751a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa4110cfabbb99557ddde3d631be03c1373262ba136ebbc3b7eaa343190100e"
  end

  depends_on "python@3.13"

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
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https:files.pythonhosted.orgpackagesab239894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
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
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages517865922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178fmore-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
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

  resource "srp" do
    url "https:files.pythonhosted.orgpackagesf4a3f74ae47c52ef866e3e454c3f863fb2a73eb41803d12d20349b62a3924f36srp-1.0.21.tar.gz"
    sha256 "866813bcf521189a1563e6ca3112b6f54fdf725a410a2dbebb6f0d84b82a1f1d"
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

  resource "Werkzeug" do
    url "https:files.pythonhosted.orgpackagesd4f90ba83eaa0df9b9e9d1efeb2ea351d0677c37d41ee5d0f91e98423c7281c9werkzeug-3.0.6.tar.gz"
    sha256 "a8dd59d4de28ca70471a34cba79bed5f7ef2e036a76b3ab0835474246eb41f8d"
  end

  # support python 3.13
  patch :DATA

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

__END__
diff --git apyproject.toml bpyproject.toml
index 5e60ee9..fb85dac 100644
--- apyproject.toml
+++ bpyproject.toml
@@ -10,7 +10,7 @@ version="1.23.4"
 name = "icloudpd"
 description = "icloudpd is a command-line tool to download photos and videos from iCloud."
 readme = "README_PYPI.md"
-requires-python = ">=3.8,<3.13"
+requires-python = ">=3.8,<3.14"
 keywords = ["icloud", "photo"]
 license = {file="LICENSE.md"}
 authors=[