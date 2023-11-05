class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/10/91/4febf8cfe2d0b57a6a77595180bdb4ab97a89ffd36223ed295d1d8bfbbc7/sqlite-utils-3.35.2.tar.gz"
  sha256 "590b14ad277914cb3fc7d5e254764847facdaaa23c7bafd85ec93874f6f42143"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb6f6d669566b74281d65fcc4157b952ec57b967e9ddedb30711f410e44127d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0acd4e40a96a5672909f7729f2a2e32db3265897e270747aaeba8e37fa880420"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6b7110638184196ebb0517447b5938758ed41ec585aa5d02eeb991a282963e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "67c70e5eca6263d4898057ab927f0a3eee92f4253458886f2751ff609194c17a"
    sha256 cellar: :any_skip_relocation, ventura:        "663d6c6d8355620a720a384e7d8b797fa09a347a04924caed23598b8640d69b1"
    sha256 cellar: :any_skip_relocation, monterey:       "62660205116777c23232f6fdfb01297b5b9ec1a96aa3ede781deb67534deae4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7332828175e3847cd75e065a2c4d39ee17506e398e56565ac84e9440189f614"
  end

  depends_on "python-click"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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