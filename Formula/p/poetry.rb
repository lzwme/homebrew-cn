class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https:python-poetry.org"
  url "https:files.pythonhosted.orgpackages49a7f5fbce21ed8e5871c229864e9c2b588897e1aeb9431f024636252069245bpoetry-1.8.2.tar.gz"
  sha256 "49cceb3838104647c3e1021f3a4f13c6053704cc18d33f849a90fe687a29cb73"
  license "MIT"
  revision 1
  head "https:github.compython-poetrypoetry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9f13a7426b56601c4447790ae76dd0224e7a9372e9f5414d5a81604895dece5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "259092ba2eb9bb5b23c24cbcf028ed758d79e1b7ca1435f41e138d97a6dced48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f8d6f212f50f629b08686d711ac3ee5dacd6557c30b633dbfe5ea0d4549652"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7c7a4004c11ced725c8386f7075f3785427b9e627ee3683003f1df2e10e7484"
    sha256 cellar: :any_skip_relocation, ventura:        "a1833072d8f10e3bf0305c90b8ec524de956df73600e01a3126062e6c96247bb"
    sha256 cellar: :any_skip_relocation, monterey:       "54e372ca623e46300bb6db130a2517222ff9c610d55b7f1fca850088289296a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "694711f4450d20b0c374f3a3ece463aa5a65f3eef94d72a64ef3cf6ef0df2a0c"
  end

  depends_on "cmake" => :build # for rapidfuzz
  depends_on "certifi"
  depends_on "python@3.12"

  on_linux do
    depends_on "cryptography"
  end

  resource "build" do
    url "https:files.pythonhosted.orgpackagesce9e2d725d2f7729c6e79ca62aeb926492abbc06e25910dd30139d60a68bcb19build-1.2.1.tar.gz"
    sha256 "526263f4870c26f26c433545579475377b2b7588b6f1eac76a001e873ae3e19d"
  end

  resource "cachecontrol" do
    url "https:files.pythonhosted.orgpackages0655edea9d90ee57ca54d34707607d15c20f72576b96cb9f3e7fc266cb06b426cachecontrol-0.14.0.tar.gz"
    sha256 "7db1195b41c81f8274a7bbd97c956f44e8348265a1bc7641c37dfebc39f0c938"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
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

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "dulwich" do
    url "https:files.pythonhosted.orgpackages2be2788910715b4910d08725d480278f625e315c3c011eb74b093213363042e0dulwich-0.21.7.tar.gz"
    sha256 "a9e9c66833cea580c3ac12927e4b9711985d76afca98da971405d414de60e968"
  end

  resource "fastjsonschema" do
    url "https:files.pythonhosted.orgpackagesba7fcedf77ace50aa60c566deaca9066750f06e1fcf6ad24f254d255bb976dd6fastjsonschema-2.19.1.tar.gz"
    sha256 "e3126a94bdc4623d3de4485f8d468a12f02a67921315ddc87836d6e456dc789d"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagesdb973f028f216da17ab0500550a6bb0f26bf39b07848348f63cce44b89829af9filelock-3.13.3.tar.gz"
    sha256 "a79895a25bbefdf55d1a2a0a80968f7dbb28edcd6d4234a0afb3f37ecde4b546"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "installer" do
    url "https:files.pythonhosted.orgpackages0518ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackagesae6cbd2cfc6c708ce7009bdb48c85bb8cad225f5638095ecc8f49f15e8e1f35ekeyring-24.3.1.tar.gz"
    sha256 "c3327b6ffafc0e8befbdb597cacdb4928ffe5c1212f7645f186e6d9957a898db"
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

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackages2f72347ec5be4adc85c182ed2823d8d1c7b51e13b9a6b0c1aae59582eca652dfpkginfo-1.10.0.tar.gz"
    sha256 "5df73835398d10db79f8eecd5cd86b1f6d29317589ea70796994d49399af6297"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "poetry-core" do
    url "https:files.pythonhosted.orgpackagesf2db20a9f9cae3f3c213a8c406deb4395698459fd96962cea8f2ccb230b1943cpoetry_core-1.9.0.tar.gz"
    sha256 "fa7a4001eae8aa572ee84f35feb510b321bd652e5cf9293249d62853e1f935a2"
  end

  resource "poetry-plugin-export" do
    url "https:files.pythonhosted.orgpackages68d8b3320a09e3051d3cc9c3e47bccb50bc3cb651de88ce8434e61d231ff041dpoetry_plugin_export-1.7.1.tar.gz"
    sha256 "cf62cfb6218a904290ba6db3bc1a24aa076d10f81c48c6e48b2ded430131e22e"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackages25c1374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64cpyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackages6575e52ee00ebf8c13f8ca60b61641dfc1b8786b0d0d2fd4065cb337c861fe3erapidfuzz-3.7.0.tar.gz"
    sha256 "620df112c39c6d27316dc1e22046dc0382d6d91fd60d7c51bd41ca0333d867e9"
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
    url "https:files.pythonhosted.orgpackages7d494c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "trove-classifiers" do
    url "https:files.pythonhosted.orgpackagesc5e91deb1b8113917aa735b08ef21821f3533bda2eb1fa1a16e07256dd05918ftrove-classifiers-2024.3.25.tar.gz"
    sha256 "6de68d06edd6fec5032162b6af22e818a4bb6f4ae2258e74699f8a41064b7cad"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages934fa7737e177ab67c454d7e60d48a5927f16cd05623e9dd888f78183545d250virtualenv-20.25.1.tar.gz"
    sha256 "e08e13ecdca7a0bd53798f356d5831434afa5b07b93f0abdf0797b7a06ffe197"
  end

  resource "xattr" do
    url "https:files.pythonhosted.orgpackages9e1afd9e33e145a9dffaf859c71a4aaa2bfce9cdbfe46d76b01d70729eecbcb5xattr-1.1.0.tar.gz"
    sha256 "fecbf3b05043ed3487a28190dec3e4c4d879b2fcec0e30bafd8ec5d4b6043630"
  end

  resource "jeepney" do
    on_linux do
      url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end
  end

  resource "SecretStorage" do
    on_linux do
      url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  def install
    virtualenv_install_with_resources

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