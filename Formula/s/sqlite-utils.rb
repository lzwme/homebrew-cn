class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/84/39/4ce5c5ac7ac6a485349f8636a920cd2568bf8f11298519d552b0c57351db/sqlite-utils-3.35.1.tar.gz"
  sha256 "e0f03e6976b05bdb7a5c56454971a0e980fc16dbfd3512bbd3bdcac4f0e4370e"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87f9b93722bbd6e9dec772f16fb62c3aeb092ea23ba13ca0adc33d660f8cc581"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "726d86fb5289945e085538309593fc7fd4372cd9b6b7926c9576c9c2bee3d029"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d24eec9674d0c56155cec3853431530ddedca6e13dedf2dec22ed91ede2fa8cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb59d1fbd3438d52b4c6d7584253c3dd59bd57a5e4067b48d20d1e8a98151093"
    sha256 cellar: :any_skip_relocation, ventura:        "d95fdcc63de01fe7c5dc530d5e07f8bc015c61534af388d552743a789838bff5"
    sha256 cellar: :any_skip_relocation, monterey:       "aa337c7c341ffe2d017f14e3aa05316233a34a7a3328a00c94429cc48683e85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f530775c4033e2598e3a31ef9b32b76de5012bf2ade9f16cc1de2683e6d4fdd5"
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