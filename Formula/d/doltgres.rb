class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "8340d0ba1a193e8355d1b0c515c183927539766ccdf8a31b5d37e83ebd27e844"
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
    sha256 cellar: :any, arm64_golden_gate: "3c1b9f34fbe0ed9e2f11ef8ad79f1c15275b75d1ca2eae57aa430523dea9ef78"
    sha256 cellar: :any, arm64_tahoe:       "82d5d92acc97ac83eac45098baee4adcbe611d43507e60ff699ae7b694286f2d"
    sha256 cellar: :any, arm64_sequoia:     "1dce30cf58b0321dd17b57d2b410a3a2ed2e57cfe56738e589fde962bca4178f"
    sha256 cellar: :any, arm64_linux:       "25e8821d397ace8496c5e9bc3becd87cfb9fbb5a0a313e90e9ca544c04b3d01b"
    sha256 cellar: :any, x86_64_linux:      "ac4ad6696dc971b45e48dc3f3e2588ace0df46db4754c766c9a6e27f79542986"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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