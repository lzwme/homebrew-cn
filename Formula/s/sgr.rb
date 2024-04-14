class Sgr < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for Splitgraph, a version control system for data"
  homepage "https:www.splitgraph.comdocssgr-advancedgetting-startedintroduction"
  url "https:files.pythonhosted.orgpackagesdd617d6cf822edb39d2426f6f185c7fc4de0ad4b80e0da3e5f50d94952795c11splitgraph-0.3.12.tar.gz"
  sha256 "76a4476002b5ac5a2b9fba36b6fcffd85b878bcc25f5aae411387e04a5532459"
  license "Apache-2.0"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a40d60f1505940418d5e3012f29e5d1dd58040c13a3088c1241cb8b4b9007c13"
    sha256 cellar: :any,                 arm64_ventura:  "d8b0292bbd0e4e77bf3305f63dc5d2fd6573ab5284faeab5064b17933a033047"
    sha256 cellar: :any,                 arm64_monterey: "96b785c4043166c0ce34bd2617024361950b81002491301e580a7b02a89783ec"
    sha256 cellar: :any,                 sonoma:         "370a1384107cbab95ea76d9c409c0882806d3be448e72657edf11838e1ede04c"
    sha256 cellar: :any,                 ventura:        "9fdd1b8fcdd8297dd64b7ceb2d8d0a9794c04d5e77c17ddba7d906800accb02c"
    sha256 cellar: :any,                 monterey:       "9636cdb7c3e359ab1ebe3d6f9c2033e53231de91ad21d3a219fa0d665070d741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "448fa6317562d243740ecaffb832af35e40cc8d879f66b3619a8e50e6cb49e0c"
  end

  depends_on "cython" => :build # TODO: remove with newer `pglast` (4.4+)
  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libpq" # for psycopg2-binary
  depends_on "python@3.12"

  # Manually update `pglast` from ==3.4 to support python 3.11
  # https:github.comsplitgraphsgrpull814

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "argon2-cffi" do
    url "https:files.pythonhosted.orgpackages31fa57ec2c6d16ecd2ba0cf15f3c7d1c3c2e7b5fcb83555ff56d7ab10888ec8fargon2_cffi-23.1.0.tar.gz"
    sha256 "879c3e79a2729ce768ebb7d36d4609e3a78a4ca2ec3a9f12286ca057e3d0db08"
  end

  resource "argon2-cffi-bindings" do
    url "https:files.pythonhosted.orgpackagesb9e9184b8ccce6683b0aa2fbb7ba5683ea4b9c5763f1356347f1312c32e3c66eargon2-cffi-bindings-21.2.0.tar.gz"
    sha256 "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3"
  end

  resource "asciitree" do
    url "https:files.pythonhosted.orgpackages2d6a885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesee2d9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages276fbe940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720eclick-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages3232228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages25147d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bcdocker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "inflection" do
    url "https:files.pythonhosted.orgpackagese17e691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "joblib" do
    url "https:files.pythonhosted.orgpackages7cc394c9e4886e8f33832690ab48fdac4a121a7bfec3e2c044c9f2762aa9068ejoblib-1.4.0.tar.gz"
    sha256 "1eb0dc091919cd384490de890cb5dfd538410a6d4b3b54eef09fb8c50b409b1c"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages4dc53f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9bejsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "minio" do
    url "https:files.pythonhosted.orgpackages218fbb5090471700cb300c15c296928035627b6ce8fcd2c1668a963a555ae9b7minio-7.2.5.tar.gz"
    sha256 "59d8906e2da248a9caac34d4958a859cc3a44abbe6447910c82b5abfa9d6a2e1"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "parsimonious" do
    url "https:files.pythonhosted.orgpackages02fc067a3f89869a41009e1a7cdfb14725f8ddd246f30f63c645e8ef8a1c56f4parsimonious-0.8.1.tar.gz"
    sha256 "3add338892d580e0cb3b1a39e4a1b427ff9f687858fdd61097053742391a9f6b"
  end

  resource "pglast" do
    url "https:files.pythonhosted.orgpackages88df201bb63cd9777007b89070b23e6bfb00e6da0ef2cbb9d8a4fd3df4c257e1pglast-3.4.tar.gz"
    sha256 "d2288d9607097a08529d9165970261c1be956934e8a8f6d9ed2a96d9b8f03fc6"
  end

  resource "psycopg2-binary" do
    url "https:files.pythonhosted.orgpackagesfc07e720e53bfab016ebcc34241695ccc06a9e3d91ba19b40ca81317afbdc440psycopg2-binary-2.9.9.tar.gz"
    sha256 "7f01846810177d829c7692f1f5ada8096762d9172af1b1a28d4ab5b77c923c1c"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagescdfc70fe71ff78f680d584eba9c55a30092f6ef0b9cf0c75a74bd35a24151a83pydantic-2.7.0.tar.gz"
    sha256 "b5ecdd42262ca2462e2624793551e80911a1e989f462910bb81aef974b4bb383"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages3d28d693aab237fca82da327990a88a983b2b84b890032076ee4a87e18038dbbpydantic_core-2.18.1.tar.gz"
    sha256 "de9d3e8717560eb05e28739d1b35e4eac2e458553a52a301e51352a7ffc86a35"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages59d748b862b8133da2e0ed091195028f0d45c4d0be0f7f23dbe046a767282f37referencing-0.34.0.tar.gz"
    sha256 "5773bd84ef41799a5a8ca72dc34590c041eb01bf9aa02632b4a973fb0181a844"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages55bace7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5erpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesd1d6eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4d5bdc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83dsetuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sodapy" do
    url "https:files.pythonhosted.orgpackagesad1ed01ef2bc1b6199edfb0d00302fe3642d61a09175dd3e78832c78301b2ab6sodapy-2.2.0.tar.gz"
    sha256 "58af376d3bb0dc3a1edc7c8cf9938f5de8f558b35e240438dd83647ac3621981"
  end

  resource "splitgraph-pipelinewise-target-postgres" do
    url "https:files.pythonhosted.orgpackages5954de6a8a2b6bdb24de8d8fd4a2465532f3523abc750af4dd9d6e5c17ce6a53splitgraph-pipelinewise-target-postgres-2.1.0.tar.gz"
    sha256 "9d100ac65288ce24a90da159bbbb06f0fdc0871c2815c63bb6417fea7df4894f"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # Remove when mergedreleased: https:github.comsplitgraphsgrpull813
  patch do
    url "https:github.comsplitgraphsgrcommit234bcc12d21860852a40e78a22976ae33d2f2f57.patch?full_index=1"
    sha256 "1308f9172de2268cadc7ae7521a0f109df3cdc40d60f4908d69934acb777a2d5"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # TODO: remove with newer `pglast` (4.4+)
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexecLanguage::Python.site_packages("python3.12")

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("setuptools")
    venv.pip_install resources.reject { |r| r.name == "setuptools" }
    venv.pip_install_and_link buildpath

    generate_completions_from_executable(bin"sgr", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    sgr_status = shell_output("#{bin}sgr cloud login --username homebrewtest --password correcthorsebattery 2>&1", 2)
    assert_match "error: splitgraph.exceptions.AuthAPIError", sgr_status
    assert_match version.to_s, shell_output("#{bin}sgr --version")
  end
end