class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https:python-poetry.org"
  url "https:files.pythonhosted.orgpackagesbbcfcfdd5ab997bdb51a29c5f1d1925c409c58d5e504062c105dc0d82ec9e7c5poetry-1.7.1.tar.gz"
  sha256 "b348a70e7d67ad9c0bd3d0ea255bc6df84c24cf4b16f8d104adb30b425d6ff32"
  license "MIT"
  head "https:github.compython-poetrypoetry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ffdfeeaff0a39739f4c90caaaa36409e224aacf80b51f62466cfa9bc42aa33b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f00fe9babab6dcad108435346338e3b353394227cb898ad1ce04665a25fd5f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce6c94a1846e65ff0326b52da6e5520a7f543cc4dfa3028d33e0e0841a921ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bc4d7b3e9b32b171088621cadd8c7afbea2295314e787ac06a52aff0ddc1f33"
    sha256 cellar: :any_skip_relocation, ventura:        "308fdee590d8e6e81ae01c4b94644d46f49bdb69032fab33cf1d1f0bf3d8dc75"
    sha256 cellar: :any_skip_relocation, monterey:       "d1216894867d26bfe0d87907549ba90cd86376115cda46f4d8dccdb0d0480bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c5156ba2456994a4337332a1694414f1d2e8e3ff885c5fb74ba0dff370d51b6"
  end

  depends_on "cmake" => :build # for rapidfuzz
  depends_on "cffi"
  depends_on "keyring"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "build" do
    url "https:files.pythonhosted.orgpackages98e383a89a9d338317f05a68c86a2bbc9af61235bc55a0c6a749d37598fb2af1build-1.0.3.tar.gz"
    sha256 "538aab1b64f9828977f84bc63ae570b060a8ed1be419e7870b8b4fc5e6ea553b"
  end

  resource "cachecontrol" do
    url "https:files.pythonhosted.orgpackages9e653356cfc87bdee0cdf62d941235e936a26c205e4f1e1f2c85dbd952d7533acachecontrol-0.13.1.tar.gz"
    sha256 "f012366b79d2243a6118309ce73151bf52a38d4a5dac8ea57f09bd29087e506b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cleo" do
    url "https:files.pythonhosted.orgpackages3c30f7960ed7041b158301c46774f87620352d50a9028d111b4211187af13783cleo-2.1.0.tar.gz"
    sha256 "0b2c880b5d13660a7ea651001fb4acb527696c01f15c9ee650f377aa543fd523"
  end

  resource "crashtest" do
    url "https:files.pythonhosted.orgpackages6e5dd79f51058e75948d6c9e7a3d679080a47be61c84d3cc8f71ee31255eb22bcrashtest-0.4.1.tar.gz"
    sha256 "80d7b1f316ebfbd429f648076d6275c877ba30ba48979de4191714a75266f0ce"
  end

  resource "dulwich" do
    url "https:files.pythonhosted.orgpackages57e01b5f95c2651284a5d4fdfb2cc5ecad57fb694084cce59d9d4acb7ac30ecfdulwich-0.21.6.tar.gz"
    sha256 "30fbe87e8b51f3813c131e2841c86d007434d160bd16db586b40d47f31dd05b0"
  end

  resource "fastjsonschema" do
    url "https:files.pythonhosted.orgpackages7a615fc12c3a9b206e2d85399253ecbe602a753bfb54ae891bc74819ab594312fastjsonschema-2.19.0.tar.gz"
    sha256 "e25df6647e1bc4a26070b700897b07b542ec898dd4f1f6ea013e7f6a88417225"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "installer" do
    url "https:files.pythonhosted.orgpackages0518ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagesc2d55662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackagese59bff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackagesb41c89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "poetry-core" do
    url "https:files.pythonhosted.orgpackages36666af2891495d12020419c8447d0b29c1e96f3be16631faaed6bda5b886d5dpoetry_core-1.8.1.tar.gz"
    sha256 "67a76c671da2a70e55047cddda83566035b701f7e463b32a2abfeac6e2a16376"
  end

  resource "poetry-plugin-export" do
    url "https:files.pythonhosted.orgpackagesc4360beed6661369e86447f3550d1d5df529591e046583079dffac10dc86ed21poetry_plugin_export-1.6.0.tar.gz"
    sha256 "091939434984267a91abf2f916a26b00cff4eee8da63ec2a24ba4b17cf969a59"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackages25c1374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64cpyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackages8bf3bf5e82eca3b88853a5fe596bf8c94fb6f2775dc1b55b7bfee9de21afab03rapidfuzz-3.5.2.tar.gz"
    sha256 "9e9b395743e12c36a3167a3a9fd1b4e11d92fb0aa21ec98017ee6df639ed385e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesdffc1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "trove-classifiers" do
    url "https:files.pythonhosted.orgpackagesbcca877e9b50c0092e6a9df860901309d9ec70e7dd0b077ee9bedc8bab24bb7ftrove-classifiers-2023.11.14.tar.gz"
    sha256 "64b5e78305a5de347f2cd7ec8c12d704a3ef0cb85cc10c0ca5f73488d1c201f8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "xattr" do
    url "https:files.pythonhosted.orgpackagesa019dfb42dd6e6749c6e6dde55b12ee44b3c8247c3cfa5b85180a60902722538xattr-0.10.1.tar.gz"
    sha256 "c12e7d81ffaa0605b3ac8c22c2994a8e18a9cf1c59287a1b7722a2289c952ec5"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[keyring virtualenv].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(bin"poetry", "completions")
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    # The poetry add command would fail in CI when keyring is enabled
    # https:github.comHomebrewhomebrew-corepull109777#issuecomment-1248353918
    ENV["PYTHON_KEYRING_BACKEND"] = "keyring.backends.null.Keyring"

    assert_match version.to_s, shell_output("#{bin}poetry --version")
    assert_match "Created package", shell_output("#{bin}poetry new homebrew")

    cd testpath"homebrew" do
      system bin"poetry", "config", "virtualenvs.in-project", "true"
      system bin"poetry", "add", "requests"
      system bin"poetry", "add", "boto3"
    end

    assert_predicate testpath"homebrewpyproject.toml", :exist?
    assert_predicate testpath"homebrewpoetry.lock", :exist?
    assert_match "requests", (testpath"homebrewpyproject.toml").read
    assert_match "boto3", (testpath"homebrewpyproject.toml").read
  end
end