class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https:github.comrubenvsql-migrate"
  url "https:github.comrubenvsql-migratearchiverefstagsv1.7.2.tar.gz"
  sha256 "7bc0fc31a635c12ee04f56909fb8d5139299e8a13aecdbdd52c9fa947bd0d083"
  license "MIT"
  head "https:github.comrubenvsql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5842804c23640c47fb4defa4d8dac6e52a6d2dd9c72badc9b9d027274df78fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "068a8599bfc689f18ba0ec31b6a09530074f8ecf1b6f7f65a4fcbfb551c0abcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e19858e8f6da877188730ea8e5e647745cf0d3ceef8b434c6adf1ecb2ce68f51"
    sha256 cellar: :any_skip_relocation, sonoma:        "23fdf3f9ea69ee8b931eb5188d3611dae596fd9b0e0a91dacc1e1edfc460569c"
    sha256 cellar: :any_skip_relocation, ventura:       "8022f791e4f0f63e1fbaa36f3ec5c223bc1152c7da2d7b27ef6bce3b8b481aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e5346375315b77f43f017d7704aecb64e19fe4ece732eb3380c3762a72a1a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da39772b546a204e6da07bc23841403a68ab28873e07a573bb417b1a014f66b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X Main.Version=#{version}"), ".sql-migrate"
  end

  test do
    ENV["TZ"] = "UTC"

    test_config = testpath"dbconfig.yml"
    test_config.write <<~YAML
      development:
        dialect: sqlite3
        datasource: test.db
        dir: migrationssqlite3
    YAML

    mkdir testpath"migrationssqlite3"
    system bin"sql-migrate", "new", "brewtest"

    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    test_sql = testpath"migrationssqlite3#{timestamp}-brewtest.sql"
    assert_path_exists test_sql, "failed to create test.sql"

    output = shell_output("#{bin}sql-migrate status")
    expected = <<~EOS
      +-----------------------------+---------+
      |          MIGRATION          | APPLIED |
      +-----------------------------+---------+
      | #{timestamp}-brewtest.sql | no      |
      +-----------------------------+---------+
    EOS
    assert_equal expected, output
  end
end