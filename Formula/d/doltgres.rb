class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.8.tar.gz"
  sha256 "ebb893558a6dfcdc78a3de8786ce0e28354badbfd4938d029f9dd1c3510aa0b8"
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
    sha256 cellar: :any, arm64_tahoe:   "658e6adf46b940ea46bb52da46042706313a2988819ccd6d120c3cf5085f1387"
    sha256 cellar: :any, arm64_sequoia: "11891666296af0f00990e113f2c461cb02ad6a54003e5ca97b39748fd075e30c"
    sha256 cellar: :any, arm64_sonoma:  "6015d6735bbf8b1cdc099c4d6d98e551cebfb7eeaf8d08ab93f6f15d31bf5cad"
    sha256 cellar: :any, sonoma:        "346bdb8abd6099841fda8a5a2e339b6cb66e4e334ff97d9431074a348d469514"
    sha256 cellar: :any, arm64_linux:   "eb8ddedeb261c4e1885e3be013129b49135fc1a34af00c48f323813fc54c8c80"
    sha256 cellar: :any, x86_64_linux:  "b30a03b3f191fce1d17eefb63c276991a8f3bbc57afeda23080ca42661d1af3a"
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

    psql = formula_opt_bin("libpq")/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end