class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.54.9.tar.gz"
  sha256 "10a50b73fd34b5595857dcf1898bd98377a14f488a552fe7828822114ac745a1"
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
    sha256 cellar: :any,                 arm64_tahoe:   "9947db439e8e1092c057336347f3411aff37328887f65535449269e12dfaf627"
    sha256 cellar: :any,                 arm64_sequoia: "119b3ba0c1e37d5378a7b67f8e9b554d7d5ff72550d992d80468150fa5c94051"
    sha256 cellar: :any,                 arm64_sonoma:  "ebedc58d43a5f8407de489e7f6b0ffbe5f836607c104435749a585a188bdc794"
    sha256 cellar: :any,                 sonoma:        "5ec9203c130b261b0817cbe1067af1507a35d8f5f4f621ad3c84cfe8c9cb0da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6703ce72841f81d5c6eeb6fcdd5382886aae76be30c0ec3bf29eaefadc1362d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a7057c3ce448835684fc54410639da248ad6b2f23621ae00db181ffdb4b62b8"
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