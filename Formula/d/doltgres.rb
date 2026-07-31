class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "04dc6373d83c368157fbe82b3d4ef8979d720fcc356caa77cbb1bf1516113d2c"
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
    sha256 cellar: :any, arm64_tahoe:   "209bd4aef7b5492c48d83cb2ca44762d5022a9f69e8a2f7062af10da94e93d06"
    sha256 cellar: :any, arm64_sequoia: "5fe99de57dcbe38963d2c7bceb916d5814f5cfcbdb3a5e1514636ec51395313b"
    sha256 cellar: :any, arm64_sonoma:  "483d202b158c47fe86da79590ab6041e2184b3d562bfd2c8d542ec5f6e7cbc20"
    sha256 cellar: :any, sonoma:        "9c66e6bfa8f51eac665ea9045f8fdd24d89f446dfa45800e54ff1565ecc4d873"
    sha256 cellar: :any, arm64_linux:   "4e8f27af311a9d14cf3f69105646ce5afcafbe7b4c22c0c07200384fba4acc17"
    sha256 cellar: :any, x86_64_linux:  "ec21b47af246acb63ce90f1ff40a7851fcd296d23e75d65f7357758dcfe90e51"
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