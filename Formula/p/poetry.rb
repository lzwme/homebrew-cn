class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https:python-poetry.org"
  url "https:files.pythonhosted.orgpackagesd4ff02f870cb68af7cf46a112c804920fbeea36b25d538e309e0ffc51238ed0bpoetry-2.0.0.tar.gz"
  sha256 "9416b1e3657ed02cda9599ae73b604bd68f187adaa2d8d1bcc804dacfa9bcd1f"
  license "MIT"
  head "https:github.compython-poetrypoetry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6ccd91fb39ef8c1ed34c3c57e386605dd6eda9cacb58125ed2ee28ca845c844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b4bf02a9e332045736e5d53a509bc3ca8bfdde1c8df6c43da4ec926b98cb6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "513a3999e085cc725d91a0a6397260a3172afb8965a5a3014d064318f89209b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4956f7e924cf087fdfc11193e99c21f6de20fdf8e2efa6ac54835fb6be5d78b7"
    sha256 cellar: :any_skip_relocation, ventura:       "aee811b0dd1b2e3a345b05f9d496cd7ec90600146a12c75af251e4b4d7daee77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fda728cd112eb92075aac884789478455f4487c4f7a4c3b48c36bd8f3f05140"
  end

  depends_on "cmake" => :build # for rapidfuzz
  depends_on "ninja" => :build # for rapidfuzz
  depends_on "certifi"
  depends_on "cffi"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "cryptography"
  end

  resource "build" do
    url "https:files.pythonhosted.orgpackages7d46aeab111f8e06793e4f0e421fcad593d547fb8313b50990f31681ee2fb1adbuild-1.2.2.post1.tar.gz"
    sha256 "b36993e92ca9375a219c99e606a122ff365a760a2d4bba0caa09bd5278b608b7"
  end

  resource "cachecontrol" do
    url "https:files.pythonhosted.orgpackagesd223db12e0b6b241e33f77f7cce01a06b4cc6f8071728656cc0ea262d2a14dadcachecontrol-0.14.1.tar.gz"
    sha256 "06ef916a1e4eb7dba9948cdfc9c76e749db2e02104a9a1277e8b642591a0f717"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
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
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "dulwich" do
    url "https:files.pythonhosted.orgpackages6757b4962be0410cf15dc7758fcc40337d09515cc74ac15e45d304f8b70c9b40dulwich-0.22.7.tar.gz"
    sha256 "d53935832dd182d4c1415042187093efcee988af5cd397fb1f394f5bb27f0707"
  end

  resource "fastjsonschema" do
    url "https:files.pythonhosted.orgpackages8b504b769ce1ac4071a1ef6d86b1a3fb56cdc3a37615e8c5519e1af96cdac366fastjsonschema-2.21.1.tar.gz"
    sha256 "794d4f0a58f848961ba16af7b9c85a3e88cd360df008c59aac6fc5ae9323b5d4"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "installer" do
    url "https:files.pythonhosted.orgpackages0518ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
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

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages7009d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37dkeyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages517865922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178fmore-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagescbd07555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4fmsgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackagesc9a5fa2432da887652e3a0c07661ebe4aabe7f4692936c742da489178acd34depkginfo-1.12.0.tar.gz"
    sha256 "8ad91a0445a036782b9366ef8b8c2c50291f83a553478ba8580c73d3215700cf"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "poetry-core" do
    url "https:files.pythonhosted.orgpackagesdbecdbd9cedc8b68309f1f4c0160355890b4f65f51901b31b1831dbf8c93d6c0poetry_core-2.0.0.tar.gz"
    sha256 "3317a3cc3932011a61114236b2d49883f4fb1403d2f5e97771ac0d077cfa396f"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackagese78228175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagesa4aa25e5a20131369d82c7b8288c99c2c3011ec47a3f5953ccc9cb8145720be5rapidfuzz-3.11.0.tar.gz"
    sha256 "a53ca4d3f52f00b393fab9b5913c5bafb9afc27d030c8a1db1283da6917a860f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "trove-classifiers" do
    url "https:files.pythonhosted.orgpackages998592c2667cf221b37648041ce9319427f92fa76cbec634aad844e67e284706trove_classifiers-2024.10.21.16.tar.gz"
    sha256 "17cbd055d67d5e9d9de63293a8732943fabc21574e4c7b74edf112b4928cf5f3"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages5039689abee4adc85aad2af8174bb195a819d0be064bf55fcc73b49d2b28ae77virtualenv-20.28.1.tar.gz"
    sha256 "5d34ab240fdb5d21549b76f9e8ff3af28252f5499fb6d6f031adac4e5a8c5329"
  end

  resource "xattr" do
    url "https:files.pythonhosted.orgpackages9e1afd9e33e145a9dffaf859c71a4aaa2bfce9cdbfe46d76b01d70729eecbcb5xattr-1.1.0.tar.gz"
    sha256 "fecbf3b05043ed3487a28190dec3e4c4d879b2fcec0e30bafd8ec5d4b6043630"
  end

  def install
    # poetry > filelock > hatchling, fix to `ZIP does not support timestamps before 1980` error
    ENV["SOURCE_DATE_EPOCH"] = Time.now.to_i.to_s

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