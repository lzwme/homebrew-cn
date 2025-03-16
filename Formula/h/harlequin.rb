class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https:harlequin.sh"
  url "https:files.pythonhosted.orgpackages0bf6b1094cef796b4108c6fb40b16df7e977c944046c8215a5f610efc223e631harlequin-2.1.0.tar.gz"
  sha256 "45572f40558570f4e18e04415653ceff29dcb18437410a54ee7b20f15e95333d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce44267af453fc27558b8b7d5b0713e72ce4af02f228df13cd914a6018eb1a4b"
    sha256 cellar: :any,                 arm64_sonoma:  "555be4cba27eca2685a5ad33a47dbe6bbcfb04b824265d41676b872fbe330b84"
    sha256 cellar: :any,                 arm64_ventura: "4aee45bf2d24428250aec697423bfeb8119d1cf01363034dfb0a2ab7879f770a"
    sha256 cellar: :any,                 sonoma:        "3e4b9f4dab9c88c2f493d746f095773b64477bc4fb6997ff189e9c3db6894beb"
    sha256 cellar: :any,                 ventura:       "8a51e8b1b330c2786bf6c258b07e359a05536e9096b5f8480d2e6f2edf0171c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679b0b267649f490042745ff4574bcc8c23fdc1e7a52559b39e1821502e11c4f"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "apache-arrow"
  depends_on "libpq" # psycopg
  depends_on "numpy"
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
    url "https:files.pythonhosted.orgpackages5a25886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "duckdb" do
    url "https:files.pythonhosted.orgpackagese3e25e6820ec8cc50c4ab6172debea68e2236ea6a5d9caa56297cfb42fca1fa2duckdb-1.2.0.tar.gz"
    sha256 "a5ce81828e6d1c3f06836d3bda38eef8355765f08ad5ce239abd6f56934dd1f8"
  end

  resource "harlequin-mysql" do
    url "https:files.pythonhosted.orgpackages44e1d210f15f8090a7c0834b3bf90c46d202028d401fe96e9dd86e59abfaad40harlequin_mysql-1.1.0.tar.gz"
    sha256 "7a5a82e5c2eb9383a30443d387a139a4509b111afc2fe935b619e6c73409ee7b"
  end

  resource "harlequin-odbc" do
    url "https:files.pythonhosted.orgpackages332fdd73b3d42d5f4f071310e4762cfb900ca6eee59c70fbe1ab7af27a776785harlequin_odbc-0.3.0.tar.gz"
    sha256 "e69872ffbc86893d26ae1d9602b200e40b04d0b18a84e5d06d2b525e6ea10d69"
  end

  resource "harlequin-postgres" do
    url "https:files.pythonhosted.orgpackagesafd3ec374f95a2a4a2eecf4cbd256d018bd1fbd45df97466f5fba253d91fa352harlequin_postgres-1.2.0.tar.gz"
    sha256 "f544b469a5cfd85f9454cf69638dcaa67074e4a0b4fee0f1ae964060e27e451d"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
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

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesa1e1bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "psycopg" do
    url "https:files.pythonhosted.orgpackages6797eea08f74f1c6dd2a02ee81b4ebfe5b558beb468ebbd11031adbf58d31be0psycopg-3.2.6.tar.gz"
    sha256 "16fa094efa2698f260f2af74f3710f781e4a6f226efe9d1fd0c37f384639ed8a"
  end

  resource "psycopg-c" do
    url "https:files.pythonhosted.orgpackages2ff1367a2429af2b97f6a46dc116206cd3b1cf668fca7ff3c22b979ea0686427psycopg_c-3.2.6.tar.gz"
    sha256 "b5fd4ce70f82766a122ca5076a36c4d5818eaa9df9bf76870bc83a064ffaed3a"
  end

  resource "psycopg-pool" do
    url "https:files.pythonhosted.orgpackagescf131e7850bb2c69a63267c3dbf37387d3f71a00fd0e2fa55c5db14d64ba1af4psycopg_pool-3.2.6.tar.gz"
    sha256 "0f92a7817719517212fbfe2fd58b8c35c1850cdd2a80d36b581ba2085d9148e5"
  end

  resource "pyarrow" do
    url "https:files.pythonhosted.orgpackages7f09a9046344212690f0632b9c709f9bf18506522feb333c894d0de81d62341apyarrow-19.0.1.tar.gz"
    sha256 "3bf266b485df66a400f282ac0b6d1b500b9d2ae73314a153dbe97d6d5cc8a99e"
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
    url "https:files.pythonhosted.orgpackagesa67a4b78c5997f2a799a8c5c07f3b2145bbcda40115c4d35c76fbadd418a3c89rich_click-1.8.8.tar.gz"
    sha256 "547c618dea916620af05d4a6456da797fbde904c97901f44d2f32f89d85d6c84"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages32d27b171caf085ba0d40d8391f54e1c75a1cda9255f542becf84575cfd8a732setuptools-76.0.0.tar.gz"
    sha256 "43b4ee60e10b0d0ee98ad11918e114c70701bc6051662a9a675a0496c1a158f4"
  end

  resource "shandy-sqlfmt" do
    url "https:files.pythonhosted.orgpackagese98243763176f899a87ea66cfe335659862ca2c623de7382d164f01ea35519fdshandy_sqlfmt-0.26.0.tar.gz"
    sha256 "d95abd381640a846c71b0e2effb30d47f0b3eb5f69fb337fafe663634857f7a5"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages4bcbb3ff0e45d812997a527cb581a4cd602f0b28793450aa26201969fd6ce42ctextual-0.89.1.tar.gz"
    sha256 "66befe80e2bca5a8c876cd8ceeaf01752267b6b1dc1d0f73071f1f1e15d90cc8"
  end

  resource "textual-fastdatatable" do
    url "https:files.pythonhosted.orgpackagesefda9e86cadf3824df250126616a19d3b79f48f13e0f336605e1a2ab3d5a0aeftextual_fastdatatable-0.12.0.tar.gz"
    sha256 "56b035e22d694fa902a8b80120765addd6e32f4eee0151ee46fa6ab1deaad59e"
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