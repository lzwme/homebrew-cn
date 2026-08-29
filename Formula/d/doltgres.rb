class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "bfbdc568b1961bffb2e752ba6d96c8bd213bfb54946512086c76a784ca94c6fa"
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
    sha256 cellar: :any, arm64_tahoe:   "147a94b86ad0f385f53a80ee2a9fa0e090ef537842f403e17607dbaa08219aea"
    sha256 cellar: :any, arm64_sequoia: "451b6f7b70c327499e27f5721a564aa9424b55a4bfa951c56f694128912fa1ab"
    sha256 cellar: :any, arm64_sonoma:  "578b384dd42d1939ffe3cd3a3d6712c60697bdb35abab86c92764bcfb11bd368"
    sha256 cellar: :any, arm64_linux:   "b783b37565e291d8c3f4cbb72562219079720bc268d020485ab27066078f9451"
    sha256 cellar: :any, x86_64_linux:  "992740b822bf1ca4de95f5f00bf3826b3ac663e6834b0e65edba540a9e16e438"
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