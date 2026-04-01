class MysqlToSqlite3 < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from MySQL to SQLite"
  homepage "https://github.com/techouse/mysql-to-sqlite3"
  url "https://files.pythonhosted.org/packages/e9/a3/86a1d09b7fa439fb8b0ae2366a193f71a5abe47904f8da7e110923fd83a0/mysql_to_sqlite3-2.5.6.tar.gz"
  sha256 "d0d0e3cc6d8749eff0a0fcbd955d55b980f689baa20d5690849036ac8b7ca3ac"
  license "MIT"
  head "https://github.com/techouse/mysql-to-sqlite3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdb0d813141aff75fd42857d899e5081d7294754f8a3c4f62e69ba4f1ad4ce89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92c85ab67d9cba7c8509ee97d3a8b33bb32a4e40a77cb7a07f422e150e0565fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1e52afa8b16905c6b4dfe51776faa8498298de491bcddd9a2fe930f531bb58"
    sha256 cellar: :any_skip_relocation, sonoma:        "925f32f08e50b67695f8f08b9933d19bc53d08ebd24d3c60f069fc810d953f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0982f4eb2fb936dc48b9a25bd3f09b875fb799eea8f145d05a6cb8c9df632003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7296cb7a477e35100f43fdd2771b1cb709c565001355a9c99ceff4d7e2f697"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/6f/6e/c89babc7de3df01467d159854414659c885152579903a8220c8db02a3835/mysql_connector_python-9.6.0.tar.gz"
    sha256 "c453bb55347174d87504b534246fb10c589daf5d057515bf615627198a3c7ef1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pytimeparse2" do
    url "https://files.pythonhosted.org/packages/19/10/cc63fecd69905eb4d300fe71bd580e4a631483e9f53fdcb8c0ad345ce832/pytimeparse2-1.7.1.tar.gz"
    sha256 "98668cdcba4890e1789e432e8ea0059ccf72402f13f5d52be15bdfaeb3a8b253"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/41/f4/a1ac5ed32f7ed9a088d62a59d410d4c204b3b3815722e2ccfb491fa8251b/simplejson-3.20.2.tar.gz"
    sha256 "5fe7a6ce14d1c300d80d08695b7f7e633de6cd72c80644021874d985b3393649"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/d7/ae/afee950eff42a9c8ceab4a2e25abfeaa8278c578f967201824287cf530ce/sqlglot-30.1.0.tar.gz"
    sha256 "7593aea85349c577b269d540ba245024f91464afdcf61c6ef7765f4691c46ef8"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mysql2sqlite", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql2sqlite --version")

    port = free_port
    dummy_sqlite_file = testpath/"dummy.sqlite"
    output = shell_output("#{bin}/mysql2sqlite --sqlite-file #{dummy_sqlite_file} " \
                          "--mysql-database nonexistent --mysql-user root --mysql-port #{port} 2>&1", 1)
    assert_match "Can't connect to MySQL server", output
  end
end