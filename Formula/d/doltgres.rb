class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.55.2.tar.gz"
  sha256 "20a974d49cd9a56ce3dfe2f92946f11275700d1d272eb8675802a271cb422655"
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
    sha256 cellar: :any,                 arm64_tahoe:   "c0a893a5670aaf55ee48c417de411af98c1bfc37cdb6b74a8a1f68fc75f75860"
    sha256 cellar: :any,                 arm64_sequoia: "d214011e49d4c16057022ce60620b15ee40e570fba0a2d992313165cbe5471d8"
    sha256 cellar: :any,                 arm64_sonoma:  "e92652ac9cc007735ce39032d237cdd9602ca668b662945e014d78f4cb02909b"
    sha256 cellar: :any,                 sonoma:        "79091e9434e859dcc55b84b668c437ae4dc3af20fb875468c2b35d5eea537ae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cc0ef9606bfaa6b8e2816cf7a3d3d862fc8d38940d8b95671bab2bab233e2da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7742e82e8a21c737742b1a375769e1158ef16b9ebd6b6eb65eb5dca7f3f493"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/doltgres"
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

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end