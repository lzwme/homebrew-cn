class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https:harlequin.sh"
  url "https:files.pythonhosted.orgpackagesaedc5661096405bd9987a6a194b027fbfdf5bf6649299c2179b7cfe220084215harlequin-2.0.0.tar.gz"
  sha256 "d9bb419859bf35263e0a6875592b72b81f4aab70373a55c937cfc608c38585cd"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a0a478c8a8b76df2fed9160ca3942f434212af647702688518fb14c423155c0d"
    sha256 cellar: :any,                 arm64_sonoma:  "6073226f8a06d09a1854d9322da3084aa3502458e02427309c91386063ee4cae"
    sha256 cellar: :any,                 arm64_ventura: "5c43b0250284ef8e3e0d7ceb71341fc1743fc4f05b46beb28d207465f2c4a5bd"
    sha256 cellar: :any,                 sonoma:        "6f1ea2544477ee6e2ab84fd14b187068be67730f592be0c0ffbb226ca092a773"
    sha256 cellar: :any,                 ventura:       "ec5cce6a60052237b052c6eec3dcdb447f9da3cb327f9c2cb572c186dc97536e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ef82b4eaf2e0f1f16eab83ef467feee0de734a4a145facc8fa42ee7b74a688"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "apache-arrow"
  depends_on "libpq" # psycopg
  depends_on "python@3.13"
  depends_on "unixodbc" # harlequin-odbc

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cython" do
    url "https:files.pythonhosted.orgpackages844db720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aacython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  resource "duckdb" do
    url "https:files.pythonhosted.orgpackagesa0d7ec014b351b6bb026d5f473b1d0ec6bd6ba40786b9abbf530b4c9041d9895duckdb-1.1.3.tar.gz"
    sha256 "68c3a46ab08836fe041d15dcbf838f74a990d551db47cb24ab1c4576fc19351c"
  end

  resource "harlequin-mysql" do
    url "https:files.pythonhosted.orgpackages8a214301627383d091e16190ec3d4271974fe37c840eb3f7c9cd794e984371f4harlequin_mysql-1.0.0.tar.gz"
    sha256 "8e1f8d391e0980bcb6fa257aca939a4ef35f0fa699fad9a03e4835169b6f4585"
  end

  resource "harlequin-odbc" do
    url "https:files.pythonhosted.orgpackages2915a382080b74b1f08a5b9d985a435afe413623f206ed8fc8a7b03be948da69harlequin_odbc-0.2.0.tar.gz"
    sha256 "9a61e182959642af1399df38b16c5027aa177af5b0e555f221f74daaafc91397"
  end

  resource "harlequin-postgres" do
    url "https:files.pythonhosted.orgpackages1226dc5d5369f1409e0d322e653bf8f6eb78da8f7002d0e5d854563d6514106bharlequin_postgres-1.0.0.tar.gz"
    sha256 "d7fb402e4639c33f6539673642c66411afeac740f18ca22255f5d37cebb8c101"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackages1903a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fdmdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  # upstream bug report on pypi artifact issue, https:bugs.mysql.combug.php?id=113396
  resource "mysql-connector-python" do
    url "https:github.commysqlmysql-connector-pythonarchiverefstags8.4.0.tar.gz"
    sha256 "52944d6fa84c903fd70723a47d2f8c3153c50ae91773f1584a7bd30606c58b35"
  end

  resource "numpy" do
    url "https:files.pythonhosted.orgpackages656e09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesa1e1bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "psycopg" do
    url "https:files.pythonhosted.orgpackagese0f2954b1467b3e2ca5945b83b5e320268be1f4df486c3e8ffc90f4e4b707979psycopg-3.2.4.tar.gz"
    sha256 "f26f1346d6bf1ef5f5ef1714dd405c67fb365cfd1c6cea07de1792747b167b92"
  end

  resource "psycopg-c" do
    url "https:files.pythonhosted.orgpackages1776dbdadd9b93b8ad38cff31402c73a6bb9a23c88a4466fa09655d3c6db4d11psycopg_c-3.2.4.tar.gz"
    sha256 "22097a04263efb2efd2cc8b00a51fa90e23f9cd4a2e09903fe4d9c6923dac17a"
  end

  resource "psycopg-pool" do
    url "https:files.pythonhosted.orgpackages497101d4e589dc5fd1f21368b7d2df183ed0e5bbc160ce291d745142b229797bpsycopg_pool-3.2.4.tar.gz"
    sha256 "61774b5bbf23e8d22bedc7504707135aaf744679f8ef9b3fe29942920746a6ed"
  end

  resource "pyarrow" do
    url "https:files.pythonhosted.orgpackages7b01fe1fd04744c2aa038e5a11c7a4adb3d62bce09798695e54f7274b5977134pyarrow-19.0.0.tar.gz"
    sha256 "8d47c691765cf497aaeed4954d226568563f1b3b74ff61139f2d77876717084b"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyodbc" do
    url "https:files.pythonhosted.orgpackagesa036a1ac7d23a1611e7ccd4d27df096f3794e8d1e7faa040260d9d41b6fc3185pyodbc-5.2.0.tar.gz"
    sha256 "de8be39809c8ddeeee26a4b876a6463529cd487a60d1393eb2a93e9bcd44a8f5"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "questionary" do
    url "https:files.pythonhosted.orgpackagesa8b8d16eb579277f3de9e56e5ad25280fab52fc5774117fb70362e8c2e016559questionary-2.1.0.tar.gz"
    sha256 "6302cdd645b19667d8f6e6634774e9538bfcd1aad9be287e743d96cacaf95587"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rich-click" do
    url "https:files.pythonhosted.orgpackages9a31103501e85e885e3e202c087fa612cfe450693210372766552ce1ab5b57b9rich_click-1.8.5.tar.gz"
    sha256 "a3eebe81da1c9da3c32f3810017c79bd687ff1b3fa35bfc9d8a3338797f1d1a1"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "shandy-sqlfmt" do
    url "https:files.pythonhosted.orgpackages3938f634ed73c65ba8e8061c65479af73e0b4afa53530af026489ca17b549559shandy_sqlfmt-0.24.0.tar.gz"
    sha256 "ae34d34dc88ef4a2c97677d7d3d95d7f362908aa6f97e3fb0529cab4a96799ba"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages4bcbb3ff0e45d812997a527cb581a4cd602f0b28793450aa26201969fd6ce42ctextual-0.89.1.tar.gz"
    sha256 "66befe80e2bca5a8c876cd8ceeaf01752267b6b1dc1d0f73071f1f1e15d90cc8"
  end

  resource "textual-fastdatatable" do
    url "https:files.pythonhosted.orgpackages06cc93f2131c7b4e388560cc633b5992c54ea56b7f1ef00a1641c0e33f92a722textual_fastdatatable-0.11.0.tar.gz"
    sha256 "a2305f5745dc1ab4088a3f0d5c7dcfb8993d711a296954664c3492712fa5cc4b"
  end

  resource "textual-textarea" do
    url "https:files.pythonhosted.orgpackagesda85e3dd273455337efe8e9f14bd8b048e7f22a40ad86615a69866a03967715ctextual_textarea-0.15.0.tar.gz"
    sha256 "1343604a4dc3bac0337c58d926a02ddcf451956fb12532a3d5ade9219905f426"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackages4a6471b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
  end

  # sdist issue report, https:github.comgrantjenkspy-tree-sitter-languagesissues63
  # https:github.comgrantjenkspy-tree-sitter-languagesissues54
  resource "tree-sitter-languages" do
    url "https:github.comgrantjenkspy-tree-sitter-languagesarchiverefstagsv1.10.2.tar.gz"
    sha256 "cdd03196ebaf8f486db004acd07a5b39679562894b47af6b20d28e4aed1a6ab5"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages917a146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    venv = virtualenv_install_with_resources without: "mysql-connector-python"

    # PyPI sdist is broken (missing at least setup.py)
    # https:bugs.mysql.combug.php?id=113396
    resource("mysql-connector-python").stage do
      venv.pip_install Pathname.pwd"mysql-connector-python"
    end

    generate_completions_from_executable(bin"harlequin", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}harlequin --profile none", 2)
    assert_match "Harlequin couldn't load your profile", output

    assert_match version.to_s, shell_output("#{bin}harlequin --version")
  end
end