class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "529ab20226ffd03e167a5034d85ce4d5a12c36e4b834cd91da21caca8a9079ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed4e194d9c42b2c6bc661e7d9dd6cc97099ae81c9173cb4137ffc9bf1b492bad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d32b55ca0e7d661c4484a86e95beb0c3226a60bb98c22038b627475ad6f814"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a67fc37cc9ae3578c1a4b9fd324818ed28a096b9c468808347ac94393bcca8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8633233374be341234fa4ea58cbdb18d2fc1b1f522eeb180d1629ac6563adf6"
    sha256 cellar: :any_skip_relocation, ventura:       "65ecaefafe787ff6aee79dcd1545b253c3b8153c335fe9ab16a7ca54316e1c4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4beb5112fcb31437e19873f03dc35741da455fbc3c55435ce54bb965ae63c1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29fa433e2c871176800fa927653ee031eb8a03665319bba535eaba4a559bc0a"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
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

    fork do
      exec bin/"doltgres", "--config", testpath/"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end