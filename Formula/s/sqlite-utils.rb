class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/10/91/4febf8cfe2d0b57a6a77595180bdb4ab97a89ffd36223ed295d1d8bfbbc7/sqlite-utils-3.35.2.tar.gz"
  sha256 "590b14ad277914cb3fc7d5e254764847facdaaa23c7bafd85ec93874f6f42143"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd0617c48470054ffffa495d247342f91b95ada7709a56f809b822d492ff7f0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19c1a36b27387fa7b5c654eb899b6ecaa0d171fbeaaa3136a689e18124877efa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df69a1c895c9b5b4b04301c6f13563fac63a0520e12bc4443189f8785b15c852"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dee7018b9a00c4ecd430c427cbd56b6f5d460145bba3be758c5bf9458e8a4c3"
    sha256 cellar: :any_skip_relocation, ventura:        "5e5b6a8fb6ede926950f099be2a50be9d2c9c569ba6cd45dd7781df0cb836f85"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe68b594eb09c6c2388ddead3bd1d863775efae65700a09ff3a1632ee6be850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abfcc2c852b750094f65425e8b90d0cdfe3c2ba881d77e4446868b9e3f9c0630"
  end

  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-pluggy"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sqlite-utils", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end