class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "6b4b2240e276f931d15f33067221e538a25bfe495276ab82b57e240fd31c9b44"
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
    sha256 cellar: :any,                 arm64_tahoe:   "cf904e66a7f1659ac9f6e2cf12300ebcb105d4e9d00e313a1a464e62f3be6261"
    sha256 cellar: :any,                 arm64_sequoia: "81d0f342b91ed61ab9c93c66bf67ae061ff8da28f68fb189d1783d099e122a0f"
    sha256 cellar: :any,                 arm64_sonoma:  "54e39b6cc35fdb58a4d4f1603701768b70e6120ba585d315277ee91e2720e632"
    sha256 cellar: :any,                 sonoma:        "04ac851e64f056ac75c31b455c64bd50d4921ef8cdf797501977fa3d93f93c2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e6ab5755eca5ccc2f3ecc991657422d24f5195900980ffb5c78643386567d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "507ad4ccd4cdb321de1a20d50b11fd10a9ead8f4032db6ddc0c9c72cc87da77a"
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