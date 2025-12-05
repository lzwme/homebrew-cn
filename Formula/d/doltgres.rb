class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.53.6.tar.gz"
  sha256 "2c1194443829d0049f1e0791e4a2658b1b9d1f4025e5f1871cdd96095285b2d5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "aa1519f5124c8586e645f2783946358bad915486b7d3aa7ca95d35ac55559d80"
    sha256 cellar: :any,                 arm64_sequoia: "e377c2be348545cd3fa53f82a60022358ec48db63fa8d8a3145dc86813e44cd1"
    sha256 cellar: :any,                 arm64_sonoma:  "09ab0bf3e5ea61643ce5710674729c75967aee288837d0861bfc8092f98787ea"
    sha256 cellar: :any,                 sonoma:        "e6653e902f2890d9caf8d7542dceb1d4432dd9d8713125c6d86e85e60e34e972"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c0a046e28a9556823c79d3332d38f1de8d9aecb2912a7f1ffc139ce0053b6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e39118d1f6db10e28b5f4a985c6e4bfefe506eb2e1bd9e547241cc278a703e0f"
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