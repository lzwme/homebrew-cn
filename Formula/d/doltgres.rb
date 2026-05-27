class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "2fbc86c79f1579cb0de8019a1296ef1c25509076db1f3b26aba74e93c534220b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a85cb1cf93ae50c70d99702e9b2079c00f634066a84f7c2b4897dcf739e09438"
    sha256 cellar: :any,                 arm64_sequoia: "d602d1ad1734a812f88854b960324378c19c1205c8f833c19c224b058b36c00b"
    sha256 cellar: :any,                 arm64_sonoma:  "be81625ed08018ede525aa27c013ba1531d5a65545b3af24afa74bf7124b1826"
    sha256 cellar: :any,                 sonoma:        "10cdcbb07a6b2a95eabf249834de0cffda25309ba15b040ad5b77a308303a7a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ed8117f02786dc8253da5999d5177ee3050e848350c84f1131e494a399e6837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a870110f39eb36a89575867ea38ae818ae63a36e493ad8eb951400dbf9b6ea4"
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