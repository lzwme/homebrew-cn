class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://ghproxy.com/https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "9f998e2ed293c6689c3088236d50bae994403ec9642518050caa4ed0f0444878"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eff09d243709c23375603f711cff62f1a227f03d4666ecbe85918720688802ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f9a93b5572773b0737408eac7bbf2bb89b0de9ace6e0e8ed089caea94b13c3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "722850443147e3e49fe6b5ce734655373372d0c11594ac2f6bb82c6ff66ae125"
    sha256 cellar: :any_skip_relocation, ventura:        "472f7e80020af4738ecde8209849c04dc73c4e5fbaf6d013a72c268ac2238882"
    sha256 cellar: :any_skip_relocation, monterey:       "13f0963b979f7611af3b8175443cfafeaa5eef9743c5ce635cd3736c8a6ddfd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6f3c4d18159b281cd64e2e8c872cb5c660203e49aa02d9111cbb50c31adc9d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f766a5be46976c920e23e385c34cd9aeb5b0f5a098c955008572b039b4eec9b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X Main.Version=#{version}"), "./sql-migrate"
  end

  test do
    ENV["TZ"] = "UTC"

    test_config = testpath/"dbconfig.yml"
    test_config.write <<~EOS
      development:
        dialect: sqlite3
        datasource: test.db
        dir: migrations/sqlite3
    EOS

    mkdir testpath/"migrations/sqlite3"
    system bin/"sql-migrate", "new", "brewtest"

    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    test_sql = testpath/"migrations/sqlite3/#{timestamp}-brewtest.sql"
    assert_predicate test_sql, :exist?, "failed to create test.sql"

    output = shell_output("#{bin}/sql-migrate status")
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