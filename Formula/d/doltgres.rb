class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.55.5.tar.gz"
  sha256 "144dbc4ef605141855d68fd8802e0dbc578d43aa2bb7c14f5af03d9de5af30f5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "2978ff02c13ea4e7fae4b815e8a2904b6922920e879cf5a362142051462a3f5b"
    sha256 cellar: :any,                 arm64_sequoia: "d6ce44c444a061baf59713d2c2f712c915e3d00e9c31f7f828e535aa38d61969"
    sha256 cellar: :any,                 arm64_sonoma:  "0c22b7a460c82acc8417d7e31d5d8bd97d538aa94a5c813e4de92ea74c7f1b46"
    sha256 cellar: :any,                 sonoma:        "fef92cd639bb76e36884566006d7c8b0c1ddbee7fe8108954a5d9ed41e771f03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00bfd71ba6ab96c7f1c6ab83d5494c519629cd81c3c628a37922347c8e8b0c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93cd2cef38cddf0a3fcdd25896cb7461c611a506c2effb2af9cd7405217e9161"
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