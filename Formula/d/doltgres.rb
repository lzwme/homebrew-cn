class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d8bfe342ac10d15b8ca3473114bff6603209342555b9c5f0b58a5f8ce4d07fc5"
  license "Apache-2.0"
  head "https://github.com/dolthub/doltgresql.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e0cb0303f2a1f473b6d16bd4d8d1a3f595ac2890a8c62ef19faf724664b6a167"
    sha256 cellar: :any, arm64_sequoia: "837127314555ba96d7c70dae0b7c6439a240398f8fd9c469c4f91143ec462e01"
    sha256 cellar: :any, arm64_sonoma:  "cd6d688f6871b58dc8d7733129aebdfdff968c128471212398c87795522fc298"
    sha256 cellar: :any, sonoma:        "bf182da5d48f0b604921a6605a7c8a50db0d033b15e0de7f91ed374412b96fa1"
    sha256 cellar: :any, arm64_linux:   "239bc61caa6b0a2fdea20aef692c17f4ef9c40ee57af8dc2fa8da42644791fe7"
    sha256 cellar: :any, x86_64_linux:  "39a1bc5e58f6eebcf71b3ac9d5d76fb27dfbee31257f0371cee7174f43e2f6cf"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args, "./cmd/doltgres"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      log_level: debug

      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    YAML

    spawn bin/"doltgres", "--config", testpath/"config.yaml"
    sleep 5

    psql = formula_opt_bin("libpq")/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end