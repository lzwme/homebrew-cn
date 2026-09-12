class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "8ad58d78fbb70e9f2c410acfc13fb62281ca42e7c52344a1ee84df67cdd5c6ac"
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
    sha256 cellar: :any, arm64_golden_gate: "df7029eef2ed22775cea26d22eb3e10d7a8500a7628096a722b256747deeae54"
    sha256 cellar: :any, arm64_tahoe:       "6f1af389a8eadee2e2db38ab8a14c4d17a31802b4aa43b9a8056ce73230f5a4b"
    sha256 cellar: :any, arm64_sequoia:     "4f762e9b691c1ab80b63ca9742419bba3defd4c5b5610682679ac2f33c295c3d"
    sha256 cellar: :any, arm64_linux:       "f1dfed6a13b0ff89275c52adacb274a2c224d3b3cc88e0bf5d51e7d37ab45d3b"
    sha256 cellar: :any, x86_64_linux:      "8348b8a6f762b8951187c2f4da0d80855459fc3bc084bf3913c4e480c9366651"
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