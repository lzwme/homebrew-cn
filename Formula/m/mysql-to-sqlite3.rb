class MysqlToSqlite3 < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from MySQL to SQLite"
  homepage "https://techouse.github.io/mysql-to-sqlite3/"
  url "https://files.pythonhosted.org/packages/bb/6d/b54e03a421bb7fe15ca46bcd432bd843007e4d8ab4a3db484b87b6b9b964/mysql_to_sqlite3-2.6.1.tar.gz"
  sha256 "6966d3ed22b7a981303c87b8692449f81cea1a1f7405b28588a10043d55fe148"
  license "MIT"
  head "https://github.com/techouse/mysql-to-sqlite3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7d6d440524c684c5578d174181ff3cb70fd93ac94fcc8809d5fd1722df320d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7eab98d6ff584142d452febc9e9617ec3f00030e4244003c14fae365c45555c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce7c37e26ff4c431958187ac7b402af2f5f82915d1bf4d1321beca70bda36ecc"
    sha256 cellar: :any,                 arm64_linux:       "0f6a60b110f5239d45b1419cf8521cf02425ae2771a67e21d61882020cf8eef0"
    sha256 cellar: :any,                 x86_64_linux:      "4a2c4bd072395bced5542f748d468a853c22bb2f37a4866466308f377644be65"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/f2/ce/a53b169388f8c6a595cfa9a653138381f3afef1d2af60f5c1972d015f52f/mysql_connector_python-26.7.0.tar.gz"
    sha256 "d8ff5ee236ea46661ee639336323e124ed868e37f3ea991bdc5de5a146f39fd5"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/d8/ca/5740963aa82f2c9dd025d71f1b6cce2159545f9e60dcb86a447d1cf92252/python_slugify-9.1.0.tar.gz"
    sha256 "3f02e8a0639c61e37eca5a783aae09112796d15d331ee3d5372241b61ee05f1c"
  end

  resource "pytimeparse2" do
    url "https://files.pythonhosted.org/packages/19/10/cc63fecd69905eb4d300fe71bd580e4a631483e9f53fdcb8c0ad345ce832/pytimeparse2-1.7.1.tar.gz"
    sha256 "98668cdcba4890e1789e432e8ea0059ccf72402f13f5d52be15bdfaeb3a8b253"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/f1/e3/1cc7dbf4deebc16e9dc42db37f473b5b612d021eb10e69974be308425171/simplejson-4.1.2.tar.gz"
    sha256 "6ae4186f90362e9c03c80a1cd5062a20f3a11ac9d391f7ee0ef0701a0e2b7394"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/e4/73/5b5ce3e23b3ded3ea1986c2c2991217460d5fd5161b3e00a8425f5dcb8a3/sqlglot-30.18.0.tar.gz"
    sha256 "e57e1b205e341979d1df5b1212c1435c598a0437e4619e3f428b15d5bc3a5cc6"
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
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
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