class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https:python-poetry.org"
  url "https:files.pythonhosted.orgpackages07c741108195c39ac1010054ef6b3b445894cee79e8ec73f086b73da94a01901poetry-1.8.3.tar.gz"
  sha256 "67f4eb68288eab41e841cc71a00d26cf6bdda9533022d0189a145a34d0a35f48"
  license "MIT"
  revision 1
  head "https:github.compython-poetrypoetry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "678bf3dee708ca83dc587ce27e1b8447506ac1880b8e5528688c9f7b689f308b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b1f91274eebb69bd6461c4a1799d25200b9005f1f9a81b6adf77853b4b53239"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19a843ffce3c4d487bd246d11d0932e332109940bd396373624c7802fdadba0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "48dfec40de8faa444105777ec6f2aa82bdb2eef5d4f74111f262f811e76114b3"
    sha256 cellar: :any_skip_relocation, ventura:        "a0051b2960c3a22ded389a249601648dd3d04b9eae826ef45b6ad7c4e6d504be"
    sha256 cellar: :any_skip_relocation, monterey:       "6ee649027732251328099af8f848b2d0c8da9ef26d7632a0d4d0f54fc3cfe0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd5bec6efbef0a20ff62a0018a1534b5d164b0d5acd77b0cc0ae6068d893fc94"
  end

  depends_on "cmake" => :build # for rapidfuzz
  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "libffi"

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
    url "https:files.pythonhosted.orgpackages06aef8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897eafilelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "installer" do
    url "https:files.pythonhosted.orgpackages0518ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
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
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "poetry-core" do
    url "https:files.pythonhosted.orgpackagesf2db20a9f9cae3f3c213a8c406deb4395698459fd96962cea8f2ccb230b1943cpoetry_core-1.9.0.tar.gz"
    sha256 "fa7a4001eae8aa572ee84f35feb510b321bd652e5cf9293249d62853e1f935a2"
  end

  resource "poetry-plugin-export" do
    url "https:files.pythonhosted.orgpackages81bf270ef984c6f4b610a22a6948096b6b9d949de8f77c4c427d981c530ac521poetry_plugin_export-1.8.0.tar.gz"
    sha256 "1fa6168a85d59395d835ca564bc19862a7c76061e60c3e7dfaec70d50937fc61"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackagesc7076f63dda440d4abb191b91dc383b472dae3dd9f37e4c1e4a5c3db150531c6pyproject_hooks-1.1.0.tar.gz"
    sha256 "4b37730834edbd6bd37f26ece6b44802fb1c1ee2ece0e54ddff8bfc06db86965"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagese8949cf5188f6e13e58dec8a1f9f6bb201a66b42108de39ad239f6556ea7fc87rapidfuzz-3.9.1.tar.gz"
    sha256 "a42eb645241f39a59c45a7fc15e3faf61886bff3a4a22263fd0f7cfb90e91b7f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages86ec535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392dbrequests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages2bab18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "trove-classifiers" do
    url "https:files.pythonhosted.orgpackagesb98d7899dd731149418618522eb6846acae3f0edf0823d7ae54bb732d4140c95trove_classifiers-2024.5.17.tar.gz"
    sha256 "d47a6f1c48803091c3fc81f535fecfeef65b558f2b9e4e83df7a79d17bce8bbf"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages445acabd5846cb550e2871d9532def625d0771f4e38f765c30dc0d101be33697virtualenv-20.26.2.tar.gz"
    sha256 "82bf0f4eebbb78d36ddaee0283d43fe5736b53880b8a8cdcd37390a07ac3741c"
  end

  resource "xattr" do
    url "https:files.pythonhosted.orgpackages9e1afd9e33e145a9dffaf859c71a4aaa2bfce9cdbfe46d76b01d70729eecbcb5xattr-1.1.0.tar.gz"
    sha256 "fecbf3b05043ed3487a28190dec3e4c4d879b2fcec0e30bafd8ec5d4b6043630"
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