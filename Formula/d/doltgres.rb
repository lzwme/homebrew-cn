class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.52.2.tar.gz"
  sha256 "69af3c15dc64653e6a6ad0ea1b25a1ca15a36ff4e3006a98ede8c3148061d8fc"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6c749a597b27bf9d34954a77425a41516625f2d2b1ad507c1dc152cab5f08fa8"
    sha256 cellar: :any,                 arm64_sequoia: "3b286d56fd7272530efd92f2de5ee606d652cab1c2c112e72ca2baee43fae487"
    sha256 cellar: :any,                 arm64_sonoma:  "cfa91c249769f6b755757681a4745816348e7ba43b4c66bf4e22de20ce3181b8"
    sha256 cellar: :any,                 sonoma:        "74485b1ed1f88d0055c64028fd0668042e211caab507fbdb785c404e0f75eda2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c9e0d49f68f5ee3442924c849154e8d14e45d155f140f4c696ef864802268a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1eeecf8706b5e8662f93e1d581f26e84bcdb8bf39409f4c3d33b24007ba2179"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@77"

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