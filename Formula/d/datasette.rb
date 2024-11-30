class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https:docs.datasette.ioenstable"
  url "https:files.pythonhosted.orgpackagesdb94e6408997861e9de3ec61fb8107efe9eaf70f765ad2cd4e20b552dd340899datasette-0.65.1.tar.gz"
  sha256 "d8be37ae6dafbfd8e510d49c0dc0fc6696081614d048a507eed86dd2ae433223"
  license "Apache-2.0"
  head "https:github.comsimonwdatasette.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3e07b49500699363cae246158a158e1f49481e242230ca143d954502a7ee42d"
    sha256 cellar: :any,                 arm64_sonoma:  "a2ffead369982578010ca2381615c9c4a25ad4bb84b31952f14c614c5ad7b59a"
    sha256 cellar: :any,                 arm64_ventura: "dc56f27b69113719b7fa56a342439df5cda1ef0d6f680ed8ddf451903823cb34"
    sha256 cellar: :any,                 sonoma:        "24adb7ab51ce174b02babc9ca3054c01a894b709f9d7c1680e49332e18aef7a6"
    sha256 cellar: :any,                 ventura:       "94ea5b9910aa0b318ceda4c908b7379e982a345af18eacc7f0455e587d097a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e1238b5439723d5acc916070bb8c063475f9e2f96fe85c0ee86cc3ac7ae7b3"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackages0b03a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages9f0945b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546ccanyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
  end

  resource "asgi-csrf" do
    url "https:files.pythonhosted.orgpackages0a592b54a274b9c9cbe1c0edbe5d324925ffd88a31567fb50dc2138e0160bdefasgi_csrf-0.11.tar.gz"
    sha256 "e19a4f87d5af3feabde04c57921ee15510c3bfb0565627df9cb20bcb303282c2"
  end

  resource "asgiref" do
    url "https:files.pythonhosted.orgpackages2938b3395cc9ad1b56d2ddac9970bc8f4141312dbaec28bc7c218b0dfafd0f42asgiref-3.8.1.tar.gz"
    sha256 "c343bd80a0bec947a9860adb4c432ffa7db769836c64238fc34bdc3fec84d590"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "flexcache" do
    url "https:files.pythonhosted.orgpackages55b08a21e330561c65653d010ef112bf38f60890051d244ede197ddaa08e50c1flexcache-0.3.tar.gz"
    sha256 "18743bd5a0621bfe2cf8d519e4c3bfdf57a269c15d1ced3fb4b64e0ff4600656"
  end

  resource "flexparser" do
    url "https:files.pythonhosted.orgpackages8299b4de7e39e8eaf8207ba1a8fa2241dd98b2ba72ae6e16960d8351736d8702flexparser-0.4.tar.gz"
    sha256 "266d98905595be2ccc5da964fe0a2c3526fbbffdc45b65b3146d75db992ef6b2"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages6a41d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages10df676b7cf674dd1bdc71a64ad393c89879f75e4a0ab8395165b498262ae106httpx-0.28.0.tar.gz"
    sha256 "0858d3bab51ba7e386637f22a61d8ccddaeec5f3fe4209da3a6168dbb91573e0"
  end

  resource "hupper" do
    url "https:files.pythonhosted.orgpackagesbde6bb064537288eee2be97f3e0fcad8e7242bc5bbe9664ae57c7d29b3fa18c2hupper-1.12.1.tar.gz"
    sha256 "06bf54170ff4ecf4c84ad5f188dee3901173ab449c2608ad05b9bfd6b13e32eb"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "janus" do
    url "https:files.pythonhosted.orgpackages4550112a19f28a11b545c4c95de29c50a06fa9381a2432eaabbf9316bbd4e046janus-1.1.0.tar.gz"
    sha256 "0634df8b2b31f8afda4311abcf7fea912686fef717d13769eeaa01ae08d2b84c"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "python-multipart" do
    url "https:files.pythonhosted.orgpackagesb486b6b38677dec2e2e7898fc5b6f7e42c2d011919a92d25339451892f27b89cpython_multipart-0.0.18.tar.gz"
    sha256 "7a68db60c8bfb82e460637fa4750727b45af1d5e2ed215593f917f64694d34fe"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackages6a3c21dba3e7d76138725ef307e3d7ddd29b763119b3aa459d02cc05fefcff75uvicorn-0.32.1.tar.gz"
    sha256 "ee9519c246a72b1c084cea8d3b44ed6026e78a4a309cbedae9c37e4cb9fbb175"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"datasette", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}datasette --get '_memory.json?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}datasette --get ''")
  end
end