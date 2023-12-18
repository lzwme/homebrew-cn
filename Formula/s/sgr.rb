class Sgr < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for Splitgraph, a version control system for data"
  homepage "https:www.splitgraph.comdocssgr-advancedgetting-startedintroduction"
  url "https:files.pythonhosted.orgpackagesdd617d6cf822edb39d2426f6f185c7fc4de0ad4b80e0da3e5f50d94952795c11splitgraph-0.3.12.tar.gz"
  sha256 "76a4476002b5ac5a2b9fba36b6fcffd85b878bcc25f5aae411387e04a5532459"
  license "Apache-2.0"
  revision 7

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b7423a19b5c73b05156cb6f103da47d6da9e5c3629cfa9d766f39fd4c938a887"
    sha256 cellar: :any,                 arm64_ventura:  "0786ad206e8301d3fcb3bc0949be66edc26584d8c19b96e014236a33e3f844c1"
    sha256 cellar: :any,                 arm64_monterey: "e5d62ed8c6052078acf202e807db3bb8d11c31708344c65f882927f9810c3f02"
    sha256 cellar: :any,                 sonoma:         "09798654656e8168a31b78da9dcd4ed47c945052a137b170e78a718b4223ee1f"
    sha256 cellar: :any,                 ventura:        "c4d73607d7b50aee13015c00cadd78193108be82591509212342e06dff781b36"
    sha256 cellar: :any,                 monterey:       "366c2b32058d052ff060cbeff5f1293f939d4c33965b1038c03aaed7fed26ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d28850d676f34dafeb69e9357b3e7c33a285b127a6ddf9466df54298dcb6b1d"
  end

  depends_on "libcython" => :build # TODO: remove with newer `pglast` (4.4+)
  depends_on "rust" => :build # for pydantic
  depends_on "libpq" # for psycopg2-binary
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  # Manually update `pglast` from ==3.4 to support python 3.11
  # https:github.comsplitgraphsgrpull814

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "asciitree" do
    url "https:files.pythonhosted.orgpackages2d6a885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesee2d9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https:files.pythonhosted.orgpackagesf073f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5edocker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "inflection" do
    url "https:files.pythonhosted.orgpackagese17e691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "joblib" do
    url "https:files.pythonhosted.orgpackages150fd3b33b9f106dddef461f6df1872b7881321b247f3d255b87f61a7636f7fejoblib-1.3.2.tar.gz"
    sha256 "92f865e621e17784e7955080b6d042489e3b8e294949cc44c6eac304f59772b1"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagese443087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages12ceeb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "minio" do
    url "https:files.pythonhosted.orgpackages6872b81f61f4d03d319022d52928177f8f32b598531d1cf02f13f06264df7a65minio-7.1.17.tar.gz"
    sha256 "b0b687c1ec9be422a1f8b04c65fb8e43a1c090f9508178db57c434a17341c404"
  end

  resource "parsimonious" do
    url "https:files.pythonhosted.orgpackages02fc067a3f89869a41009e1a7cdfb14725f8ddd246f30f63c645e8ef8a1c56f4parsimonious-0.8.1.tar.gz"
    sha256 "3add338892d580e0cb3b1a39e4a1b427ff9f687858fdd61097053742391a9f6b"
  end

  resource "pglast" do
    url "https:files.pythonhosted.orgpackages3ba84d85067f06f13e8199dcf1efc57668e7e45160f618ae47864e98560c7b16pglast-3.17.tar.gz"
    sha256 "0b6496b97e8bb7847adab90d27da8ea152b9d23f93524868194c3eb1e5a34d0c"
  end

  resource "psycopg2-binary" do
    url "https:files.pythonhosted.orgpackagesfc07e720e53bfab016ebcc34241695ccc06a9e3d91ba19b40ca81317afbdc440psycopg2-binary-2.9.9.tar.gz"
    sha256 "7f01846810177d829c7692f1f5ada8096762d9172af1b1a28d4ab5b77c923c1c"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesdfe84f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesaf318e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6ecapydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackagese143d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbbreferencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackagesee12d6cfa2699916e5ece53a42e486e03b5a14e672c76ddb16d4649efcf9efb8rpds_py-0.10.6.tar.gz"
    sha256 "4ce5a708d65a8dbf3748d2474b580d606b1b9f91b5c6ab2a316e0b0cf7a4ba50"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesde7d4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "sodapy" do
    url "https:files.pythonhosted.orgpackagesad1ed01ef2bc1b6199edfb0d00302fe3642d61a09175dd3e78832c78301b2ab6sodapy-2.2.0.tar.gz"
    sha256 "58af376d3bb0dc3a1edc7c8cf9938f5de8f558b35e240438dd83647ac3621981"
  end

  resource "splitgraph-pipelinewise-target-postgres" do
    url "https:files.pythonhosted.orgpackages5954de6a8a2b6bdb24de8d8fd4a2465532f3523abc750af4dd9d6e5c17ce6a53splitgraph-pipelinewise-target-postgres-2.1.0.tar.gz"
    sha256 "9d100ac65288ce24a90da159bbbb06f0fdc0871c2815c63bb6417fea7df4894f"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagescbeb19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # Remove when mergedreleased: https:github.comsplitgraphsgrpull813
  patch do
    url "https:github.comsplitgraphsgrcommit234bcc12d21860852a40e78a22976ae33d2f2f57.patch?full_index=1"
    sha256 "1308f9172de2268cadc7ae7521a0f109df3cdc40d60f4908d69934acb777a2d5"
  end

  def install
    # TODO: remove with newer `pglast` (4.4+)
    ENV.append_path "PYTHONPATH", Formula["libcython"].opt_libexecLanguage::Python.site_packages("python3.12")

    virtualenv_install_with_resources

    generate_completions_from_executable(bin"sgr", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    sgr_status = shell_output("#{bin}sgr cloud login --username homebrewtest --password correcthorsebattery 2>&1", 2)
    assert_match "error: splitgraph.exceptions.AuthAPIError", sgr_status
    assert_match version.to_s, shell_output("#{bin}sgr --version")
  end
end