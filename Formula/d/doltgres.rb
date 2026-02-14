class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "9bc1548e02e874bc581965fbaa89ae698906584a887623143a2b0a6dc2a17d88"
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
    sha256 cellar: :any,                 arm64_tahoe:   "d9c8742be9aa92cdaa89e677e2cee07124dbaf47797452d6ef26dc510f6cbfa9"
    sha256 cellar: :any,                 arm64_sequoia: "1c6c0a83d7b987d607ecb281368f2ffc302ef0e72b984247c051a0fac2555abd"
    sha256 cellar: :any,                 arm64_sonoma:  "63e557ae2e145af8c8945eba5cb8852a3e5b316026bc6be9df22e932eb504bd5"
    sha256 cellar: :any,                 sonoma:        "37938d113912c7ede37518c2b45965dfdf4ad136a4a86b6e0def698f08b82101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0273a01d76e9cc18ef45bc0365c472988383810bdafb44c5e142e0859844b749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd8b32fa9b294b74534918e59d01b37298e04c2c9293cee60afc7c9834d0bdb"
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